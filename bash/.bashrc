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

# >>> Cargo Binaries <<<
export PATH="$HOME/.cargo/bin:$PATH"

# -----------------------------------------------
# Homebrew Installation Directory
# -----------------------------------------------
# Default fallback to empty string if OS is unknown
if [[ "$OS" == "Darwin" ]]; then
    export HOMEBREW="/opt/homebrew"
elif [[ "$OS" == "Linux" ]]; then
    export HOMEBREW="$(brew --prefix)"
fi

# >>> Path Configuration (OS-Specific) <<<
# Homebrew (Linuxbrew), Neovim, OpenJDK
if [[ "$OS" == "Darwin" ]]; then
    # macOS-specific paths
    export PATH="$HOMEBREW/bin:$PATH"
    export PATH="$HOMEBREW/bin/nvim:$PATH"
    export PATH="$HOMEBREW/opt/openjdk/bin:$PATH"
elif [[ "$OS" == "Linux" ]]; then
    # Linux-specific paths
    export PATH="$HOMEBREW/bin:$PATH"
    export PATH="/usr/bin/nvim:$PATH"
    export PATH="/usr/lib/jvm/java-17-openjdk-amd64/bin:$PATH"
fi

# >>> Build Flags for Brew-Linked Libraries <<<
# Help C extension modules (e.g., pygraphviz) locate Brew-installed headers and libraries
if [[ "$OS" == "Darwin" ]]; then
    export CFLAGS="-I$HOMEBREW/include"
    export LDFLAGS="-L$HOMEBREW/lib"
elif [[ "$OS" == "Linux" ]]; then
    export CFLAGS="-I$HOMEBREW/include"
    export LDFLAGS="-L$HOMEBREW/lib"
fi

# >>> Homebrew Ruby Path Prepend with Auto-Detection <<<
if [[ "$OS" == "Darwin" ]]; then
  HOMEBREW_RUBY_BIN="$HOMEBREW/opt/ruby/bin"
  if [[ -d "$HOMEBREW_RUBY_BIN" ]]; then
    HOMEBREW_RUBY_VERSION="$("$HOMEBREW_RUBY_BIN/ruby" --version | awk '{print $2}' | cut -d. -f1,2)"
    HOMEBREW_RUBY_GEMS_BIN="$HOMEBREW/lib/ruby/gems/$HOMEBREW_RUBY_VERSION/bin"

    # Prepend Ruby and Gems bin directories to PATH
    export PATH="$HOMEBREW_RUBY_GEMS_BIN:$HOMEBREW_RUBY_BIN:$PATH"
  fi
fi

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

# -----------------------------------------------
# Tooling & Integrations
# -----------------------------------------------
# >>> Bash Completion <<<
# Source system-wide bash completion if it exists
if [[ -r /etc/bash_completion ]]; then
    . /etc/bash_completion
fi

# Source Homebrew bash completion if installed
if command -v brew &>/dev/null; then
    if [[ "$OS" == "Darwin" ]] || [[ "$OS" == "Linux" ]]; then
        [[ -r "$HOMEBREW/etc/profile.d/bash_completion.sh" ]] && . "$HOMEBREW/etc/profile.d/bash_completion.sh"
    fi
fi

# >>> Starship Prompt <<<
# Docs: https://starship.rs/config/
if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
    export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
fi

# >>> Carapace Shell Completion <<<
# Docs: https://carapace.sh
if command -v carapace &>/dev/null; then
    source <(carapace _carapace bash)
fi

# >>> Atuin Shell History <<<
# Docs: https://docs.atuin.sh
if command -v atuin &>/dev/null; then
    eval "$(atuin init bash)"
fi

# >>> Zoxide <<<
# Docs: https://github.com/ajeetdsouza/zoxide
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init bash)"
fi

# >>> FD: File Finder <<<
# Docs: https://github.com/sharkdp/fd
if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type file --hidden --follow --color=always'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# >>> FZF: Fuzzy File Finder <<<
# Docs: https://junegunn.github.io/fzf/
export FZF_DEFAULT_OPTS='
    --height=40%
    --layout=reverse
    --info=inline
    --border
    --preview "bat --style=numbers --color=always {} || cat {}"
    --preview-window=right:60%
'

if command -v brew &>/dev/null; then
    if [[ -f "$HOMEBREW/opt/fzf/shell/key-bindings.bash" ]]; then
        source "$HOMEBREW/opt/fzf/shell/key-bindings.bash"
    fi
    if [[ -f "$HOMEBREW/opt/fzf/shell/completion.bash" ]]; then
        source "$HOMEBREW/opt/fzf/shell/completion.bash"
    fi
fi

# >>> Zellij: Terminal Multiplexer <<<
# Docs: https://zellij.dev/documentation/
export ZELLIJ_CONFIG_DIR="$XDG_CONFIG_HOME/zellij"
export ZELLIJ_LAYOUT_DIR="$ZELLIJ_CONFIG_DIR/layouts"
export ZELLIJ_THEME_DIR="$ZELLIJ_CONFIG_DIR/themes"

# -----------------------------------------------
# Specialized Configs
# -----------------------------------------------
# >>> Default Editors <<<
export EDITOR="nvim"        # NeoVim, 'hx' Helix
export VISUAL="zed"         # Zed
export TERMINAL="ghostty"   # Ghostty
export FILE_PICKER="yazi"   # Yazi

# >>> SSH <<<
export SSH_CONFIG_DIR="$XDG_CONFIG_HOME/ssh"
export SSH_CONFIG_FILE="$SSH_CONFIG_DIR/ssh-config"

# >>> Nushell <<<
export NU_CONFIG_DIR="$XDG_CONFIG_HOME/nushell"

# >>> Java <<<
if [[ "$OS" == "Darwin" ]]; then
    export JAVA_HOME=$(/usr/libexec/java_home -v 23)
elif [[ "$OS" == "Linux" ]]; then
    export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
fi

# Load custom aliases and functions
[ -f "$HOME/dotfiles/cli/aliases.sh" ] && source "$HOME/dotfiles/cli/aliases.sh"
