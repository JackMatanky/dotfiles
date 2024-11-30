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
