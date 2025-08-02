# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/scripts/install-rust.sh
# Docs: https://doc.rust-lang.org/cargo/getting-started/installation.html
# Github: https://github.com/rust-lang
# Description: Installs Rust, Cargo, and Cargo packages from a package list.
# -----------------------------------------------------------------------------

#!/bin/bash

set -e  # Exit on error

# Define package list location
PACKAGES_DIR="$HOME/dotfiles/packages"
CARGO_PACKAGES="$PACKAGES_DIR/cargo-packages.txt"

# 🦀 Install Rust & Cargo
if ! command -v cargo &>/dev/null; then
    echo "🦀 Installing Rust & Cargo..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    echo "✅ Rust & Cargo installed!"

    # Restart the shell so Cargo is available immediately
    exec "$SHELL"
fi

# 📦 Install Cargo packages
if [[ -f "$CARGO_PACKAGES" ]]; then
    echo "🔹 Installing Cargo packages from $CARGO_PACKAGES..."
    while read -r package; do
        cargo install "$package"
    done < "$CARGO_PACKAGES"
    echo "✅ Cargo packages installed!"
else
    echo "⚠️ Cargo package list not found: $CARGO_PACKAGES"
fi
