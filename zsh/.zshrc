# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/zsh/.zshrc
# -----------------------------------------------------------------------------
# Suppress "Last login" message
touch ~/.hushlogin

# >>> Path Configuration <<<
typeset -U path cdpath fpath manpath

# >>> XDG Base Directory <<<
export XDG_CONFIG_HOME="$HOME/.config"

if [[ "$OS" == "Darwin" ]]; then
    # MacOS-specific paths
    export PATH="/opt/homebrew/bin:$PATH" # Homebrew
    export PATH="/opt/homebrew/bin/nvim:$PATH" # Neovim
    export PATH="/opt/homebrew/opt/openjdk/bin:$PATH" # OpenJDK
elif [[ "$OS" == "Linux" ]]; then
    # Linux-specific paths
    export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH" # Linuxbrew
    export PATH="/usr/bin/nvim:$PATH" # Neovim
    export PATH="/usr/lib/jvm/java-17-openjdk-amd64/bin:$PATH" # OpenJDK
fi

# >>> Cargo Binaries <<<
export PATH="$HOME/.cargo/bin:$PATH"

# >>> Pyenv <<<
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Initialize pyenv
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)" # Enables virtualenv auto-activation


# Add Nix paths (NixOS-specific)
if [[ -d "/nix/var/nix/profiles/default" ]]; then
  for profile in ${(z)NIX_PROFILES}; do
    fpath+=($profile/share/zsh/site-functions $profile/share/zsh/$ZSH_VERSION/functions $profile/share/zsh/vendor-completions)
  done
  export PATH="/nix/var/nix/profiles/default/bin:$PATH"
  export HELPDIR="/nix/store/nw0648r93knk287wi8xga9jhhpm35g6g-zsh-5.9/share/zsh/$ZSH_VERSION/help"
fi

# >>> Language and Locale <<<
export LANG="en_US.UTF-8"

# >>> Session & Completion Files <<<
export ZSH_SESSION="$XDG_CONFIG_HOME/.zsh_sessions"
mkdir -p "$(dirname "$ZSH_SESSION")"

export ZCOMPFILE="$XDG_CONFIG_HOME/.zcompdump"
mkdir -p "$(dirname "$ZCOMPFILE")"

# >>> History Configuration <<<
export HISTSIZE=10000                           # Number of commands kept in memory
export SAVEHIST=10000                           # Number of commands saved to the file
export HISTFILE="$XDG_CONFIG_HOME/.zsh_history" # Location of the history file
mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK               # Prevent simultaneous history writes
setopt HIST_IGNORE_DUPS              # Ignore consecutive duplicates
setopt HIST_IGNORE_SPACE             # Ignore commands starting with a space
setopt SHARE_HISTORY                 # Share history across Zsh instances

# >>> Plugin Management <<<
# --- ZSH Completion System ---
autoload -U compinit
compinit

# --- ZSH Autosuggestions ---
if [[ "$OS" == "Darwin" ]]; then
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [[ "$OS" == "Linux" ]]; then
  if command -v brew &>/dev/null; then
    source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  elif [[ -d "/usr/share/zsh-autosuggestions" ]]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  fi
elif [[ -d "/nix/store" ]]; then
  source /nix/store/*zsh-autosuggestions*/zsh-autosuggestions.zsh
fi

# --- ZSH Syntax Highlighting ---
if [[ "$OS" == "Darwin" ]]; then
  SYNTAX_HIGHLIGHTING_PATH="$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  [[ -f "$SYNTAX_HIGHLIGHTING_PATH" ]] && source "$SYNTAX_HIGHLIGHTING_PATH"
elif [[ "$OS" == "Linux" ]]; then
  if command -v brew &>/dev/null; then
    source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  elif [[ -d "/usr/share/zsh-syntax-highlighting" ]]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  fi
elif [[ -d "/nix/store" ]]; then
  source /nix/store/*zsh-syntax-highlighting*/zsh-syntax-highlighting.zsh
fi

# --- Carapace Shell Completion ---
if command -v carapace &> /dev/null; then
  source <(carapace _carapace zsh)
fi

# --- Starship Prompt ---
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
  export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
fi

# --- Zoxide ---
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# --- FZF: Fuzzy File Finder ---
if command -v fd &> /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'

  if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
  fi
fi

# --- ZIDE ---
# Source: https://github.com/josephschmitt/zide
export ZIDE_LAYOUT_DIR="$XDG_CONFIG_HOME/zellij/layouts"
export ZIDE_ALWAYS_NAME="true"
export ZIDE_FILE_PICKER="yazi"
export ZIDE_USE_YAZI_CONFIG="$XDG_CONFIG_HOME/yazi"

# >>> Aliases <<<
# Import aliases from a separate file
# source "$HOME/dotfiles/cli/aliases.sh"

# --- Shell Commands ---
alias c='clear'
alias ll='ls -l'

# --- eza: Modern ls ---
# Detailed list of all files (hidden included), with icons and Git info
alias l="eza --long --icons --git --all --group-directories-first"

# Tree view with details, 2 levels deep
alias lt="eza --tree --level=2 --long --icons --git"

# Compact tree view, 2 levels deep
alias ltree="eza --tree --level=2 --icons --git"

# --- zoxide ---
alias za='zoxide add'
alias zq='zoxide query'

# --- Navigation ---
# cx: cd into a directory and list its contents.
# Example: cx Documents/Projects
cx() {
  cd "$@" && l
}

# fcd: Fuzzy search for a directory and cd into it.
# Example: fcd
fcd() {
  cd "$(find . -type d -not -path '*/.*' | fzf)" && l
}

# f: Fuzzy search for a file and copy its path to the clipboard.
# Example: f
f() {
  echo "$(find . -type f -not -path '*/.*' | fzf)" | pbcopy
}

# fv: Fuzzy search for a file and open it in Neovim.
# Example: fv
fv() {
  nvim "$(find . -type f -not -path '*/.*' | fzf)"
}

# --- Directories ---
alias conf_dir='cd ~/.config'
alias docs='cd ~/Documents'

# Dotfiles
alias dot='cd ~/dotfiles'
alias dot_nix='cd ~/dotfiles/nixos'

# Obsidian Vault
alias obsidian='cd ~/obsidian_vault'
alias obsidian_gpl='cd ~/obsidian_vault; git pull'

# Keyboard Development
alias kb_dev='cd ~/Documents/keyboard_dev'
alias kb_ergogen='cd ~/Documents/keyboard_dev/ergogen'
alias kb_zmk='cd ~/Documents/keyboard_dev/zmk-config'
alias kb_snak_dir='cd ~/Documents/keyboard_dev/kb_snak'

# --- Nix ---
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

# --- Git ---
# Add
alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch'
alias gau='git add --update'

# Commit
alias gc='git commit -m'
alias gcam='git commit --all --message'

# Push
alias gps='git push'
alias gpsog='git push origin'

# Pull
alias gpl='git pull'
alias gplog='git pull origin'

# Fetch
alias gf='git fetch'
alias gfo='git fetch origin'

# Branch
alias gb='git branch'
alias gbra='git branch --all'
alias gbd='git branch --delete'
alias gbD='git branch --delete --force'

# Checkout
alias gco='git checkout'
alias gcm='git checkout (git_main_branch)'
alias gcb='git checkout -b'
alias gcoa='git checkout -- .'

# Remote
alias gr='git remote'
alias gra='git remote add'
alias grset='git remote set-url'

# Reset
alias grs='git reset'
alias grsh='git reset --hard'

# Diff
alias gdiff='git diff'

# Status
alias gst='git status'

# Log
alias gl='git log'
alias glog='git log --graph --topo-order --pretty="%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N" --abbrev-commit'

# Config
alias gcf='git config --list'

# Remove .DS_Store Files
grmds() {
    git rm --cached '*.DS_Store'
    git commit --all --message 'Remove .DS_Store files'
}

# --- Vim ---
alias v='nvim'
alias vdiff='nvim -d'

# --- Zellij ---
# Run Zellij in a particular directory
zj_dot() {
    cd ~/dotfiles/ && zellij
}
zj_obsidian() {
    cd ~/obsidian_vault/ && zellij
}
zj() {
    case "$1" in
        "dot")
            cd ~/dotfiles/ && zellij attach dotfiles
            ;;
        "dotvim")
            cd ~/dotfiles/nvim/ && zellij attach neovim_config
            ;;
        "obsidian")
            cd ~/obsidian_vault/ && zellij attach obsidian_vault
            ;;
        *)
            cd "${1:-$HOME}" && zellij
            ;;
    esac
}

# Run Zellij with the welcome screen
alias zj_welcome="zellij -l welcome"

# --- Yazi ---
# Shell wrapper function "yz"
function yz() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# --- Aerospace ---
as() {
    case "$1" in
        "load")
            aerospace reload-config
            ;;
        "debug")
            aerospace debug-windows
            ;;
        "monitor")
            aerospace list-monitors
            ;;
        "app")
            aerospace list-apps
            ;;
        "window")
            local selection
            selection=$(aerospace list-windows --all | fzf --bind 'enter:execute(aerospace focus --window-id {})+abort' | tr -d '\n')
            ;;
        *)
            echo "Usage: as <command>"
            echo "Available commands: load, debug, monitor, app, window"
            ;;
    esac
}

# --- Sketchybar ---
alias bar_load="sketchybar --reload"

# >>> Specialized Configs <<<
# --- Default Editors ---
export EDITOR="nvim"        # NeoVim, 'hx' Helix
export VISUAL="zed"         # Zed
export TERMINAL="ghostty"   # Ghostty
export FILE_PICKER="yazi"   # Yazi

# --- SSH ---
export SSH_CONFIG_DIR="$XDG_CONFIG_HOME/ssh"
export SSH_CONFIG_FILE="$SSH_CONFIG_DIR/ssh-config"

# --- Nushell ---
export NU_CONFIG_DIR="$XDG_CONFIG_HOME/nushell"

# --- Java ---
if [[ "$OS" == "Darwin" ]]; then
    export JAVA_HOME=$(/usr/libexec/java_home -v 23)
elif [[ "$OS" == "Linux" ]]; then
    export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
fi

# >>> Keybindings <<<
bindkey '^w' autosuggest-execute
bindkey '^e' autosuggest-accept
bindkey '^u' autosuggest-toggle
bindkey '^L' vi-forward-word
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search
