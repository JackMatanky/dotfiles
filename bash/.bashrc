# shellcheck shell=bash
# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/bash/.bashrc
# Description: Bash interactive shell configuration for macOS and Linux.
#              Loads modular CLI environment, defines completions, history,
#              and initializes interactive tooling (e.g., direnv, starship).
# -----------------------------------------------------------------------------
# Suppress "Last login" message
touch ~/.hushlogin


# ------------------------------------------------------------ #
#                 Load Modular CLI Environment                 #
# ------------------------------------------------------------ #
# CLI Specific Paths
CLI_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/cli"
LIB_DIR="$CLI_DIR/lib"
SCRIPT_LOADER="$LIB_DIR/load_core.sh"

# Load core CLI support modules (log, source_sh_files)
# shellcheck source=/dev/null
[[ -f "$SCRIPT_LOADER" ]] && source "$SCRIPT_LOADER"

# ------------------- Environment Variables ------------------ #
# XDG paths, language setup, etc.
source_sh_files "$CLI_DIR/profile"

# ---------------------- Shell Commands ---------------------- #
# aliases, functions, helpers, etc.
source_sh_files "$CLI_DIR/cmd"


# ------------------------------------------------------------ #
#                     History Configuration                    #
# ------------------------------------------------------------ #
export HISTSIZE=10000
export HISTFILE="$XDG_CONFIG_HOME/.bash_history"
mkdir -p "$(dirname "$HISTFILE")"


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

# ---------------------- Starship Prompt --------------------- #
# Docs: https://starship.rs/config/
if command -v starship &>/dev/null; then
    export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
    eval "$(starship init bash)"
fi
