# Commands that should be applied only for interactive shells.
[[ $- == *i* ]] || return

# History settings
HISTFILESIZE=100000
HISTSIZE=10000

# Shell options
shopt -s histappend
shopt -s checkwinsize
shopt -s extglob
shopt -s globstar
shopt -s checkjobs

# --- Set $HOME if not already set ---
if [[ -z "$HOME" ]]; then
  export HOME="$(eval echo ~)"
fi

# --- Define variables for commonly used paths ---
export MY_HOME="$HOME"
export NIX_PROFILE="$MY_HOME/.nix-profile/bin"

# --- Import aliases from a separate file ---
source "$HOME/.dotfiles/cli/aliases.sh"

# --- Initialize tools ---
eval "$("$NIX_PROFILE/zoxide" init bash)"
export PYENV_ROOT="$MY_HOME/.local/share/pyenv"
eval "$("$NIX_PROFILE/pyenv" init -)"
source <("$NIX_PROFILE/carapace" _carapace bash)

# Bash Completion
if [[ ! -v BASH_COMPLETION_VERSINFO ]]; then
  . "/nix/store/x2659ivhdgpgjymf1hcxxr7mz4h84rgi-bash-completion-2.13.0/etc/profile.d/bash_completion.sh"
fi

# Starship prompt
eval "$(starship init bash)"

if [[ $TERM != "dumb" ]]; then
  eval "$("$NIX_PROFILE/starship" init bash --print-full-init)"
fi
