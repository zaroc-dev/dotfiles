"""Merge configured Brave bar bookmarks while preserving personal bookmarks."""

import argparse
import copy
import fcntl
import hashlib
import json
import os
from pathlib import Path
import shutil
import signal
import socket
import subprocess
import tempfile
import time
import uuid


def nodes(node):
    yield node
    for child in node.get("children", []):
        yield from nodes(child)


def merge(document, configured):
    result = copy.deepcopy(document)
    bar = result["roots"]["bookmark_bar"]
    existing = bar["children"]
    next_id = max(int(n["id"]) for root in result["roots"].values() for n in nodes(root)) + 1
    now = str(time.time_ns() // 1000 + 11644473600000000)
    selected = []
    used = set()
    for bookmark in configured:
        match = next((n for n in existing if n.get("url") == bookmark["url"] and id(n) not in used), None)
        if match is None:
            match = {
                "id": str(next_id), "guid": str(uuid.uuid4()),
                "type": "url", "date_added": now, "date_last_used": "0",
            }
            next_id += 1
        else:
            used.add(id(match))
        match.setdefault("guid", str(uuid.uuid4()))
        match.update(name=bookmark["name"], url=bookmark["url"])
        selected.append(match)
    bar["children"] = selected + [n for n in existing if id(n) not in used]
    if result == document:
        return document
    bar["date_modified"] = now
    # Chromium hashes IDs, UTF-16 titles, types and URLs in root traversal order.
    md5, sha256 = hashlib.md5(), hashlib.sha256()
    for key in ("bookmark_bar", "other", "synced"):
        for node in nodes(result["roots"][key]):
            payload = node["id"].encode() + node["name"].encode("utf-16le") + node["type"].encode()
            if node["type"] == "url":
                payload += node["url"].encode()
            md5.update(payload)
            sha256.update(payload)
    result["checksum"] = md5.hexdigest()
    if "checksum_sha256" in result:
        result["checksum_sha256"] = sha256.hexdigest()
    return result


def browser_pid(root):
    lock = root / "SingletonLock"
    if not lock.is_symlink():
        return None
    hostname, value = os.readlink(lock).rsplit("-", 1)
    if hostname != socket.gethostname():
        raise RuntimeError("Brave profile is locked by another host")
    proc = Path("/proc") / value
    if not proc.exists():
        return None
    if proc.stat().st_uid != os.getuid() or "brave" not in (proc / "exe").resolve().name.lower():
        raise RuntimeError("Cannot identify the process holding Brave's profile lock")
    return int(value)


def assert_closed(root):
    if browser_pid(root) is not None:
        raise RuntimeError("Brave reopened before bookmarks could be saved")
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as connection:
        connection.settimeout(1)
        try:
            connection.connect(str(root / "SingletonSocket"))
        except (ConnectionRefusedError, FileNotFoundError):
            return
    raise RuntimeError("Brave is still accepting profile connections")


def sync(root, seed, executable):
    profile = root / "Default"
    profile.mkdir(parents=True, exist_ok=True)
    configured = seed["roots"]["bookmark_bar"]["children"]
    if len({n["url"] for n in configured}) != len(configured):
        raise ValueError("Configured bookmark URLs must be unique")
    bookmarks = profile / "Bookmarks"
    read = lambda: json.loads(bookmarks.read_text()) if bookmarks.exists() else seed
    original = read()
    if bookmarks.exists() and merge(original, configured) == original:
        print("Brave bookmarks already match the configured list.")
        return
    pid = browser_pid(root)
    stopped = False
    try:
        if pid is not None:
            print("Restarting Brave to sync bookmarks.", flush=True)
            os.kill(pid, signal.SIGTERM)
            stopped = True
            deadline = time.monotonic() + 30
            while Path(f"/proc/{pid}").exists():
                if time.monotonic() > deadline:
                    stopped = False
                    raise RuntimeError("Brave did not exit; bookmarks were not changed")
                time.sleep(0.1)
        assert_closed(root)
        # Shutdown may have saved changes made since the initial read.
        original = read()
        updated = merge(original, configured)
        if bookmarks.exists():
            shutil.copy2(bookmarks, profile / "Bookmarks.before-nix-sync")
        fd, temporary = tempfile.mkstemp(prefix=".Bookmarks-sync-", dir=profile)
        try:
            with os.fdopen(fd, "w") as stream:
                json.dump(updated, stream, ensure_ascii=False, indent=2)
                stream.flush()
                os.fsync(stream.fileno())
            assert_closed(root)
            os.replace(temporary, bookmarks)
        finally:
            if os.path.exists(temporary):
                os.unlink(temporary)
        print(f"Synced {len(configured)} configured bookmarks; personal bookmarks preserved.")
    finally:
        if stopped:
            environment = os.environ.copy()
            runtime = environment.setdefault("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}")
            environment.setdefault("DBUS_SESSION_BUS_ADDRESS", f"unix:path={runtime}/bus")
            if "WAYLAND_DISPLAY" not in environment and "DISPLAY" not in environment:
                displays = sorted(Path(runtime).glob("wayland-*"))
                displays = [p for p in displays if p.is_socket()]
                if displays:
                    environment["WAYLAND_DISPLAY"] = displays[0].name
            subprocess.Popen([executable, "--restore-last-session"], env=environment,
                             stdin=subprocess.DEVNULL, stdout=subprocess.DEVNULL,
                             stderr=subprocess.DEVNULL, start_new_session=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("browser_dir", type=Path)
    parser.add_argument("seed", type=Path)
    parser.add_argument("executable")
    args = parser.parse_args()
    args.browser_dir.mkdir(parents=True, exist_ok=True)
    with (args.browser_dir / ".bookmarks-sync.lock").open("a") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        sync(args.browser_dir, json.loads(args.seed.read_text()), args.executable)
