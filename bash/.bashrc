# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/bash/.bashrc
# -----------------------------------------------------------------------------
# Suppress "Last login" message
touch ~/.hushlogin

# >>> Detect OS <<<
OS="$(uname -s)"

# >>> XDG Base Directory <<<
export XDG_CONFIG_HOME="$HOME/.config"

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

# >>> Aliases <<<
alias c='clear'
alias ll='ls -l'

# --- eza: Modern ls ---
# Detailed list of all files (hidden included), with icons and Git info
alias l="eza --long --icons --git --all --group-directories-first"

# Tree view with details, 2 levels deep
alias lt="eza --tree --level=2 --long --icons --git"

# Compact tree view, 2 levels deep
alias ltree="eza --tree --level=2 --icons --git"

# --- zoxide ---
alias za='zoxide add'
alias zq='zoxide query'

# --- Navigation ---
# cx: cd into a directory and list its contents.
cx() { cd "$@" && l; }
# fcd: Fuzzy search for a directory and cd into it.
fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" && l; }
# f: Fuzzy search for a file and copy its path to the clipboard.
f() { echo "$(find . -type f -not -path '*/.*' | fzf)" | pbcopy; }
# fv: Fuzzy search for a file and open it in nvim.
fv() { nvim "$(find . -type f -not -path '*/.*' | fzf)"; }

# --- Directories ---
alias conf_dir='cd ~/.config'
alias docs='cd ~/Documents'

# Dotfiles
alias dot='cd ~/dotfiles'
alias dot_nix='cd ~/dotfiles/nixos'

# Obsidian Vault
alias obsidian='cd ~/obsidian_vault'
alias obsidian_gpl='cd ~/obsidian_vault; git pull'

# Keyboard Development
alias kb_dev='cd ~/Documents/keyboard_dev'
alias kb_ergogen='cd ~/Documents/keyboard_dev/ergogen'
alias kb_zmk='cd ~/Documents/keyboard_dev/zmk-config'
alias kb_snak_dir='cd ~/Documents/keyboard_dev/kb_snak'

# --- Git ---
# Add
alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch'
alias gau='git add --update'

# Commit
alias gc='git commit -m'
alias gcam='git commit --all --message'

# Push
alias gps='git push'
alias gpsog='git push origin'

# Pull
alias gpl='git pull'
alias gplog='git pull origin'

# Fetch
alias gf='git fetch'
alias gfo='git fetch origin'

# Branch
alias gb='git branch'
alias gbra='git branch --all'
alias gbd='git branch --delete'
alias gbD='git branch --delete --force'

# Checkout
alias gco='git checkout'
alias gcm='git checkout (git_main_branch)'
alias gcb='git checkout -b'
alias gcoa='git checkout -- .'

# Remote
alias gr='git remote'
alias gra='git remote add'
alias grset='git remote set-url'

# Reset
alias grs='git reset'
alias grsh='git reset --hard'

# Diff
alias gdiff='git diff'

# Status
alias gst='git status'

# Log
alias gl='git log'
alias glog='git log --graph --topo-order --pretty="%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N" --abbrev-commit'

# Config
alias gcf='git config --list'

# Remove .DS_Store Files
grmds() {
    git rm --cached '*.DS_Store'
    git commit --all --message 'Remove .DS_Store files'
}

# --- Vim ---
alias v='nvim'
alias vdiff='nvim -d'

# --- Zellij ---
# Run Zellij in a particular directory
zj_dot() {
    cd ~/dotfiles/ && zellij
}
zj_obsidian() {
    cd ~/obsidian_vault/ && zellij
}
zj() {
    case "$1" in
        "dot")
            cd ~/dotfiles/ && zellij attach dotfiles
            ;;
        "dotvim")
            cd ~/dotfiles/nvim/ && zellij attach neovim_config
            ;;
        "obsidian")
            cd ~/obsidian_vault/ && zellij attach obsidian_vault
            ;;
        *)
            cd "${1:-$HOME}" && zellij
            ;;
    esac
}

# Run Zellij with the welcome screen
alias zj_welcome="zellij -l welcome"

# >>> Yazi File Manager Integration <<<
yz() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# --- Aerospace Window Manager ---
as() {
    case "$1" in
        "load") aerospace reload-config ;;
        "debug") aerospace debug-windows ;;
        "monitor") aerospace list-monitors ;;
        "app") aerospace list-apps ;;
        "window")
            local selection
            selection=$(aerospace list-windows --all | fzf --bind 'enter:execute(aerospace focus --window-id {})+abort' | tr -d '\n')
            ;;
        *) echo "Usage: as <command> (load, debug, monitor, app, window)" ;;
    esac
}

# --- Sketchybar ---
alias bar_load="sketchybar --reload"

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
