#!/usr/bin/env python3
"""Interactive installer for this dotfiles repository."""

from __future__ import annotations

import os
import shlex
import shutil
import subprocess
import sys
from dataclasses import dataclass
from enum import Enum
from pathlib import Path
from typing import Annotated

try:
    import typer
except ImportError:
    print(
        "Typer is required. Install it with `sudo pacman -S python-typer` "
        "or `python -m pip install typer`.",
        file=sys.stderr,
    )
    raise SystemExit(1)


REPO_ROOT = Path(__file__).resolve().parent
app = typer.Typer(
    add_completion=False,
    context_settings={"help_option_names": ["-h", "--help"]},
    help="Install and configure ruzbyte dotfiles.",
)


class ShellChoice(str, Enum):
    skip = "skip"
    zsh = "zsh"
    fish = "fish"


class WindowManagerChoice(str, Enum):
    none = "none"
    niri = "niri"
    hyprland = "hyprland"
    both = "both"


class EditorChoice(str, Enum):
    neovim = "neovim"
    visual_studio_code_bin = "visual-studio-code-bin"
    zed = "zed"


class BrowserChoice(str, Enum):
    helium_browser_bin = "helium-browser-bin"
    brave_bin = "brave-bin"
    zen_browser_bin = "zen-browser-bin"


@dataclass(frozen=True)
class PackageGroup:
    name: str
    description: str
    packages: tuple[str, ...]
    installer: str = "pacman"
    default: bool = True


PACMAN_GROUPS = {
    "base": PackageGroup(
        name="base",
        description="core dotfile tooling and Wayland clipboard/screenshot utilities",
        packages=("stow", "wl-clipboard", "grim", "slurp", "cliphist"),
    ),
    "niri": PackageGroup(
        name="niri",
        description="Niri compositor and XWayland support",
        packages=("niri", "xwayland-satellite"),
    ),
    "hyprland": PackageGroup(
        name="hyprland",
        description="Hyprland compositor",
        packages=("hyprland", "hyprpaper"),
    ),
    "terminal": PackageGroup(
        name="terminal",
        description="shell, prompt, and CLI tools",
        packages=(
            "kitty",
            "zsh",
            "starship",
            "fastfetch",
            "bat",
            "eza",
            "fd",
            "ripgrep",
            "fzf",
            "jq",
            "htop",
            "lazygit",
            "yazi",
            "zoxide",
            "tree",
            "file",
            "unzip",
            "zsh-autosuggestions",
            "zsh-syntax-highlighting",
        ),
    ),
    "gaming": PackageGroup(
        name="gaming",
        description="gaming launchers and compatibility tools",
        packages=("steam", "lutris", "gamescope", "protontricks", "winetricks", "mangohud"),
        default=False,
    ),
    "editor-neovim": PackageGroup(
        name="editor-neovim",
        description="Neovim editor",
        packages=("neovim",),
    ),
    "editor-zed": PackageGroup(
        name="editor-zed",
        description="Zed editor",
        packages=("zed",),
        default=False,
    ),
    "android": PackageGroup(
        name="android",
        description="Android and Flutter pacman dependencies",
        packages=(),
        default=False,
    ),
}

AUR_GROUPS = {
    "aur": PackageGroup(
        name="aur",
        description="AUR font extras",
        packages=("ttf-jetbrains-mono-nerd",),
        installer="yay",
    ),
    "editor-visual-studio-code-bin": PackageGroup(
        name="editor-visual-studio-code-bin",
        description="Visual Studio Code",
        packages=("visual-studio-code-bin",),
        installer="yay",
        default=False,
    ),
    "gaming-aur": PackageGroup(
        name="gaming-aur",
        description="AUR gaming extras",
        packages=("protonplus",),
        installer="yay",
        default=False,
    ),
    "android-aur": PackageGroup(
        name="android-aur",
        description="Android Studio and Flutter",
        packages=("android-studio", "flutter"),
        installer="yay",
        default=False,
    ),
    "browser-helium-browser-bin": PackageGroup(
        name="browser-helium-browser-bin",
        description="Helium browser",
        packages=("helium-browser-bin",),
        installer="yay",
        default=False,
    ),
    "browser-brave-bin": PackageGroup(
        name="browser-brave-bin",
        description="Brave browser",
        packages=("brave-bin",),
        installer="yay",
        default=False,
    ),
    "browser-zen-browser-bin": PackageGroup(
        name="browser-zen-browser-bin",
        description="Zen browser",
        packages=("zen-browser-bin",),
        installer="yay",
        default=False,
    ),
}

CHROMIUM_BROWSERS = {BrowserChoice.helium_browser_bin, BrowserChoice.brave_bin}

BROWSER_DESKTOP_ENTRIES = {
    BrowserChoice.helium_browser_bin: {
        "name": "Helium Browser",
        "desktop_id": "helium-browser.desktop",
        "exec": "helium-browser",
        "icon": "helium-browser",
    },
    BrowserChoice.brave_bin: {
        "name": "Brave Browser",
        "desktop_id": "brave-browser.desktop",
        "exec": "brave",
        "icon": "brave-browser",
    },
}


def run(command: list[str], *, dry_run: bool) -> None:
    typer.echo(f"$ {shlex_join(command)}")
    if dry_run:
        return
    subprocess.run(command, check=True)


def run_shell(command: str, *, dry_run: bool) -> None:
    typer.echo(f"$ {command}")
    if dry_run:
        return
    subprocess.run(command, shell=True, check=True)


def shlex_join(command: list[str]) -> str:
    return shlex.join(command)


def prompt_bool(label: str, *, default: bool, assume_yes: bool, provided: bool | None) -> bool:
    if provided is not None:
        return provided
    if assume_yes:
        return default
    return typer.confirm(label, default=default)


def ensure_repo_root() -> None:
    if Path.cwd().resolve() != REPO_ROOT:
        raise typer.ClickException(f"run this from {REPO_ROOT}")


def ensure_arch() -> None:
    if not shutil.which("pacman"):
        raise typer.ClickException("this installer currently supports Arch-based systems with pacman")


def install_package_group(group: PackageGroup, *, dry_run: bool) -> None:
    if not group.packages:
        return
    installer = ["sudo", "pacman", "-S", "--needed"]
    if group.installer == "yay":
        installer = ["yay", "-S", "--needed"]
    run([*installer, *group.packages], dry_run=dry_run)


def ensure_yay(*, dry_run: bool) -> None:
    if shutil.which("yay"):
        return
    installer = REPO_ROOT / "scripts" / "install-yay.sh"
    if not installer.exists():
        raise typer.ClickException(f"missing yay installer at {installer}")
    run(["bash", str(installer)], dry_run=dry_run)


def configure_shell(shell: ShellChoice, *, dry_run: bool) -> None:
    if shell == ShellChoice.skip:
        return

    shell_path = shutil.which(shell.value)
    if shell_path is None:
        typer.echo(f"Skipping default shell change: `{shell.value}` is not installed yet.", err=True)
        return

    current_shell = os.environ.get("SHELL", "")
    if current_shell == shell_path:
        typer.echo(f"Default shell is already {shell_path}")
        return

    run(["chsh", "-s", shell_path], dry_run=dry_run)


def configure_git(name: str | None, email: str | None, *, dry_run: bool) -> None:
    if name:
        run(["git", "config", "--global", "user.name", name], dry_run=dry_run)
    if email:
        run(["git", "config", "--global", "user.email", email], dry_run=dry_run)


def stow_dotfiles(*, restow: bool, dry_run: bool) -> None:
    command = ["stow", "--restow", "."] if restow else ["stow", "."]
    run(command, dry_run=dry_run)


def selected_window_manager_groups(window_manager: WindowManagerChoice) -> list[str]:
    if window_manager in {WindowManagerChoice.niri, WindowManagerChoice.both}:
        groups = ["niri"]
    else:
        groups = []
    if window_manager in {WindowManagerChoice.hyprland, WindowManagerChoice.both}:
        groups.append("hyprland")
    return groups


def prompt_enum(enum_type: type[Enum], label: str, default: Enum):
    choices = "/".join(choice.value for choice in enum_type)
    while True:
        value = typer.prompt(f"{label} [{choices}]", default=default.value)
        try:
            return enum_type(value)
        except ValueError:
            typer.echo(f"Choose one of: {choices}", err=True)


def parse_editors(value: str) -> list[EditorChoice]:
    valid = {choice.value: choice for choice in EditorChoice}
    editors: list[EditorChoice] = []

    for raw_item in value.split(","):
        item = raw_item.strip()
        if not item:
            continue
        if item not in valid:
            choices = ", ".join(valid)
            raise typer.BadParameter(f"unknown editor `{item}`; choose from: {choices}")
        if valid[item] not in editors:
            editors.append(valid[item])

    return editors


def parse_browsers(value: str) -> list[BrowserChoice]:
    valid = {choice.value: choice for choice in BrowserChoice}
    browsers: list[BrowserChoice] = []

    for raw_item in value.split(","):
        item = raw_item.strip()
        if not item:
            continue
        if item not in valid:
            choices = ", ".join(valid)
            raise typer.BadParameter(f"unknown browser `{item}`; choose from: {choices}")
        if valid[item] not in browsers:
            browsers.append(valid[item])

    return browsers


def prompt_editors(*, assume_yes: bool, provided: str | None, no_editors: bool) -> list[EditorChoice]:
    if provided and no_editors:
        raise typer.BadParameter("use either --editors or --no-editors, not both")
    if no_editors:
        return []
    if provided is not None:
        return parse_editors(provided)
    if assume_yes:
        return [EditorChoice.neovim]

    choices = ", ".join(choice.value for choice in EditorChoice)
    value = typer.prompt(
        f"Code editors to install, comma-separated [{choices}]",
        default=EditorChoice.neovim.value,
    )
    return parse_editors(value)


def prompt_browsers(*, assume_yes: bool, provided: str | None, no_browsers: bool) -> list[BrowserChoice]:
    if provided and no_browsers:
        raise typer.BadParameter("use either --browsers or --no-browsers, not both")
    if no_browsers:
        return []
    if provided is not None:
        return parse_browsers(provided)
    if assume_yes:
        return []

    choices = ", ".join(choice.value for choice in BrowserChoice)
    value = typer.prompt(
        f"Browsers to install, comma-separated [{choices}]",
        default="",
        show_default=False,
    )
    return parse_browsers(value)


def add_editor_groups(
    editors: list[EditorChoice],
    pacman_groups: list[PackageGroup],
    aur_groups: list[PackageGroup],
) -> None:
    for editor in editors:
        if editor == EditorChoice.neovim:
            pacman_groups.append(PACMAN_GROUPS["editor-neovim"])
        elif editor == EditorChoice.zed:
            pacman_groups.append(PACMAN_GROUPS["editor-zed"])
        elif editor == EditorChoice.visual_studio_code_bin:
            aur_groups.append(AUR_GROUPS["editor-visual-studio-code-bin"])


def add_browser_groups(browsers: list[BrowserChoice], aur_groups: list[PackageGroup]) -> None:
    for browser in browsers:
        aur_groups.append(AUR_GROUPS[f"browser-{browser.value}"])


def selected_chromium_browsers(browsers: list[BrowserChoice]) -> list[BrowserChoice]:
    return [browser for browser in browsers if browser in CHROMIUM_BROWSERS]


def planned_chromium_basic_entries(
    browsers: list[BrowserChoice],
    *,
    assume_yes: bool,
    provided: bool | None,
) -> bool | None:
    chromium_browsers = selected_chromium_browsers(browsers)
    if not chromium_browsers:
        return False
    if provided is not None:
        return provided
    if assume_yes:
        return False
    return None


def confirm_chromium_basic_entries(browsers: list[BrowserChoice]) -> bool:
    chromium_browsers = selected_chromium_browsers(browsers)
    names = ", ".join(browser.value for browser in chromium_browsers)
    typer.echo(
        "\nWarning: --password-store=basic avoids KDE/Niri keyring session issues, "
        "but you should not store passwords in the browser's built-in password manager. "
        "Use an external manager such as Bitwarden instead.",
        err=True,
    )
    return typer.confirm(f"Create per-user desktop entries with --password-store=basic for {names}?", default=False)


def append_desktop_exec_flag(exec_value: str, flag: str) -> str:
    if flag in exec_value:
        return exec_value

    parts = exec_value.split()
    for index, part in enumerate(parts):
        if part.startswith("%"):
            parts.insert(index, flag)
            return " ".join(parts)

    return f"{exec_value} {flag}"


def desktop_entry_with_basic_password_store(browser: BrowserChoice) -> str:
    metadata = BROWSER_DESKTOP_ENTRIES[browser]
    source_paths = [
        Path("/usr/share/applications") / metadata["desktop_id"],
        Path("/usr/local/share/applications") / metadata["desktop_id"],
    ]

    for source_path in source_paths:
        if source_path.exists():
            lines = source_path.read_text().splitlines()
            updated_lines = [
                f"Exec={append_desktop_exec_flag(line.removeprefix('Exec='), '--password-store=basic')}"
                if line.startswith("Exec=")
                else line
                for line in lines
            ]
            return "\n".join(updated_lines) + "\n"

    return "\n".join(
        [
            "[Desktop Entry]",
            "Version=1.0",
            "Type=Application",
            f"Name={metadata['name']} (Basic Password Store)",
            f"Exec={metadata['exec']} --password-store=basic %U",
            f"Icon={metadata['icon']}",
            "Terminal=false",
            "Categories=Network;WebBrowser;",
            "StartupNotify=true",
            "",
        ]
    )


def create_chromium_basic_desktop_entries(browsers: list[BrowserChoice], *, dry_run: bool) -> None:
    desktop_dir = Path.home() / ".local" / "share" / "applications"
    chromium_browsers = selected_chromium_browsers(browsers)
    if not chromium_browsers:
        return

    typer.echo(
        "Creating browser launchers with --password-store=basic. "
        "Do not use the browser's built-in password storage with these launchers.",
        err=True,
    )
    for browser in chromium_browsers:
        metadata = BROWSER_DESKTOP_ENTRIES[browser]
        target = desktop_dir / metadata["desktop_id"]
        typer.echo(f"write {target}")
        if dry_run:
            continue
        desktop_dir.mkdir(parents=True, exist_ok=True)
        target.write_text(desktop_entry_with_basic_password_store(browser))


def print_plan(
    *,
    pacman_groups: list[PackageGroup],
    aur_groups: list[PackageGroup],
    editors: list[EditorChoice],
    browsers: list[BrowserChoice],
    chromium_basic_entries: bool | None,
    rust: bool,
    android: bool,
    update_system: bool,
    stow_files: bool,
    shell: ShellChoice,
    git_name: str | None,
    git_email: str | None,
) -> None:
    typer.echo("\nInstall plan")
    typer.echo(f"  System update: {'yes' if update_system else 'no'}")
    typer.echo(f"  Pacman groups: {', '.join(group.name for group in pacman_groups) or 'none'}")
    typer.echo(f"  AUR groups: {', '.join(group.name for group in aur_groups) or 'none'}")
    typer.echo(f"  Editors: {', '.join(editor.value for editor in editors) or 'none'}")
    typer.echo(f"  Browsers: {', '.join(browser.value for browser in browsers) or 'none'}")
    if chromium_basic_entries is None:
        typer.echo("  Chromium basic password-store launchers: ask after browser install")
    else:
        typer.echo(f"  Chromium basic password-store launchers: {'yes' if chromium_basic_entries else 'no'}")
    typer.echo(f"  Rust via rustup: {'yes' if rust else 'no'}")
    typer.echo(f"  Android/Flutter dev: {'yes' if android else 'no'}")
    typer.echo(f"  Stow dotfiles: {'yes' if stow_files else 'no'}")
    typer.echo(f"  Default shell: {shell.value}")
    if git_name or git_email:
        typer.echo(f"  Git identity: {git_name or '<unchanged>'} / {git_email or '<unchanged>'}")
    typer.echo()


@app.command()
def install(
    yes: Annotated[
        bool,
        typer.Option("--yes", "-y", help="Accept default choices and do not prompt."),
    ] = False,
    dry_run: Annotated[
        bool,
        typer.Option("--dry-run", help="Print commands without running them."),
    ] = False,
    update_system: Annotated[
        bool | None,
        typer.Option("--update-system/--skip-system-update", help="Run sudo pacman -Syu first."),
    ] = None,
    base: Annotated[
        bool | None,
        typer.Option("--base/--no-base", help=PACMAN_GROUPS["base"].description),
    ] = None,
    terminal: Annotated[
        bool | None,
        typer.Option("--terminal/--no-terminal", help=PACMAN_GROUPS["terminal"].description),
    ] = None,
    aur: Annotated[
        bool | None,
        typer.Option("--aur/--no-aur", help=AUR_GROUPS["aur"].description),
    ] = None,
    gaming: Annotated[
        bool | None,
        typer.Option("--gaming/--no-gaming", help="Install gaming pacman and AUR package groups."),
    ] = None,
    editors: Annotated[
        str | None,
        typer.Option(
            "--editors",
            help="Comma-separated editors to install: neovim, visual-studio-code-bin, zed.",
        ),
    ] = None,
    no_editors: Annotated[
        bool,
        typer.Option("--no-editors", help="Skip code editor installation."),
    ] = False,
    browsers: Annotated[
        str | None,
        typer.Option(
            "--browsers",
            help="Comma-separated browsers to install: helium-browser-bin, brave-bin, zen-browser-bin.",
        ),
    ] = None,
    no_browsers: Annotated[
        bool,
        typer.Option("--no-browsers", help="Skip browser installation."),
    ] = False,
    chromium_basic_password_store: Annotated[
        bool | None,
        typer.Option(
            "--chromium-basic-password-store/--no-chromium-basic-password-store",
            help="Create per-user Chromium browser launchers with --password-store=basic.",
        ),
    ] = None,
    rust: Annotated[
        bool | None,
        typer.Option("--rust/--no-rust", help="Install Rust using the official rustup shell installer."),
    ] = None,
    android: Annotated[
        bool | None,
        typer.Option("--android/--no-android", help="Install Android Studio and Flutter."),
    ] = None,
    window_manager: Annotated[
        WindowManagerChoice | None,
        typer.Option("--window-manager", "-w", help="Window manager packages to install."),
    ] = None,
    stow_files: Annotated[
        bool | None,
        typer.Option("--stow/--no-stow", help="Stow dotfiles into the home directory."),
    ] = None,
    restow: Annotated[
        bool,
        typer.Option("--restow/--no-restow", help="Use `stow --restow .` instead of `stow .`."),
    ] = True,
    shell: Annotated[
        ShellChoice | None,
        typer.Option("--shell", help="Set the default login shell after package installation."),
    ] = None,
    git_name: Annotated[
        str | None,
        typer.Option("--git-name", help="Set git user.name."),
    ] = None,
    git_email: Annotated[
        str | None,
        typer.Option("--git-email", help="Set git user.email."),
    ] = None,
) -> None:
    """Install package groups and stow this repository's dotfiles."""

    ensure_repo_root()
    if not dry_run:
        ensure_arch()

    install_base = prompt_bool(
        "Install base dotfile dependencies?",
        default=PACMAN_GROUPS["base"].default,
        assume_yes=yes,
        provided=base,
    )
    install_terminal = prompt_bool(
        "Install terminal packages?",
        default=PACMAN_GROUPS["terminal"].default,
        assume_yes=yes,
        provided=terminal,
    )
    install_aur = prompt_bool(
        "Install AUR packages?",
        default=AUR_GROUPS["aur"].default,
        assume_yes=yes,
        provided=aur,
    )
    install_gaming = prompt_bool(
        "Install gaming packages?",
        default=PACMAN_GROUPS["gaming"].default,
        assume_yes=yes,
        provided=gaming,
    )
    selected_editors = prompt_editors(assume_yes=yes, provided=editors, no_editors=no_editors)
    selected_browsers = prompt_browsers(assume_yes=yes, provided=browsers, no_browsers=no_browsers)
    create_basic_browser_entries = planned_chromium_basic_entries(
        selected_browsers,
        assume_yes=yes,
        provided=chromium_basic_password_store,
    )
    install_rust = prompt_bool(
        "Install Rust via rustup?",
        default=False,
        assume_yes=yes,
        provided=rust,
    )
    install_android = prompt_bool(
        "Install Android Studio and Flutter?",
        default=False,
        assume_yes=yes,
        provided=android,
    )
    should_update = prompt_bool(
        "Update system packages first?",
        default=True,
        assume_yes=yes,
        provided=update_system,
    )
    should_stow = prompt_bool(
        "Stow dotfiles?",
        default=True,
        assume_yes=yes,
        provided=stow_files,
    )

    if window_manager is None:
        if yes:
            window_manager = WindowManagerChoice.niri
        else:
            window_manager = prompt_enum(
                WindowManagerChoice,
                "Window manager packages to install",
                WindowManagerChoice.niri,
            )

    if shell is None:
        if yes:
            shell = ShellChoice.skip
        else:
            shell = prompt_enum(
                ShellChoice,
                "Set default shell",
                ShellChoice.skip,
            )

    pacman_groups: list[PackageGroup] = []
    aur_groups: list[PackageGroup] = []

    if install_base:
        pacman_groups.append(PACMAN_GROUPS["base"])
    for group_name in selected_window_manager_groups(window_manager):
        pacman_groups.append(PACMAN_GROUPS[group_name])
    if install_terminal:
        pacman_groups.append(PACMAN_GROUPS["terminal"])
    add_editor_groups(selected_editors, pacman_groups, aur_groups)
    add_browser_groups(selected_browsers, aur_groups)
    if install_gaming:
        pacman_groups.append(PACMAN_GROUPS["gaming"])

    if install_aur:
        aur_groups.append(AUR_GROUPS["aur"])
    if install_gaming:
        aur_groups.append(AUR_GROUPS["gaming-aur"])
    if install_android:
        aur_groups.append(AUR_GROUPS["android-aur"])

    print_plan(
        pacman_groups=pacman_groups,
        aur_groups=aur_groups,
        editors=selected_editors,
        browsers=selected_browsers,
        chromium_basic_entries=create_basic_browser_entries,
        rust=install_rust,
        android=install_android,
        update_system=should_update,
        stow_files=should_stow,
        shell=shell,
        git_name=git_name,
        git_email=git_email,
    )

    if not yes and not typer.confirm("Run this plan?", default=True):
        raise typer.Abort()

    if should_update:
        run(["sudo", "pacman", "-Syu"], dry_run=dry_run)

    for group in pacman_groups:
        install_package_group(group, dry_run=dry_run)

    if aur_groups:
        ensure_yay(dry_run=dry_run)
    for group in aur_groups:
        install_package_group(group, dry_run=dry_run)

    if create_basic_browser_entries is None:
        create_basic_browser_entries = confirm_chromium_basic_entries(selected_browsers)
    if create_basic_browser_entries:
        create_chromium_basic_desktop_entries(selected_browsers, dry_run=dry_run)

    if install_rust:
        run_shell("curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh", dry_run=dry_run)

    if should_stow:
        stow_dotfiles(restow=restow, dry_run=dry_run)

    configure_shell(shell, dry_run=dry_run)
    configure_git(git_name, git_email, dry_run=dry_run)

    typer.echo("Install complete.")


if __name__ == "__main__":
    app()
