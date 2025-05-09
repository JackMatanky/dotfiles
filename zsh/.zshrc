# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/zsh/.zshrc
# Description: Interactive Zsh configuration for macOS and Linux.
#              Loads modular CLI environment, initializes completions, plugins,
#              shell behavior, and interactive tools (e.g., starship, direnv).
# -----------------------------------------------------------------------------
# Suppress "Last login" message
touch ~/.hushlogin

# -------------------- Path Configuration -------------------- #
typeset -U path cdpath fpath manpath


# -------------------------------------------------------------#
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
#                  Session & Completion Files                  #
# ------------------------------------------------------------ #
export ZSH_SESSION="$XDG_CONFIG_HOME/.zsh_sessions"
mkdir -p "$(dirname "$ZSH_SESSION")"

export ZCOMPFILE="$XDG_CONFIG_HOME/.zcompdump"
mkdir -p "$(dirname "$ZCOMPFILE")"


# ------------------------------------------------------------ #
#                     History Configuration                    #
# ------------------------------------------------------------ #
export HISTSIZE=10000                           # Number of commands kept in memory
export SAVEHIST=10000                           # Number of commands saved to the file
export HISTFILE="$XDG_CONFIG_HOME/.zsh_history" # Location of the history file
mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK               # Prevent simultaneous history writes
setopt HIST_IGNORE_DUPS              # Ignore consecutive duplicates
setopt HIST_IGNORE_SPACE             # Ignore commands starting with a space
setopt SHARE_HISTORY                 # Share history across Zsh instances


# ------------------------------------------------------------ #
#                    Tooling & Integrations                    #
# ------------------------------------------------------------ #

# ---------------- ZSH Auto-Completion System ---------------- #
autoload -U compinit
compinit

# -------------------- ZSH Autosuggestions ------------------- #
ZSH_AUTOSUGGESTIONS_RELATIVE="share/zsh-autosuggestions/zsh-autosuggestions.zsh"

if [[ -f "$HOMEBREW/$ZSH_AUTOSUGGESTIONS_RELATIVE" ]]; then
    source "$HOMEBREW/$ZSH_AUTOSUGGESTIONS_RELATIVE"
elif [[ -f "/usr/$ZSH_AUTOSUGGESTIONS_RELATIVE" ]]; then
    source "/usr/$ZSH_AUTOSUGGESTIONS_RELATIVE"
# elif [[ -n "$(ls /nix/store/*zsh-autosuggestions*/zsh-autosuggestions.zsh 2>/dev/null)" ]]; then
#     source "$(ls /nix/store/*zsh-autosuggestions*/zsh-autosuggestions.zsh 2>/dev/null)"
fi

# ------------------ ZSH Syntax Highlighting ----------------- #
ZSH_SYNTAX_HIGHLIGHTING_RELATIVE="share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"


if [[ -f "$HOMEBREW/$ZSH_SYNTAX_HIGHLIGHTING_RELATIVE" ]]; then
    source "$HOMEBREW/$ZSH_SYNTAX_HIGHLIGHTING_RELATIVE"
elif [[ -f "/usr/$ZSH_SYNTAX_HIGHLIGHTING_RELATIVE" ]]; then
    source "/usr/$ZSH_SYNTAX_HIGHLIGHTING_RELATIVE"
# elif [[ -n "$(ls /nix/store/*zsh-syntax-highlighting*/zsh-syntax-highlighting.zsh 2>/dev/null)" ]]; then
#     source "$(ls /nix/store/*zsh-syntax-highlighting*/zsh-syntax-highlighting.zsh 2>/dev/null)"
fi

# -------------------------- Direnv -------------------------- #
# Docs: https://direnv.net
# If direnv exists, initialize it for ZSH
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"

# ---------------- Carapace: Shell Completion ---------------- #
# Docs: https://carapace.sh
# If `carapace` exists, run its ZSH completion script via process substitution
# shellcheck disable=SC1090
command -v carapace &>/dev/null && source <(carapace _carapace zsh)

# ------------- Atuin: Shell History Replacement ------------- #
# Docs: https://docs.atuin.sh
# If `atuin` exists, evaluate its shell initialization output to hook into ZSH
command -v atuin &>/dev/null && eval "$(atuin init zsh)"

# -------------------------- Zoxide -------------------------- #
# Docs: https://github.com/ajeetdsouza/zoxide
# If `zoxide` exists, evaluate its init output to define ZSH functions and aliases
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

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
FZF_KEYBINDINGS="$FZF_DIR/key-bindings.zsh"
FZF_COMPLETIONS="$FZF_DIR/completion.zsh"

if command -v brew &>/dev/null; then
  [[ -f "$FZF_KEYBINDINGS" ]] && source "$FZF_KEYBINDINGS"
  [[ -f "$FZF_COMPLETIONS" ]] && source "$FZF_COMPLETIONS"
fi

# ---------------------- Starship Prompt --------------------- #
# Docs: https://starship.rs/config/
if command -v starship &>/dev/null; then
    export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
    eval "$(starship init zsh)"
fi

# ------------------------------------------------------------ #
#                       User Environment                       #
# ------------------------------------------------------------ #

# -------------- ZSH Auto-Suggestion Keybindings ------------- #
bindkey '^w' autosuggest-execute
bindkey '^e' autosuggest-accept
bindkey '^u' autosuggest-toggle
bindkey '^L' vi-forward-word
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search
