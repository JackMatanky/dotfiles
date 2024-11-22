# Source your aliases.sh file (updated path)
source ~/.dotfiles/cli/aliases.sh

# Starship prompt configuration
eval "$(starship init bash)"

# (Optional) Full Starship initialization for non-dumb terminals
if [[ $TERM != "dumb" ]]; then
  eval "$(/home/jack/.nix-profile/bin/starship init bash --print-full-init)"
fi

# Pyenv initialization (if you're using pyenv)
export PYENV_ROOT="/home/jack/.local/share/pyenv"
eval "$(/nix/store/fzx56sj1mbh4zgw5471hq0calcii4p8c-pyenv-2.4.1/bin/pyenv init - bash)"

# Carapace integration (if you're using carapace)
source <(/nix/store/ymwrpk2s7d3f1qdqssyj755s8bm5qgak-carapace-1.0.2/bin/carapace _carapace bash)
