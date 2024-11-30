# ~/.zshrc
# Zsh Configuration Aligned with Home Manager and Nushell

# Enable command-line completion
autoload -Uz compinit
compinit

# Enable autosuggestions
autoload -U zsh-autosuggestions
zle-line-init() {
    zle autosuggest-start
}
zle -N zle-line-init
bindkey '^[[A' history-substring-search-up

# Enable syntax highlighting
# source /path/to/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Load shell aliases from Home Manager
if [ -f ~/.config/aliases.sh ]; then
    source ~/.config/aliases.sh
fi

# Set terminal emulator
# export TERMINAL="/path/to/alacritty"

# Configure history
HISTSIZE=10000                      # Maximum number of commands to remember
SAVEHIST=10000                      # Maximum number of commands to save
HISTFILE=~/.zsh_history             # History file
setopt HIST_IGNORE_DUPS             # Ignore duplicate commands in history
setopt SHARE_HISTORY                # Share history between sessions
setopt APPEND_HISTORY               # Append to history file, don't overwrite it

# Prompt customization using Starship
eval "$(starship init zsh)"

# Add custom paths (aligning with Nushell PATH setup)
export PATH="$HOME/.local/bin:$PATH"
export PATH="/nix/var/nix/profiles/default/bin:$PATH"
export PATH="/run/current-system/sw/bin:$PATH"

# Zoxide initialization (if installed)
eval "$(zoxide init zsh)"
