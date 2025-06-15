#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# File: install_vscodium_extensions.sh
# Description: Install all VSCodium extensions listed in vscode-extensions.txt
# -----------------------------------------------------------------------------

# --- Setup ---

EXTENSION_LIST="$HOME/dotfiles/vscodium/extensions/vscode-extensions.txt"

if ! command -v codium &> /dev/null; then
  echo "Error: 'codium' command not found. Make sure VSCodium is installed and codium CLI is available."
  exit 1
fi

if [ ! -f "$EXTENSION_LIST" ]; then
  echo "Error: Extension list file not found: $EXTENSION_LIST"
  exit 1
fi

echo "Installing VSCodium extensions from $EXTENSION_LIST..."
echo

# --- Install each extension if not already installed ---

while IFS= read -r extension; do
  if codium --list-extensions | grep -q "^$extension$"; then
    echo "✅ Already installed: $extension"
  else
    echo "➤ Installing: $extension"
    codium --install-extension "$extension"
  fi
done < "$EXTENSION_LIST"

echo
echo "🎉 All extensions processed."
