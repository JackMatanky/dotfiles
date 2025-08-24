# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/shell/profile/20-lang.sh
# Description: Configures environment variables and runtime initialization
#              for programming language toolchains including Python (pyenv),
#              Java (JAVA_HOME), and Ruby (Homebrew Ruby integration).
# -----------------------------------------------------------------------------

# ------------------------------------------------------------ #
#            Programming Language Environment Setup            #
# ------------------------------------------------------------ #

# ------------- Pyenv: Python Version Management ------------- #
# Docs: https://github.com/pyenv/pyenv
export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"

# Add pyenv bin directory if it exists
PYENV_BIN="${PYENV_ROOT}/bin"
[[ -d "${PYENV_BIN}" ]] && path_prepend "${PYENV_BIN}"

# Detect once whether pyenv and pyenv-virtualenv are available
HAS_PYENV="$(command -v pyenv || true)"
HAS_PYENV_VENV="$(command -v pyenv-virtualenv-init || true)"

# Initialize pyenv (system paths and shell shims)
[[ -n "$HAS_PYENV" ]] && eval "$($HAS_PYENV init --path)"
[[ -n "$HAS_PYENV" ]] && eval "$($HAS_PYENV init -)"

# Enable pyenv-virtualenv Auto-Activation
# Docs: https://github.com/pyenv/pyenv-virtualenv
[[ -n "$HAS_PYENV" && -n "$HAS_PYENV_VENV" ]] && eval "$($HAS_PYENV_VENV -)"

# --------------------------- Java --------------------------- #
# Prefer Homebrew OpenJDK when available; otherwise OS-based fallback.
JAVA_HOME_CANDIDATE=""

# If installed via Homebrew, prefer it
[[ -n "${HOMEBREW:-}" && -x "${HOMEBREW}/opt/openjdk/bin/java" ]] && \
  JAVA_HOME_CANDIDATE="${HOMEBREW}/opt/openjdk"

# On macOS, use /usr/libexec/java_home (JDK 23)
if [[ -z "${JAVA_HOME_CANDIDATE}" && "$OS" == "Darwin" ]]; then
  JAVA_HOME_CANDIDATE="$(/usr/libexec/java_home -v 23 2>/dev/null || true)"
fi

# On Linux, fallback to a common OpenJDK install
if [[ -z "${JAVA_HOME_CANDIDATE}" && "$OS" == "Linux" ]]; then
  JAVA_HOME_CANDIDATE="/usr/lib/jvm/java-17-openjdk-amd64"
fi

# Export JAVA_HOME and prepend its bin if valid
if [[ -n "${JAVA_HOME_CANDIDATE}" ]]; then
  export JAVA_HOME="${JAVA_HOME_CANDIDATE}"
  JAVA_BIN="${JAVA_HOME}/bin"
  [[ -d "${JAVA_BIN}" ]] && path_prepend "${JAVA_BIN}"
fi

# --------------------------- Ruby --------------------------- #
# When installed with Homebrew, prepend PATH in order that the Homebrew
# installation is read before the MacOS built-in Ruby version.
if [[ "$OS" == "Darwin" && -n "${BREW_OPT_DIR:-}" ]]; then
  HOMEBREW_RUBY_BIN="${BREW_OPT_DIR}/ruby/bin"
  if [[ -x "${HOMEBREW_RUBY_BIN}/ruby" ]]; then
    # Parse Ruby version (major.minor) for gems path
    RUBY_VERSION="$("${HOMEBREW_RUBY_BIN}/ruby" --version | awk '{print $2}' | cut -d. -f1,2)"
    RUBY_GEMS_BIN="${BREW_LIB_DIR:-${HOMEBREW}/lib}/ruby/gems/${RUBY_VERSION}/bin"

    # Prepend gems bin and Ruby bin to PATH
    [[ -d "${RUBY_GEMS_BIN}" ]] && path_prepend "${RUBY_GEMS_BIN}"
    path_prepend "${HOMEBREW_RUBY_BIN}"
  fi
fi

# --------------------------- Cleanup -------------------------- #
unset PYENV_BIN HAS_PYENV HAS_PYENV_VENV JAVA_HOME_CANDIDATE JAVA_BIN HOMEBREW_RUBY_BIN RUBY_VER RUBY_GEMS_BIN
