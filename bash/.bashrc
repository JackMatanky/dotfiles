# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/bash/.bashrc
# -----------------------------------------------------------------------------
# Suppress "Last login" message
touch ~/.hushlogin

# >>> Detect OS <<<
OS="$(uname -s)"

# >>> XDG Base Directory <<<
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# >>> Git Global Config Location <<<
export GIT_CONFIG_GLOBAL="$XDG_CONFIG_HOME/git/config"

# >>> Path Configuration (OS-Specific) <<<
if [[ "$OS" == "Darwin" ]]; then
    # macOS-specific paths
    export PATH="/opt/homebrew/bin:$PATH" # Homebrew
    export PATH="/opt/homebrew/bin/nvim:$PATH" # Neovim
    export PATH="/opt/homebrew/opt/openjdk/bin:$PATH" # OpenJDK
elif [[ "$OS" == "Linux" ]]; then
    # Linux-specific paths
    export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH" # Linuxbrew
    export PATH="/usr/bin/nvim:$PATH" # Neovim
    export PATH="/usr/lib/jvm/java-17-openjdk-amd64/bin:$PATH" # OpenJDK
fi

# >>> Cargo Binaries <<<
export PATH="$HOME/.cargo/bin:$PATH"

# >>> Pyenv <<<
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Initialize pyenv
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# >>> Language and Locale <<<
export LANG="en_US.UTF-8"

# >>> History Configuration <<<
export HISTSIZE=10000
export HISTFILE="$XDG_CONFIG_HOME/.bash_history"
mkdir -p "$(dirname "$HISTFILE")"

# >>> Enable Bash Completion <<<
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# >>> Plugins <<<
# --- Bash Completion ---
if command -v brew &>/dev/null; then
    [ -f "$(brew --prefix)/etc/bash_completion" ] && source "$(brew --prefix)/etc/bash_completion"
fi

# --- Carapace Shell Completion ---
if command -v carapace &>/dev/null; then
    source <(carapace _carapace bash)
fi

# --- Starship Prompt ---
if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
    export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
fi

# --- Zoxide ---
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init bash)"
fi

# --- FZF: Fuzzy File Finder ---
if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
    [ -f ~/.fzf.bash ] && source ~/.fzf.bash
fi

# --- ZIDE ---
# Source: https://github.com/josephschmitt/zide
export ZIDE_LAYOUT_DIR="$XDG_CONFIG_HOME/zellij/layouts"
export ZIDE_ALWAYS_NAME="true"
export ZIDE_FILE_PICKER="yazi"
export ZIDE_USE_YAZI_CONFIG="$XDG_CONFIG_HOME/yazi"

# >>> Specialized Configs <<<
# --- Default Editors ---
export EDITOR="nvim"        # NeoVim, 'hx' Helix
export VISUAL="zed"         # Zed
export TERMINAL="ghostty"   # Ghostty
export FILE_PICKER="yazi"   # Yazi

# --- SSH ---
export SSH_CONFIG_DIR="$XDG_CONFIG_HOME/ssh"
export SSH_CONFIG_FILE="$SSH_CONFIG_DIR/ssh-config"

# --- Nushell ---
export NU_CONFIG_DIR="$XDG_CONFIG_HOME/nushell"

# --- Java ---
if [[ "$OS" == "Darwin" ]]; then
    export JAVA_HOME=$(/usr/libexec/java_home -v 23)
elif [[ "$OS" == "Linux" ]]; then
    export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
fi

# Load custom aliases and functions
[ -f "$HOME/dotfiles/cli/aliases.sh" ] && source "$HOME/dotfiles/cli/aliases.sh"
