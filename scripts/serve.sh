#!/usr/bin/env bash
# Serve the site locally exactly as GitHub Pages will: static files, no build.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PORT="${PORT:-4321}"
echo "→ http://localhost:$PORT"
exec python3 -m http.server "$PORT" --directory "$ROOT/src"
