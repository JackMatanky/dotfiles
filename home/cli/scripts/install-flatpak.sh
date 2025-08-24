# -----------------------------------------------------------------------------
# Filename: ~/.config/scripts/install-flatpak.sh
# Docs: https://docs.flatpak.org/en/latest/
# Description: Installs Flatpak (if not installed) and Flatpak applications.
#   - Supports Ubuntu, Debian, Fedora, and Arch Linux.
# -----------------------------------------------------------------------------

#!/bin/bash

set -e  # Exit on error

# Define package directory
PACKAGES_DIR="$HOME/dotfiles/packages"
FLATPAK_MANIFEST="$PACKAGES_DIR/flatpak-manifest.json"

# Detect Linux distribution
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    DISTRO=$ID
else
    DISTRO="unknown"
fi

# Install Flatpak if not installed
if ! command -v flatpak &>/dev/null; then
    echo "🔹 Installing Flatpak..."
    case "$DISTRO" in
        ubuntu|debian) sudo apt install -y flatpak ;;
        fedora) sudo dnf install -y flatpak ;;
        arch) sudo pacman -S --noconfirm flatpak ;;
        *)
            echo "❌ Unsupported distro: $DISTRO. Install Flatpak manually."
            exit 1
            ;;
    esac
else
    echo "✅ Flatpak is already installed."
fi

# Install Flatpak applications if manifest exists
if [[ -f "$FLATPAK_MANIFEST" ]]; then
    echo "🔹 Installing Flatpak applications..."
    flatpak install -y --noninteractive < "$FLATPAK_MANIFEST"
    echo "✅ Flatpak applications installed!"
else
    echo "⚠️ No Flatpak manifest found at $FLATPAK_MANIFEST"
fi
