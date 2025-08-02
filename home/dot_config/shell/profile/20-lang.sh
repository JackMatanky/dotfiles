# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/cli/profile/20-lang.sh
# Description: Configures environment variables and runtime initialization
#              for programming language toolchains including Python (pyenv),
#              Java (JAVA_HOME), and Ruby (Homebrew Ruby integration).
# -----------------------------------------------------------------------------

# ------------------------------------------------------------ #
#            Programming Language Environment Setup            #
# ------------------------------------------------------------ #

# ------------- Pyenv: Python Version Management ------------- #
# Docs: https://github.com/pyenv/pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Initialize pyenv
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# Enable pyenv-virtualenv Auto-Activation
# Docs: https://github.com/pyenv/pyenv-virtualenv
eval "$(pyenv virtualenv-init -)"

# --------------------------- Java --------------------------- #
if [[ "$OS" == "Darwin" ]]; then
  JAVA_HOME=$(/usr/libexec/java_home -v 23)
elif [[ "$OS" == "Linux" ]]; then
  JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
fi
export JAVA_HOME

# --------------------------- Ruby --------------------------- #
# When installed with Homebrew, prepend PATH in order that the Homebrew
# installation is read before the MacOS built-in Ruby version.
if [[ "$OS" == "Darwin" ]]; then
  HOMEBREW_RUBY_BIN="$BREW_OPT_DIR/ruby/bin"
  if [[ -d "$HOMEBREW_RUBY_BIN" ]]; then
    HOMEBREW_RUBY_VERSION="$("$HOMEBREW_RUBY_BIN/ruby" --version | awk '{print $2}' | cut -d. -f1,2)"
    HOMEBREW_RUBY_GEMS_BIN="$BREW_LIB_DIR/ruby/gems/$HOMEBREW_RUBY_VERSION/bin"
    # Prepend Ruby and Gems bin directories to PATH
    export PATH="$HOMEBREW_RUBY_GEMS_BIN:$HOMEBREW_RUBY_BIN:$PATH"
  fi
fi
