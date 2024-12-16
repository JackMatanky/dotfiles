# --- Path Configuration ---
typeset -U path cdpath fpath manpath

# XDG Base Directory
export XDG_CONFIG_HOME="$HOME/.config"

# Add Homebrew paths (macOS-specific)
export PATH="/opt/homebrew/bin:$PATH"

# Add Nix paths (NixOS-specific)
if [[ -d "/nix/var/nix/profiles/default" ]]; then
  for profile in ${(z)NIX_PROFILES}; do
    fpath+=($profile/share/zsh/site-functions $profile/share/zsh/$ZSH_VERSION/functions $profile/share/zsh/vendor-completions)
  done
  export PATH="/nix/var/nix/profiles/default/bin:$PATH"
  export HELPDIR="/nix/store/nw0648r93knk287wi8xga9jhhpm35g6g-zsh-5.9/share/zsh/$ZSH_VERSION/help"
fi

# --- Language and Locale ---
export LANG="en_US.UTF-8"

# --- Plugin Management ---
# ZSH Autosuggestions
if [[ "$(uname)" == "Darwin" ]]; then
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [[ -d "/nix/store" ]]; then
  source /nix/store/*zsh-autosuggestions*/zsh-autosuggestions.zsh
fi

# ZSH Syntax Highlighting
if [[ "$(uname)" == "Darwin" ]]; then
  SYNTAX_HIGHLIGHTING_PATH="$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  [[ -f "$SYNTAX_HIGHLIGHTING_PATH" ]] && source "$SYNTAX_HIGHLIGHTING_PATH"
elif [[ -d "/nix/store" ]]; then
  source /nix/store/*zsh-syntax-highlighting*/zsh-syntax-highlighting.zsh
fi

# Carapace Shell Completion
if command -v carapace &> /dev/null; then
  source <(carapace _carapace zsh)
fi

# --- Starship Prompt ---
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
  export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
fi

# --- History Configuration ---
export HISTSIZE=10000                # Number of commands kept in memory
export SAVEHIST=10000                # Number of commands saved to the file
export HISTFILE="$HOME/.zsh_history"  # Location of the history file
mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK               # Prevent simultaneous history writes
setopt HIST_IGNORE_DUPS              # Ignore consecutive duplicates
setopt HIST_IGNORE_SPACE             # Ignore commands starting with a space
setopt SHARE_HISTORY                 # Share history across Zsh instances

# --- Aliases ---
# Import aliases from a separate file
# source "$HOME/dotfiles/cli/aliases.sh"

# Directory aliases
alias dot='cd ~/dotfiles'
alias dot_nix='cd ~/dotfiles/nixos'
alias obsidian='cd ~/obsidian_vault'
alias obsidian_gpl='cd ~/obsidian_vault; git pull'
alias vimdiff='nvim -d'

# Git aliases
alias gad='git add'
alias gad_d='git add .'
alias gad_p='git add -p'
alias gbr='git branch'
alias gbra='git branch -a'
alias gc='git commit -m'
alias gca='git commit -a -m'
alias gco='git checkout'
alias gcoall='git checkout -- .'
alias gdiff='git diff'
alias glog='git log --graph --topo-order --pretty='\''%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N'\'' --abbrev-commit'
alias gpl='git pull'
alias gpl_o='git pull origin'
alias gps='git push'
alias gps_o='git push origin'
alias grm='git remote'
alias grs='git reset'
alias gst='git status'

# Nix-specific aliases (only on NixOS)
if [[ -d "/nix/var/nix/profiles/default" ]]; then
  alias flake_rebuild='sudo nixos-rebuild switch --flake .'
  alias flake_rebuild_trace='sudo nixos-rebuild switch --flake . --show-trace'
  alias flake_up='sudo nix flake update'
  alias flake_up_trace='sudo nix flake update --show-trace'
  alias hm_switch='home-manager switch --flake .'
  alias hm_switch_trace='home-manager switch --flake . --show-trace'
  alias cg_empty='sudo nix-collect-garbage'
  alias cg_empty_all='sudo nix-collect-garbage -d'
fi

# --- SSH Config ---
export SSH_CONFIG_DIR="$XDG_CONFIG_HOME/ssh/config"

# --- Nushell Config ---
export NU_CONFIG_DIR="$XDG_CONFIG_HOME/nushell"

# --- Keybindings ---
bindkey '^w' autosuggest-execute
bindkey '^e' autosuggest-accept
bindkey '^u' autosuggest-toggle
bindkey '^L' vi-forward-word
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search
