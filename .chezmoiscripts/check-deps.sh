#!/bin/bash
# Dependency checker script for chezmoi
# This script checks if required tools are available before applying changes

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print status
print_status() {
    if [ "$1" = "ok" ]; then
        echo -e "${GREEN}✓${NC} $2"
    elif [ "$1" = "warn" ]; then
        echo -e "${YELLOW}⚠${NC} $2"
    else
        echo -e "${RED}✗${NC} $2"
    fi
}

echo "Checking dependencies for chezmoi dotfiles..."

# Essential tools
if command_exists git; then
    print_status "ok" "Git is installed"
else
    print_status "error" "Git is required but not installed"
    exit 1
fi

# Development tools
if command_exists brew; then
    print_status "ok" "Homebrew is installed"
else
    print_status "warn" "Homebrew not found - some packages may not install automatically"
fi

if command_exists code; then
    print_status "ok" "VS Code is installed"
else
    print_status "warn" "VS Code not found - editor configuration may not work"
fi

# Shell tools
if command_exists zsh; then
    print_status "ok" "Zsh is installed"
else
    print_status "warn" "Zsh not found - shell configuration may not work optimally"
fi

if command_exists starship; then
    print_status "ok" "Starship prompt is installed"
else
    print_status "warn" "Starship not found - prompt configuration may not work"
fi

# Terminal tools
if command_exists tmux; then
    print_status "ok" "Tmux is installed"
else
    print_status "warn" "Tmux not found - terminal multiplexing configuration may not work"
fi

if command_exists ghostty; then
    print_status "ok" "Ghostty terminal is installed"
else
    print_status "warn" "Ghostty not found - terminal configuration may not apply"
fi

# Text editors
if command_exists helix; then
    print_status "ok" "Helix editor is installed"
else
    print_status "warn" "Helix not found - editor configuration may not work"
fi

if command_exists nvim; then
    print_status "ok" "Neovim is installed"
else
    print_status "warn" "Neovim not found - editor configuration may not work"
fi

# Development environments
if command_exists python3; then
    print_status "ok" "Python 3 is installed"
else
    print_status "warn" "Python 3 not found - Python development configuration may not work"
fi

if command_exists node; then
    print_status "ok" "Node.js is installed"
else
    print_status "warn" "Node.js not found - JavaScript development configuration may not work"
fi

if command_exists rustc; then
    print_status "ok" "Rust is installed"
else
    print_status "warn" "Rust not found - Rust development configuration may not work"
fi

echo
echo "Dependency check complete. Warnings are non-critical but may affect functionality."
