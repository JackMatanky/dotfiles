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

# --- Import aliases from a separate file ---
source ~/aliases.sh

# --- Initialize tools ---
eval "$(/home/jack/.nix-profile/bin/zoxide init bash)"
export PYENV_ROOT="/home/jack/.local/share/pyenv"
eval "$(/home/jack/.nix-profile/bin/pyenv init -)"
source <(/home/jack/.nix-profile/bin/carapace _carapace bash)

# Bash Completion
if [[ ! -v BASH_COMPLETION_VERSINFO ]]; then
  . "/nix/store/x2659ivhdgpgjymf1hcxxr7mz4h84rgi-bash-completion-2.13.0/etc/profile.d/bash_completion.sh"
fi

# Starship prompt
eval "$(starship init bash)"

if [[ $TERM != "dumb" ]]; then
  eval "$(/home/jack/.nix-profile/bin/starship init bash --print-full-init)"
fi
