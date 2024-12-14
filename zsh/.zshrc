# --- Path Configuration ---
# Set up paths for Zsh.
typeset -U path cdpath fpath manpath

# Add Nix profile paths.
for profile in ${(z)NIX_PROFILES}; do
  fpath+=($profile/share/zsh/site-functions $profile/share/zsh/$ZSH_VERSION/functions $profile/share/zsh/vendor-completions)
done

# Set help directory.
HELPDIR="/nix/store/nw0648r93knk287wi8xga9jhhpm35g6g-zsh-5.9/share/zsh/$ZSH_VERSION/help"

# --- Completion ---
autoload -U compinit && compinit

# Load autosuggestions.
source /nix/store/zjwhkkgmgmaki5lijrkfnfa7l54c8487-zsh-autosuggestions-0.7.0/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# --- History ---
HISTSIZE="10000"
SAVEHIST="10000"
HISTFILE="$HOME/.zsh_history"
mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_DUPS
unsetopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
unsetopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
unsetopt EXTENDED_HISTORY

# --- Define variables for paths ---
export MY_HOME="$HOME"
export NIX_PROFILE="$MY_HOME/.nix-profile/bin"

# --- Initialize tools ---
eval "$("$NIX_PROFILE/starship" init zsh)" # Starship prompt
eval "$("$NIX_PROFILE/zoxide" init zsh)"  # Directory jumping
eval "$("$NIX_PROFILE/pyenv" init -)"   # Python version management
source <("$NIX_PROFILE/carapace" _carapace zsh) # Shell completion

# --- Import aliases from a separate file ---
source "$HOME/.dotfiles/cli/aliases.sh"

# --- Named Directory Hashes ---
# ... (keep this section if needed) ...

# --- Syntax Highlighting ---
source /nix/store/pzs9jwplb4c25qqd8myyxsx4csbqczhv-zsh-syntax-highlighting-0.8.0/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS+=()

# Aliases
alias -- cg_empty='sudo nix-collect-garbage'
alias -- cg_empty_all='sudo nix-collect-garbage -d'
alias -- dot='cd ~/.dotfiles'
alias -- dot_nix='cd ~/.dotfiles/nixos'
alias -- flake_rebuild='sudo nixos-rebuild switch --flake .'
alias -- flake_rebuild_trace='sudo nixos-rebuild switch --flake . --show-trace'
alias -- flake_up='sudo nix flake update'
alias -- flake_up_trace='sudo nix flake update --show-trace'
alias -- gad='git add'
alias -- gad_d='git add .'
alias -- gad_p='git add -p'
alias -- gbr='git branch'
alias -- gbra='git branch -a'
alias -- gc='git commit -m'
alias -- gca='git commit -a -m'
alias -- gco='git checkout'
alias -- gcoall='git checkout -- .'
alias -- gdiff='git diff'
alias -- glog='git log --graph --topo-order --pretty='\''%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N'\'' --abbrev-commit'
alias -- gpl='git pull'
alias -- gpl_o='git pull origin'
alias -- gps='git push'
alias -- gps_o='git push origin'
alias -- grm='git remote'
alias -- grs='git reset'
alias -- gst='git status'
alias -- hm_switch='home-manager switch --flake .'
alias -- hm_switch_trace='home-manager switch --flake . --show-trace'
alias -- obsidian='cd ~/obsidian_vault'
alias -- obsidian_gpl='cd ~/obsidian_vault; git pull'
alias -- vimdiff='nvim -d'
