#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
chatgpt_package="$repo_root/packages/chatgpt-desktop.nix"
claude_package="$repo_root/packages/claude-desktop.nix"
t3code_package="$repo_root/packages/t3code-nightly.nix"
work_dir="$(mktemp -d)"
update_succeeded=0

cleanup() {
  if [[ "$update_succeeded" != 1 ]]; then
    cp "$work_dir/chatgpt-desktop.nix" "$chatgpt_package"
    cp "$work_dir/claude-desktop.nix" "$claude_package"
    cp "$work_dir/t3code-nightly.nix" "$t3code_package"
  fi
  rm -rf "$work_dir"
}
trap cleanup EXIT

cp "$chatgpt_package" "$work_dir/chatgpt-desktop.nix"
cp "$claude_package" "$work_dir/claude-desktop.nix"
cp "$t3code_package" "$work_dir/t3code-nightly.nix"

chatgpt_rpm="$work_dir/chatgpt.x86_64.rpm"
claude_index="$work_dir/claude-Packages.gz"
claude_deb="$work_dir/claude-desktop.deb"
t3code_releases="$work_dir/t3code-releases.json"
t3code_deb="$work_dir/t3code-nightly.deb"

curl --fail --location --retry 3 --silent --show-error --output "$chatgpt_rpm" \
  https://persistent.oaistatic.com/codex-app-prod/linux/rpm/latest/chatgpt.x86_64.rpm
mkdir "$work_dir/rpmdb"
chatgpt_version="$(rpm --dbpath "$work_dir/rpmdb" --nosignature --query --package --queryformat '%{VERSION}' "$chatgpt_rpm")"
chatgpt_hash="$(nix hash file --type sha256 "$chatgpt_rpm")"

claude_repository=https://downloads.claude.ai/claude-desktop/apt/stable
curl --fail --location --retry 3 --silent --show-error --output "$claude_index" \
  "$claude_repository/dists/stable/main/binary-amd64/Packages.gz"

claude_version="$({
  gzip --decompress --stdout "$claude_index" \
    | awk 'BEGIN { RS = ""; FS = "\n" }
      {
        package = ""
        version = ""
        for (field = 1; field <= NF; field++) {
          if ($field ~ /^Package: /) package = substr($field, 10)
          if ($field ~ /^Version: /) version = substr($field, 10)
        }
        if (package == "claude-desktop") print version
      }' \
    | sort --version-sort \
    | tail --lines 1
})"

if [[ ! "$chatgpt_version" =~ ^[0-9][0-9A-Za-z.+~-]*$ ]]; then
  echo "Unexpected ChatGPT version: $chatgpt_version" >&2
  exit 1
fi
if [[ ! "$claude_version" =~ ^[0-9][0-9A-Za-z.+:~-]*$ ]]; then
  echo "Unexpected Claude version: $claude_version" >&2
  exit 1
fi

claude_filename="$({
  gzip --decompress --stdout "$claude_index" \
    | awk -v wanted="$claude_version" 'BEGIN { RS = ""; FS = "\n" }
      {
        package = ""
        version = ""
        filename = ""
        for (field = 1; field <= NF; field++) {
          if ($field ~ /^Package: /) {
            package = substr($field, 10)
          } else if ($field ~ /^Version: /) {
            version = substr($field, 10)
          } else if ($field ~ /^Filename: /) {
            filename = substr($field, 11)
          }
        }
        if (package == "claude-desktop" && version == wanted) print filename
      }'
})"

if [[ ! "$claude_filename" =~ ^pool/main/c/claude-desktop/[^/]+_amd64\.deb$ ]]; then
  echo "Unexpected Claude package path: $claude_filename" >&2
  exit 1
fi

curl --fail --location --retry 3 --silent --show-error --output "$claude_deb" \
  "$claude_repository/$claude_filename"
claude_hash="$(nix hash file --type sha256 "$claude_deb")"

curl --fail --location --retry 3 --silent --show-error --output "$t3code_releases" \
  'https://api.github.com/repos/pingdotgg/t3code/releases?per_page=100'
t3code_tag="$(jq --raw-output --exit-status '
  [.[] | select(.draft == false)
    | select(.tag_name | test("^v[0-9]+\\.[0-9]+\\.[0-9]+-nightly\\.[0-9]{8}\\.[0-9]+$"))]
  | max_by(.published_at)
  | .tag_name // error("No T3 Code desktop nightly release found")
' "$t3code_releases")"
t3code_version="${t3code_tag#v}"
if [[ ! "$t3code_version" =~ ^[0-9]+\.[0-9]+\.[0-9]+-nightly\.[0-9]{8}\.[0-9]+$ ]]; then
  echo "Unexpected T3 Code nightly version: $t3code_version" >&2
  exit 1
fi

curl --fail --location --retry 3 --silent --show-error --output "$t3code_deb" \
  "https://github.com/pingdotgg/t3code/releases/download/$t3code_tag/T3-Code-$t3code_version-amd64.deb"
t3code_hash="$(nix hash file --type sha256 "$t3code_deb")"

sed --in-place --regexp-extended \
  "s|version = \"[^\"]+\";|version = \"$chatgpt_version\";|" \
  "$chatgpt_package"
sed --in-place --regexp-extended \
  "s|hash = \"sha256-[^\"]+\";|hash = \"$chatgpt_hash\";|" \
  "$chatgpt_package"

sed --in-place --regexp-extended \
  "s|version = \"[^\"]+\";|version = \"$claude_version\";|" \
  "$claude_package"
sed --in-place --regexp-extended \
  "s|hash = \"sha256-[^\"]+\";|hash = \"$claude_hash\";|" \
  "$claude_package"

sed --in-place --regexp-extended \
  "s|version = \"[^\"]+\";|version = \"$t3code_version\";|" \
  "$t3code_package"
sed --in-place --regexp-extended \
  "s|hash = \"sha256-[^\"]+\";|hash = \"$t3code_hash\";|" \
  "$t3code_package"

nixfmt "$chatgpt_package" "$claude_package" "$t3code_package"

echo "ChatGPT Desktop: $chatgpt_version"
echo "Claude Desktop:  $claude_version"
echo "T3 Code Nightly: $t3code_version"
echo "Building updated packages..."
nix build "$repo_root#chatgpt-desktop" "$repo_root#claude-desktop" "$repo_root#t3code-nightly" --no-link

update_succeeded=1
echo "Desktop app pins updated and verified."
