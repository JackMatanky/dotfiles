# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/zsh/.zshrc
# -----------------------------------------------------------------------------
# Suppress "Last login" message
touch ~/.hushlogin

# ----------------------- Detect OS ---------------------- #
OS="$(uname -s)"

# ------------------ Path Configuration ------------------ #
typeset -U path cdpath fpath manpath

# ------------------ XDG Base Directory ------------------ #
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# -------------- Git Global Config Location -------------- #
export GIT_CONFIG_GLOBAL="$XDG_CONFIG_HOME/git/config"

# -------------------- Cargo Binaries -------------------- #
export PATH="$HOME/.cargo/bin:$PATH"

# -------------------------------------------------------- #
#              Homebrew Installation Directory             #
# -------------------------------------------------------- #
# Darwin = "/opt/homebrew"
# Linux = "/home/linuxbrew/.linuxbrew"
# Default fallback to empty string if OS is unknown
if [[ "$OS" == "Darwin" ]]; then
  HOMEBREW="/opt/homebrew"
elif [[ "$OS" == "Linux" ]]; then
  HOMEBREW="$(brew --prefix 2>/dev/null || echo "/home/linuxbrew/.linuxbrew")"
else
  HOMEBREW=""
fi
export HOMEBREW

# ------------------ Homebrew Base Paths ----------------- #
export BREW_OPT_DIR="${HOMEBREW:+$HOMEBREW/opt}"
export BREW_BIN_DIR="${HOMEBREW:+$HOMEBREW/bin}"
export BREW_SBIN_DIR="${HOMEBREW:+$HOMEBREW/sbin}"
export BREW_LIB_DIR="${HOMEBREW:+$HOMEBREW/lib}"
export BREW_INCLUDE_DIR="${HOMEBREW:+$HOMEBREW/include}"

# --------- Build Flags for Brew-Linked Libraries -------- #
# Help C extension modules (e.g., pygraphviz) locate
# Brew-installed headers and libraries
export CFLAGS="-I${BREW_INCLUDE_DIR}"
export LDFLAGS="-L${BREW_LIB_DIR}"

# ----------- Path Configuration (OS-Specific) ----------- #
# Homebrew (Linuxbrew), Neovim, OpenJDK
if [[ "$OS" == "Darwin" ]]; then
  # macOS-specific paths
  export PATH="$BREW_BIN_DIR:$PATH"
  export PATH="$BREW_BIN_DIR/nvim:$PATH"
  export PATH="$HOMEBREW/opt/openjdk/bin:$PATH"
elif [[ "$OS" == "Linux" ]]; then
  # Linux-specific paths
  export PATH="$BREW_BIN_DIR:$PATH"
  export PATH="/usr/bin/nvim:$PATH"
  export PATH="/usr/lib/jvm/java-17-openjdk-amd64/bin:$PATH"
fi


# -------------------------------------------------------- #
#          Programming Language Environment Setup          #
# -------------------------------------------------------- #

# ------------------- Pyenv Integration ------------------ #
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Initialize pyenv
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# Enables virtualenv auto-activation
eval "$(pyenv virtualenv-init -)"

# ------------------------- Java ------------------------- #
if [[ "$OS" == "Darwin" ]]; then
    export JAVA_HOME=$(/usr/libexec/java_home -v 23)
elif [[ "$OS" == "Linux" ]]; then
    export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
fi

# ---- Homebrew Ruby Path Prepend with Auto-Detection ---- #
if [[ "$OS" == "Darwin" ]]; then
  HOMEBREW_RUBY_BIN="$BREW_OPT_DIR/ruby/bin"
  if [[ -d "$HOMEBREW_RUBY_BIN" ]]; then
    HOMEBREW_RUBY_VERSION="$("$HOMEBREW_RUBY_BIN/ruby" --version | awk '{print $2}' | cut -d. -f1,2)"
    HOMEBREW_RUBY_GEMS_BIN="$BREW_LIB_DIR/ruby/gems/$HOMEBREW_RUBY_VERSION/bin"

    # Prepend Ruby and Gems bin directories to PATH
    export PATH="$HOMEBREW_RUBY_GEMS_BIN:$HOMEBREW_RUBY_BIN:$PATH"
  fi
fi

# ------------------------ Nushell ----------------------- #
export NU_CONFIG_DIR="$XDG_CONFIG_HOME/nushell"

# -------------------------------------------------------- #
#                Session & Completion Files                #
# -------------------------------------------------------- #
export ZSH_SESSION="$XDG_CONFIG_HOME/.zsh_sessions"
mkdir -p "$(dirname "$ZSH_SESSION")"

export ZCOMPFILE="$XDG_CONFIG_HOME/.zcompdump"
mkdir -p "$(dirname "$ZCOMPFILE")"

# -------------------------------------------------------- #
#                   History Configuration                  #
# -------------------------------------------------------- #
export HISTSIZE=10000                           # Number of commands kept in memory
export SAVEHIST=10000                           # Number of commands saved to the file
export HISTFILE="$XDG_CONFIG_HOME/.zsh_history" # Location of the history file
mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK               # Prevent simultaneous history writes
setopt HIST_IGNORE_DUPS              # Ignore consecutive duplicates
setopt HIST_IGNORE_SPACE             # Ignore commands starting with a space
setopt SHARE_HISTORY                 # Share history across Zsh instances


# -------------------------------------------------------- #
#                  Tooling & Integrations                  #
# -------------------------------------------------------- #

# ---------------------- ZSH Plugins --------------------- #
# ZSH Completion System
autoload -U compinit
compinit

# ZSH Autosuggestions
ZSH_AUTOSUGGESTIONS_RELATIVE="share/zsh-autosuggestions/zsh-autosuggestions.zsh"

if [[ -f "$HOMEBREW/$ZSH_AUTOSUGGESTIONS_RELATIVE" ]]; then
    source "$HOMEBREW/$ZSH_AUTOSUGGESTIONS_RELATIVE"
elif [[ -f "/usr/$ZSH_AUTOSUGGESTIONS_RELATIVE" ]]; then
    source "/usr/$ZSH_AUTOSUGGESTIONS_RELATIVE"
# elif [[ -n "$(ls /nix/store/*zsh-autosuggestions*/zsh-autosuggestions.zsh 2>/dev/null)" ]]; then
#     source "$(ls /nix/store/*zsh-autosuggestions*/zsh-autosuggestions.zsh 2>/dev/null)"
fi

# ZSH Syntax Highlighting
ZSH_SYNTAX_HIGHLIGHTING_RELATIVE="share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"


if [[ -f "$HOMEBREW/$ZSH_SYNTAX_HIGHLIGHTING_RELATIVE" ]]; then
    source "$HOMEBREW/$ZSH_SYNTAX_HIGHLIGHTING_RELATIVE"
elif [[ -f "/usr/$ZSH_SYNTAX_HIGHLIGHTING_RELATIVE" ]]; then
    source "/usr/$ZSH_SYNTAX_HIGHLIGHTING_RELATIVE"
# elif [[ -n "$(ls /nix/store/*zsh-syntax-highlighting*/zsh-syntax-highlighting.zsh 2>/dev/null)" ]]; then
#     source "$(ls /nix/store/*zsh-syntax-highlighting*/zsh-syntax-highlighting.zsh 2>/dev/null)"
fi

# -------------------- Starship Prompt ------------------- #
# Docs: https://starship.rs/config/
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
    export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
fi

# --------------- Carapace Shell Completion -------------- #
# Docs: https://carapace.sh
if command -v carapace &>/dev/null; then
    source <(carapace _carapace zsh)
fi

# ------------ Atuin Shell History Replacement ----------- #
# Docs: https://docs.atuin.sh
if command -v atuin &>/dev/null; then
    eval "$(atuin init zsh)"
fi

# ------------------------ Zoxide ------------------------ #
# Docs: https://github.com/ajeetdsouza/zoxide
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# -------------------- FD: File Finder ------------------- #
# Docs: https://github.com/sharkdp/fd
if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type file --hidden --follow --color=always'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# ---------------- FZF: Fuzzy File Finder ---------------- #
# Docs: https://junegunn.github.io/fzf/
export FZF_DEFAULT_OPTS='
    --height=40%
    --layout=reverse
    --info=inline
    --border
    --preview "bat --style=numbers --color=always {} || cat {}"
    --preview-window=right:60%
'

# If BREW_OPT_DIR is empty or unset, fall back to /opt/homebrew by default
FZF_DIR="${BREW_OPT_DIR:-/opt/homebrew/opt}/fzf/shell"
FZF_KEYBINDINGS="$FZF_DIR/key-bindings.zsh"
FZF_COMPLETIONS="$FZF_DIR/completion.zsh"

if command -v brew &>/dev/null; then
    if [[ -f "$FZF_KEYBINDINGS" ]]; then
        source "$FZF_KEYBINDINGS"
    fi
    if [[ -f "$FZF_COMPLETIONS" ]]; then
        source "$FZF_COMPLETIONS"
    fi
fi

# ------------- Zellij: Terminal Multiplexer ------------- #
# Docs: https://zellij.dev/documentation/
export ZELLIJ_CONFIG_DIR="$XDG_CONFIG_HOME/zellij"
export ZELLIJ_LAYOUT_DIR="$ZELLIJ_CONFIG_DIR/layouts"
export ZELLIJ_THEME_DIR="$ZELLIJ_CONFIG_DIR/themes"


# -------------------------------------------------------- #
#                    Specialized Configs                   #
# -------------------------------------------------------- #

# -------------------- Default Editors ------------------- #
export EDITOR="nvim"        # NeoVim, 'hx' Helix
export VISUAL="zed"         # Zed
export TERMINAL="ghostty"   # Ghostty
export FILE_PICKER="yazi"   # Yazi

# -------------------------- SSH ------------------------- #
export SSH_CONFIG_DIR="$XDG_CONFIG_HOME/ssh"
export SSH_CONFIG_FILE="$SSH_CONFIG_DIR/ssh-config"

# ------------------ Language and Locale ----------------- #
export LANG="en_US.UTF-8"

# ----------------- Aliases and Functions ---------------- #
# CLI Specific Paths
CLI_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/cli"
LIB_DIR="$CLI_DIR/lib"
SCRIPT_LOADER="$LIB_DIR/load_core.sh"
# SHELL_ALIASES="$CLI_DIR/aliases.sh"
# SHELL_FUNCTIONS="$CLI_DIR/functions.sh"

# Load core CLI support modules (log, source_sh_files)
# shellcheck source=/dev/null
[ -f "$SCRIPT_LOADER" ] && source "$SCRIPT_LOADER"

# Load all CLI scripts (aliases.sh, functions.sh, etc.)
source_sh_files "$CLI_DIR"

# # Load all CLI scripts, including custom aliases and function
# # via loader script, or fallback to manual sourcing
# if command -v source_sh_files &>/dev/null; then
#   source_sh_files "$CLI_DIR"
# else
#   for script in "$SHELL_ALIASES" "$SHELL_FUNCTIONS"; do
#     # shellcheck source=/dev/null
#     [ -f "$script" ] && source "$script"
#   done
# fi

# ---------------------- Keybindings --------------------- #
bindkey '^w' autosuggest-execute
bindkey '^e' autosuggest-accept
bindkey '^u' autosuggest-toggle
bindkey '^L' vi-forward-word
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search
