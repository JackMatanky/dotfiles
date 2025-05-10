# shellcheck shell=bash
# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/bash/.bashrc
# Description: Bash interactive shell configuration for macOS and Linux.
#              Loads modular CLI environment, defines completions, history,
#              and initializes interactive tooling (e.g., direnv, starship).
# -----------------------------------------------------------------------------
# Suppress "Last login" message
touch ~/.hushlogin


# ---------------- Load Modular CLI Environment ---------------- #
# CLI Specific Paths
CLI_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/cli"
LIB_DIR="$CLI_DIR/lib"
SCRIPT_LOADER="$LIB_DIR/load_core.sh"

# Load core CLI support modules (log, source_sh_files)
# shellcheck source=/dev/null
[[ -f "$SCRIPT_LOADER" ]] && source "$SCRIPT_LOADER"

# Load environment variables (XDG paths, language setup, etc.)
source_sh_files "$CLI_DIR/profile"

# Load shell commands (aliases, functions, helpers, etc.)
source_sh_files "$CLI_DIR/cmd"

# # ------------------------- Detect OS ------------------------ #
# OS="$(uname -s)"

# # ------------------- XDG Base Directories ------------------- #
# export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
# export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
# export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
# export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# # --------------------- Git Configuration -------------------- #
# export GIT_CONFIG_GLOBAL="$XDG_CONFIG_HOME/git/config"

# # ---------------- Cargo: Rust Package Manager --------------- #
# export PATH="$HOME/.cargo/bin:$PATH"

# # -------------------------- Nushell ------------------------- #
# export NU_CONFIG_DIR="$XDG_CONFIG_HOME/nushell"


# # ------------------------------------------------------------ #
# #                Homebrew Installation Directory               #
# # ------------------------------------------------------------ #
# # Darwin = "/opt/homebrew"
# # Linux = "/home/linuxbrew/.linuxbrew"
# # Default fallback to empty string if OS is unknown
# if [[ "$OS" == "Darwin" ]]; then
#   HOMEBREW="/opt/homebrew"
# elif [[ "$OS" == "Linux" ]]; then
#   HOMEBREW="$(brew --prefix 2>/dev/null || echo "/home/linuxbrew/.linuxbrew")"
# else
#   HOMEBREW=""
# fi
# export HOMEBREW

# # -------------------- Homebrew Base Paths ------------------- #
# export BREW_OPT_DIR="${HOMEBREW:+$HOMEBREW/opt}"
# export BREW_BIN_DIR="${HOMEBREW:+$HOMEBREW/bin}"
# export BREW_SBIN_DIR="${HOMEBREW:+$HOMEBREW/sbin}"
# export BREW_LIB_DIR="${HOMEBREW:+$HOMEBREW/lib}"
# export BREW_INCLUDE_DIR="${HOMEBREW:+$HOMEBREW/include}"

# # ----------- Build Flags For Brew-Linked Libraries ---------- #
# # Help C extension modules (e.g., pygraphviz) locate
# # Brew-installed headers and libraries
# export CFLAGS="-I${BREW_INCLUDE_DIR}"
# export LDFLAGS="-L${BREW_LIB_DIR}"

# # ------------- Path Configuration (OS-Specific) ------------- #
# # Homebrew (Linuxbrew), Neovim, OpenJDK
# if [[ "$OS" == "Darwin" ]]; then
#   # macOS-specific paths
#   export PATH="$BREW_BIN_DIR:$PATH"
#   export PATH="$BREW_BIN_DIR/nvim:$PATH"
#   export PATH="$HOMEBREW/opt/openjdk/bin:$PATH"
# elif [[ "$OS" == "Linux" ]]; then
#   # Linux-specific paths
#   export PATH="$BREW_BIN_DIR:$PATH"
#   export PATH="/usr/bin/nvim:$PATH"
#   export PATH="/usr/lib/jvm/java-17-openjdk-amd64/bin:$PATH"
# fi


# ------------------------------------------------------------ #
#                     History Configuration                    #
# ------------------------------------------------------------ #
export HISTSIZE=10000
export HISTFILE="$XDG_CONFIG_HOME/.bash_history"
mkdir -p "$(dirname "$HISTFILE")"


# # ------------------------------------------------------------ #
# #            Programming Language Environment Setup            #
# # ------------------------------------------------------------ #

# # ------------- Pyenv: Python Version Management ------------- #
# # Docs: https://github.com/pyenv/pyenv
# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"

# # Initialize pyenv
# eval "$(pyenv init --path)"
# eval "$(pyenv init -)"

# # Enable pyenv-virtualenv Auto-Activation
# # Docs: https://github.com/pyenv/pyenv-virtualenv
# eval "$(pyenv virtualenv-init -)"

# # --------------------------- Java --------------------------- #
# if [[ "$OS" == "Darwin" ]]; then
#     JAVA_HOME=$(/usr/libexec/java_home -v 23)
# elif [[ "$OS" == "Linux" ]]; then
#     JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
# fi
# export JAVA_HOME

# # --------------------------- Ruby --------------------------- #
# # When installed with Homebrew, prepend PATH in order that the Homebrew
# # installation is read before the MacOS built-in Ruby version.
# if [[ "$OS" == "Darwin" ]]; then
#   HOMEBREW_RUBY_BIN="$BREW_OPT_DIR/ruby/bin"
#   if [[ -d "$HOMEBREW_RUBY_BIN" ]]; then
#     HOMEBREW_RUBY_VERSION="$("$HOMEBREW_RUBY_BIN/ruby" --version | awk '{print $2}' | cut -d. -f1,2)"
#     HOMEBREW_RUBY_GEMS_BIN="$BREW_LIB_DIR/ruby/gems/$HOMEBREW_RUBY_VERSION/bin"

#     # Prepend Ruby and Gems bin directories to PATH
#     export PATH="$HOMEBREW_RUBY_GEMS_BIN:$HOMEBREW_RUBY_BIN:$PATH"
#   fi
# fi


# ------------------------------------------------------------ #
#                    Tooling & Integrations                    #
# ------------------------------------------------------------ #

# ---------------------- Bash Completion --------------------- #
# Source system-wide bash completion (v1) if it exists
# BASH_COMPLETIONS="/etc/bash_completion"

# Source Homebrew bash completion (v2) if installed
# Homebrew recommends sourcing bash-completion from .bash_profile,
# but it can be loaded here since .bash_profile sources .bashrc.
BASH_COMPLETIONS="$HOMEBREW/etc/profile.d/bash_completion.sh"

# shellcheck source=/dev/null
[[ -r "$BASH_COMPLETIONS" ]] && source "$BASH_COMPLETIONS"

# -------------------------- Direnv -------------------------- #
# Docs: https://direnv.net
# If direnv exists, initialize it for Bash
command -v direnv &>/dev/null && eval "$(direnv hook bash)"

# ---------------------- Starship Prompt --------------------- #
# Docs: https://starship.rs/config/
if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
    export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
fi

# ---------------- Carapace: Shell Completion ---------------- #
# Docs: https://carapace.sh
# If `carapace` exists, run its Bash completion script via process substitution
# shellcheck disable=SC1090
command -v carapace &>/dev/null && source <(carapace _carapace bash)

# ------------- Atuin: Shell History Replacement ------------- #
# Docs: https://docs.atuin.sh
# If `atuin` exists, evaluate its shell initialization output to hook into Bash
command -v atuin &>/dev/null && eval "$(atuin init bash)"

# -------------------------- Zoxide -------------------------- #
# Docs: https://github.com/ajeetdsouza/zoxide
# If `zoxide` exists, evaluate its init output to define Bash functions and aliases
command -v zoxide &>/dev/null && eval "$(zoxide init bash)"

# ---------------------- FD: File Finder --------------------- #
# Docs: https://github.com/sharkdp/fd
if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type file --hidden --follow --color=always'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# ------------------ FZF: Fuzzy File Finder ------------------ #
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
FZF_KEYBINDINGS="$FZF_DIR/key-bindings.bash"
FZF_COMPLETIONS="$FZF_DIR/completion.bash"

if command -v brew &>/dev/null; then
  # shellcheck source=/dev/null
  [[ -f "$FZF_KEYBINDINGS" ]] && source "$FZF_KEYBINDINGS"

  # shellcheck source=/dev/null
  [[ -f "$FZF_COMPLETIONS" ]] && source "$FZF_COMPLETIONS"
fi

# # ----------------- TPM: Tmux Plugin Manager ----------------- #
# # Docs: https://github.com/tmux-plugins/tpm
# # Used by TPM to avoid polluting tracked dotfiles
# export TMUX_PLUGIN_MANAGER_PATH="$XDG_CONFIG_HOME/tmux/plugins"

# # --------------- Zellij: Terminal Multiplexer --------------- #
# # Docs: https://zellij.dev/documentation/
# export ZELLIJ_CONFIG_DIR="$XDG_CONFIG_HOME/zellij"
# export ZELLIJ_LAYOUT_DIR="$ZELLIJ_CONFIG_DIR/layouts"
# export ZELLIJ_THEME_DIR="$ZELLIJ_CONFIG_DIR/themes"


# # ------------------------------------------------------------ #
# #                       User Environment                       #
# # ------------------------------------------------------------ #
# # Default editors, file picker, terminal, locale, and config paths

# # -------------- Default Editors And Interfaces -------------- #
# export EDITOR="nvim"        # NeoVim, or 'hx' for Helix
# export VISUAL="zed"         # Zed editor
# export TERMINAL="ghostty"   # Ghostty terminal
# export FILE_PICKER="yazi"   # Yazi file picker

# # --------------------- SSH Configuration -------------------- #
# export SSH_CONFIG_DIR="$XDG_CONFIG_HOME/ssh"
# export SSH_CONFIG_FILE="$SSH_CONFIG_DIR/ssh-config"

# # -------------------- Language And Locale ------------------- #
# export LANG="en_US.UTF-8"

# ------------------- Aliases And Functions ------------------ #
# # CLI Specific Paths
# CLI_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/cli"
# LIB_DIR="$CLI_DIR/lib"
# SCRIPT_LOADER="$LIB_DIR/load_core.sh"
# # SHELL_ALIASES="$CLI_DIR/aliases.sh"
# # SHELL_FUNCTIONS="$CLI_DIR/functions.sh"

# # Load core CLI support modules (log, source_sh_files)
# # shellcheck source=/dev/null
# [ -f "$SCRIPT_LOADER" ] && source "$SCRIPT_LOADER"

# # Load all CLI scripts (aliases.sh, functions.sh, etc.)
# source_sh_files "$CLI_DIR/cmd"

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
