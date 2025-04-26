# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/zsh/.zshrc
# -----------------------------------------------------------------------------
# Suppress "Last login" message
touch ~/.hushlogin

# >>> Path Configuration <<<
typeset -U path cdpath fpath manpath

# >>> XDG Base Directory <<<
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# >>> Git Global Config Location <<<
export GIT_CONFIG_GLOBAL="$XDG_CONFIG_HOME/git/config"

# >>> Cargo Binaries <<<
export PATH="$HOME/.cargo/bin:$PATH"

# -----------------------------------------------
# Homebrew Installation Directory
# -----------------------------------------------
# Default fallback to empty string if OS is unknown
if [[ "$OS" == "Darwin" ]]; then
    export HOMEBREW="/opt/homebrew"
elif [[ "$OS" == "Linux" ]]; then
    export HOMEBREW="$(brew --prefix)"
fi

# >>> Path Configuration (OS-Specific) <<<
# Homebrew (Linuxbrew), Neovim, OpenJDK
if [[ "$OS" == "Darwin" ]]; then
    # macOS-specific paths
    export PATH="$HOMEBREW/bin:$PATH"
    export PATH="$HOMEBREW/bin/nvim:$PATH"
    export PATH="$HOMEBREW/opt/openjdk/bin:$PATH"
elif [[ "$OS" == "Linux" ]]; then
    # Linux-specific paths
    export PATH="$HOMEBREW/bin:$PATH"
    export PATH="/usr/bin/nvim:$PATH"
    export PATH="/usr/lib/jvm/java-17-openjdk-amd64/bin:$PATH"
fi

# >>> Build Flags for Brew-Linked Libraries <<<
# Help C extension modules (e.g., pygraphviz) locate Brew-installed headers and libraries
if [[ "$OS" == "Darwin" ]]; then
    export CFLAGS="-I$HOMEBREW/include"
    export LDFLAGS="-L$HOMEBREW/lib"
elif [[ "$OS" == "Linux" ]]; then
    export CFLAGS="-I$HOMEBREW/include"
    export LDFLAGS="-L$HOMEBREW/lib"
fi

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

# -----------------------------------------------
# Tooling & Integrations
# -----------------------------------------------
# >>> ZSH Plugins <<<
# --- ZSH Completion System ---
autoload -U compinit
compinit

# --- ZSH Autosuggestions ---
ZSH_AUTOSUGGESTIONS_RELATIVE="share/zsh-autosuggestions/zsh-autosuggestions.zsh"

if [[ -f "$HOMEBREW/$ZSH_AUTOSUGGESTIONS_RELATIVE" ]]; then
    source "$HOMEBREW/$ZSH_AUTOSUGGESTIONS_RELATIVE"
elif [[ -f "/usr/$ZSH_AUTOSUGGESTIONS_RELATIVE" ]]; then
    source "/usr/$ZSH_AUTOSUGGESTIONS_RELATIVE"
elif [[ -n "$(ls /nix/store/*zsh-autosuggestions*/zsh-autosuggestions.zsh 2>/dev/null)" ]]; then
    source "$(ls /nix/store/*zsh-autosuggestions*/zsh-autosuggestions.zsh 2>/dev/null)"
fi

# --- ZSH Syntax Highlighting ---
ZSH_SYNTAX_HIGHLIGHTING_RELATIVE="share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"


if [[ -f "$HOMEBREW/$ZSH_SYNTAX_HIGHLIGHTING_RELATIVE" ]]; then
    source "$HOMEBREW/$ZSH_SYNTAX_HIGHLIGHTING_RELATIVE"
elif [[ -f "/usr/$ZSH_SYNTAX_HIGHLIGHTING_RELATIVE" ]]; then
    source "/usr/$ZSH_SYNTAX_HIGHLIGHTING_RELATIVE"
elif [[ -n "$(ls /nix/store/*zsh-syntax-highlighting*/zsh-syntax-highlighting.zsh 2>/dev/null)" ]]; then
    source "$(ls /nix/store/*zsh-syntax-highlighting*/zsh-syntax-highlighting.zsh 2>/dev/null)"
fifi

# >>> Starship Prompt <<<
if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
    export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
fi

# >>> Carapace Shell Completion <<<
if command -v carapace &>/dev/null; then
    source <(carapace _carapace bash)
fi

# >>> Atuin Shell History Replacement <<<
if command -v atuin &>/dev/null; then
    eval "$(atuin init bash)"
fi

# >>> Zoxide <<<
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init bash)"
fi

# >>> FD: File Finder <<<
# Docs: https://github.com/sharkdp/fd
if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type file --hidden --follow --color=always'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# >>> FZF: Fuzzy File Finder <<<
# Docs: https://junegunn.github.io/fzf/
export FZF_DEFAULT_OPTS='
    --height=40%
    --layout=reverse
    --info=inline
    --border
    --preview "bat --style=numbers --color=always {} || cat {}"
    --preview-window=right:60%
'

if command -v brew &>/dev/null; then
    if [[ -f "$HOMEBREW/opt/fzf/shell/key-bindings.zsh" ]]; then
        source "$HOMEBREW/opt/fzf/shell/key-bindings.zsh"
    fi
    if [[ -f "$HOMEBREW/opt/fzf/shell/completion.zsh" ]]; then
        source "$HOMEBREW/opt/fzf/shell/completion.zsh"
    fi
fi

# >>> Zellij: Terminal Multiplexer <<<
# Docs: https://zellij.dev/documentation/
export ZELLIJ_CONFIG_DIR="$XDG_CONFIG_HOME/zellij"
export ZELLIJ_LAYOUT_DIR="$ZELLIJ_CONFIG_DIR/layouts"
export ZELLIJ_THEME_DIR="$ZELLIJ_CONFIG_DIR/themes"

# -----------------------------------------------
# Specialized Configs
# -----------------------------------------------
# >>> Default Editors <<<
export EDITOR="nvim"        # NeoVim, 'hx' Helix
export VISUAL="zed"         # Zed
export TERMINAL="ghostty"   # Ghostty
export FILE_PICKER="yazi"   # Yazi

# >>> SSH <<<
export SSH_CONFIG_DIR="$XDG_CONFIG_HOME/ssh"
export SSH_CONFIG_FILE="$SSH_CONFIG_DIR/ssh-config"

# >>> Nushell <<<
export NU_CONFIG_DIR="$XDG_CONFIG_HOME/nushell"

# >>> Java <<<
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
