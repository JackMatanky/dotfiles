# -----------------------------------------------------------------------------
# Filename: ~/.config/scripts/install-homebrew.sh
# Description:
# This script installs Homebrew and its required dependencies based on the OS.
# - macOS: Ensures Xcode Command Line Tools are installed before Homebrew.
# - Linux: Detects the distribution and installs required system packages.
# - Works on macOS (Intel & Apple Silicon) and major Linux distributions.
# -----------------------------------------------------------------------------

#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Detect OS and Architecture
OS="$(uname -s)"
ARCH="$(uname -m)"

# --------------------------------------------
# 🛠️ Function: Install Required Dependencies
# Ensures system dependencies are installed before Homebrew
# --------------------------------------------
install_homebrew_dependencies() {
    if [[ "$OS" == "Darwin" ]]; then
        echo "🍏 Installing Xcode Command Line Tools (Required for Homebrew)..."

        # Check if Xcode Command Line Tools are installed
        if ! xcode-select -p &>/dev/null; then
            xcode-select --install

            # Wait until installation is complete
            until xcode-select -p &>/dev/null; do
                sleep 5
            done
        else
            echo "✅ Xcode Command Line Tools already installed."
        fi

    elif [[ "$OS" == "Linux" ]]; then
        echo "🐧 Detecting Linux distribution..."

        # Identify the Linux distribution
        if [[ -f /etc/os-release ]]; then
            source /etc/os-release
            DISTRO=$ID
        else
            DISTRO="unknown"
        fi

        echo "🖥️ Detected Linux distribution: $DISTRO"

        # Install necessary build dependencies based on the detected distribution
        case "$DISTRO" in
            ubuntu|debian)
                echo "🔹 Installing dependencies for Ubuntu/Debian..."
                sudo apt-get update && sudo apt-get install -y build-essential procps curl file git
                ;;
            fedora|centos|rhel)
                echo "🔹 Installing dependencies for Fedora/CentOS/Red Hat..."
                sudo yum groupinstall -y 'Development Tools'
                sudo yum install -y procps-ng curl file git
                ;;
            arch)
                echo "🔹 Installing dependencies for Arch Linux..."
                sudo pacman -S --noconfirm base-devel procps-ng curl file git
                ;;
            *)
                echo "❌ Unsupported Linux distribution: $DISTRO. Please install dependencies manually."
                exit 1
                ;;
        esac
    fi
}

# --------------------------------------------
# 🍺 Function: Install Homebrew
# Downloads and installs Homebrew package manager
# --------------------------------------------
install_homebrew() {
    echo "🔹 Checking if Homebrew is already installed..."

    if ! command -v brew &>/dev/null; then
        echo "🍺 Installing Homebrew..."

        # Run Homebrew installation script
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        echo "✅ Homebrew installation complete!"
    else
        echo "✅ Homebrew is already installed."
    fi
}

# --------------------------------------------
# 🚀 Run the functions
# First, install required system dependencies
# Then, install Homebrew
# --------------------------------------------
install_homebrew_dependencies
install_homebrew

echo "✅ Homebrew setup complete!"
