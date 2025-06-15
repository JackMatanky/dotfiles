# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/scripts/install-just.sh
# Source: https://github.com/casey/just
# Description: Installs `just`, a modern command runner, on macOS and Linux.
# - Uses the official installation script for pre-built binaries.
# - Installs `just` to `/usr/local/bin` for global access.
# -----------------------------------------------------------------------------

#!/bin/bash

set -e  # Exit on error

echo "🔹 Installing just..."

# Install `just` using the official script
curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin

echo "✅ just installed!"
