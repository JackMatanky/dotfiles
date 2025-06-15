# shellcheck shell=bash
# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/bash/.bash_profile
# Description: Bash login shell configuration for macOS.
#              Sources .bashrc, initializes SSH agent via keychain,
#              and exports SSH_AUTH_SOCK to GUI apps.
# -----------------------------------------------------------------------------

# --- Source .bashrc if it exists ---
BASHRC="$HOME/.config/bash/.bashrc"
[[ -f "$BASHRC" ]] && source "$BASHRC"

# --- Keychain SSH Agent Setup ---
export SSH_KEY="$HOME/.ssh/id_ed25519"
eval "$(keychain --eval --quiet --nogui "$SSH_KEY")"

# --- Export SSH_AUTH_SOCK to GUI (MacOS) ---
if [[ -n "$SSH_AUTH_SOCK" ]]; then
  launchctl setenv SSH_AUTH_SOCK "$SSH_AUTH_SOCK"
fi

# -------------------- Bash Completion ------------------- #
# Use HOMEBREW_PREFIX if available, fallback to default
# HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"
# if [[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]]; then
#   source "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
# fi
