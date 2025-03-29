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

# Load custom aliases and functions
[ -f "$HOME/dotfiles/cli/aliases.sh" ] && source "$HOME/dotfiles/cli/aliases.sh"

# >>> Keybindings <<<
bindkey '^w' autosuggest-execute
bindkey '^e' autosuggest-accept
bindkey '^u' autosuggest-toggle
bindkey '^L' vi-forward-word
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search
