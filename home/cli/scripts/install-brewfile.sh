# -----------------------------------------------------------------------------
# Filename: ~/.config/scripts/install-homebrew.sh
# Description:
# This script installs Homebrew packages using a Brewfile.
# - macOS: Ensures OpenJDK is properly symlinked after installation.
# - Linux: Uses Homebrew (Linuxbrew) to install the same packages.
# - Compatible with macOS (Intel & Apple Silicon) and Linux.
# -----------------------------------------------------------------------------

#!/bin/bash

set -e  # Exit on error

# Define the path to the packages directory
PACKAGES_DIR="$HOME/dotfiles/packages"

echo "🍺 Installing Homebrew packages from Brewfile..."

# Install all packages from the Brewfile
brew bundle --file="$PACKAGES_DIR/brewfile"

# Additional macOS setup (OpenJDK Symlink)
if [[ "$(uname -s)" == "Darwin" ]]; then
    if brew list openjdk &>/dev/null; then
        echo "🔹 Setting up OpenJDK symlink..."
        sudo ln -sfn "$(brew --prefix)/opt/openjdk/libexec/openjdk.jdk" /Library/Java/JavaVirtualMachines/openjdk.jdk
        echo "✅ OpenJDK symlinked successfully."
    else
        echo "⚠️ OpenJDK not found in Homebrew. Skipping symlink."
    fi
fi

echo "✅ Homebrew package installation complete!"
