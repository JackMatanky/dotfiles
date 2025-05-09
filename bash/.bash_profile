# shellcheck shell=bash
# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/bash/.bash_profile
# -----------------------------------------------------------------------------

# --- Keychain SSH Agent Setup ---
export SSH_KEY="$HOME/.ssh/id_ed25519"
eval "$(keychain --eval --quiet --nogui "$SSH_KEY")"

# --- Export SSH_AUTH_SOCK to GUI (MacOS) ---
if [[ -n "$SSH_AUTH_SOCK" ]]; then
  launchctl setenv SSH_AUTH_SOCK "$SSH_AUTH_SOCK"
fi
