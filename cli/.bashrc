# Source the aliases.sh file
source ~/aliases.sh

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

if [[ ! -v BASH_COMPLETION_VERSINFO ]]; then
  . "/nix/store/x2659ivhdgpgjymf1hcxxr7mz4h84rgi-bash-completion-2.13.0/etc/profile.d/bash_completion.sh"
fi

eval "$(starship init bash)"

eval "$(/nix/store/35dlmkd4yvsr286zr8l2byv2wybkg5sz-zoxide-0.9.4/bin/zoxide init bash )"

if [[ $TERM != "dumb" ]]; then
  eval "$(/home/jack/.nix-profile/bin/starship init bash --print-full-init)"
fi

export PYENV_ROOT="/home/jack/.local/share/pyenv"
eval "$(/nix/store/fzx56sj1mbh4zgw5471hq0calcii4p8c-pyenv-2.4.1/bin/pyenv init - bash)"

source <(/nix/store/ymwrpk2s7d3f1qdqssyj755s8bm5qgak-carapace-1.0.2/bin/carapace _carapace bash)
