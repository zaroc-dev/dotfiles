#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

if ! command -v uv >/dev/null 2>&1; then
    echo "Error: uv is required. Install it first, then rerun this script." >&2
    exit 1
fi

exec uv run python install.py "$@"
