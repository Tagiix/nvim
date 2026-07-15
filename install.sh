#!/usr/bin/env bash
# Symlink config files that live outside ~/.config/nvim into their expected locations.
# Run once after cloning on a new machine.

set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"

link() {
  local src="$REPO/$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  ln -sf "$src" "$dst"
  echo "  linked $dst → $src"
}

echo "Installing external config symlinks..."
link config/clangd/config.yaml ~/.config/clangd/config.yaml
echo "Done."
