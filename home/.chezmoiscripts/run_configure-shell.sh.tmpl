#!/bin/bash
# Run script to configure shell environment
# This script runs every time chezmoi apply is called
# shellcheck disable=SC1073,SC1009,SC1056,SC1072,SC1020

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_info "Configuring shell environment..."

# Set Zsh as default shell if it isn't already
if [[ "$SHELL" != *"zsh"* ]] && command -v zsh &> /dev/null; then
    log_info "Setting Zsh as default shell..."
    
    # Add zsh to allowed shells if not present
    if ! grep -q "$(which zsh)" /etc/shells; then
        echo "$(which zsh)" | sudo tee -a /etc/shells
    fi
    
    # Change default shell
    chsh -s "$(which zsh)"
    log_success "Default shell changed to Zsh"
else
    log_success "Zsh is already the default shell"
fi

# Create necessary directories
CONFIG_DIR="${HOME}/.config"
ZSH_CACHE_DIR="${CONFIG_DIR}/zsh/cache"
STARSHIP_CACHE_DIR="${CONFIG_DIR}/starship"

mkdir -p "$ZSH_CACHE_DIR"
mkdir -p "$STARSHIP_CACHE_DIR"

log_success "Shell cache directories created"

# Initialize starship configuration
if command -v starship &> /dev/null; then
    log_info "Initializing Starship prompt..."
    # Starship config is managed by chezmoi, just ensure it's working
    log_success "Starship prompt configured"
fi

{{- if eq .chezmoi.os "darwin" }}
# macOS-specific shell setup
log_info "Applying macOS-specific shell configurations..."

# Ensure Homebrew paths are available
{{- if eq .chezmoi.arch "arm64" }}
BREW_PREFIX="/opt/homebrew"
{{- else }}
BREW_PREFIX="/usr/local"
{{- end }}

if [[ -f "${BREW_PREFIX}/bin/brew" ]]; then
    eval "$(${BREW_PREFIX}/bin/brew shellenv)"
    log_success "Homebrew environment configured"
fi
{{- else if eq .chezmoi.os "linux" }}
# Linux-specific shell setup
log_info "Applying Linux-specific shell configurations..."

# Ensure Linuxbrew paths are available if installed
if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    log_success "Linuxbrew environment configured"
fi
{{- end }}

# Set up direnv if available
if command -v direnv &> /dev/null; then
    log_info "Setting up direnv integration..."
    # direnv will be hooked in shell configs
    log_success "Direnv ready for integration"
fi

log_success "Shell environment configuration complete!"
log_info "Please restart your shell or run 'exec \$SHELL' to apply all changes"
