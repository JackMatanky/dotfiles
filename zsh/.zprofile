# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/zsh/.zprofile
# Description: Zsh login shell configuration for macOS.
#              Sources .zshrc, initializes SSH agent via keychain,
#              and exports SSH_AUTH_SOCK to GUI apps.
# -----------------------------------------------------------------------------

# --- Source .zshrc if it exists ---
ZSHRC="$HOME/.config/zsh/.zshrc"
[[ -f "$ZSHRC" ]] && source "$ZSHRC"


# --- Keychain SSH Agent Setup ---
export SSH_KEY="$HOME/.ssh/id_ed25519"
eval "$(keychain --eval --quiet --nogui "$SSH_KEY")"

# --- Export SSH_AUTH_SOCK to GUI (MacOS) ---
if [[ -n "$SSH_AUTH_SOCK" ]]; then
  launchctl setenv SSH_AUTH_SOCK "$SSH_AUTH_SOCK"
fi
