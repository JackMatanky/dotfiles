# shellcheck shell=bash

# -----------------------------------------------------------------------------
# Filename: ~/.config/shell/profile/20-lang.sh
# Description: Configures environment variables and runtime initialization
#              for programming language toolchains including Python (pyenv),
#              Java (JAVA_HOME), Ruby (Homebrew Ruby), and Go (Homebrew Go).
# Style:      Google Shell Style Guide; <= 80-char lines.
# Notes:      Assumes helper '__path_prepend' is defined in 00-core.sh and that
#             10-brew.sh exports Homebrew-related vars (e.g., HOMEBREW,
#             BREW_OPT_DIR, BREW_LIB_DIR).
# -----------------------------------------------------------------------------

# ------------------------------------------------------------ #
#            Programming Language Environment Setup            #
# ------------------------------------------------------------ #

# ------------- Pyenv: Python Version Management ------------- #
# Docs: https://github.com/pyenv/pyenv
export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"

# Add pyenv bin directory if it exists
PYENV_BIN="${PYENV_ROOT}/bin"
[[ -d "${PYENV_BIN}" ]] && __path_prepend "${PYENV_BIN}"

# Detect once whether pyenv and pyenv-virtualenv are available
HAS_PYENV="$(command -v pyenv || true)"
HAS_PYENV_VENV="$(command -v pyenv-virtualenv-init || true)"

# Initialize pyenv (system paths and shell shims)
[[ -n "${HAS_PYENV}" ]] && eval "$(${HAS_PYENV} init --path)"
[[ -n "${HAS_PYENV}" ]] && eval "$(${HAS_PYENV} init -)"

# Enable pyenv-virtualenv Auto-Activation
# Docs: https://github.com/pyenv/pyenv-virtualenv
[[ -n "${HAS_PYENV}" && -n "${HAS_PYENV_VENV}" ]] && eval "$(${HAS_PYENV_VENV} -)"

# ---------------------------- Go ---------------------------- #
# Goal: Prefer Homebrew Go toolchain and ensure 'go' is first on PATH.
#       Configure GOPATH/GOBIN with sane defaults (overridable by user).
# Docs: https://go.dev/doc/manage-install
GO_LIBEXEC_BIN=""

# Prefer Homebrew-managed Go when available.
# Typical locations:
#   - Apple Silicon: /opt/homebrew/opt/go/libexec/bin
#   - Intel macOS:   /usr/local/opt/go/libexec/bin
#   - Linux Homebrew:$(brew --prefix)/opt/go/libexec/bin
if [[ -n "${BREW_OPT_DIR:-}" && -d "${BREW_OPT_DIR}/go/libexec/bin" ]]; then
  GO_LIBEXEC_BIN="${BREW_OPT_DIR}/go/libexec/bin"
elif [[ -n "${HOMEBREW:-}" && -d "${HOMEBREW}/opt/go/libexec/bin" ]]; then
  GO_LIBEXEC_BIN="${HOMEBREW}/opt/go/libexec/bin"
fi

# Fallback: official Go pkg default (macOS) if present.
# (Only used if Homebrew Go not found.)
if [[ -z "${GO_LIBEXEC_BIN}" && -d "/usr/local/go/bin" ]]; then
  GO_LIBEXEC_BIN="/usr/local/go/bin"
fi

# If we found a candidate, prepend to PATH.
[[ -n "${GO_LIBEXEC_BIN}" ]] && __path_prepend "${GO_LIBEXEC_BIN}"

# GOPATH/GOBIN defaults (user may override in personal overrides file).
# Do not create directories here; only export variables and PATH.
export GOPATH="${GOPATH:-$HOME/go}"
export GOBIN="${GOBIN:-$GOPATH/bin}"
[[ -d "${GOBIN}" ]] && __path_prepend "${GOBIN}"

# --------------------------- Java --------------------------- #
# Prefer Homebrew OpenJDK when available; otherwise OS-based fallback.
JAVA_HOME_CANDIDATE=""

# If installed via Homebrew, prefer it
if [[ -n "${HOMEBREW:-}" && -x "${HOMEBREW}/opt/openjdk/bin/java" ]]; then
  JAVA_HOME_CANDIDATE="${HOMEBREW}/opt/openjdk"
fi

# On macOS, use /usr/libexec/java_home (JDK 23)
if [[ -z "${JAVA_HOME_CANDIDATE}" && "${OS:-}" == "Darwin" ]]; then
  JAVA_HOME_CANDIDATE="$(
    /usr/libexec/java_home -v 23 2>/dev/null || true
  )"
fi

# On Linux, fallback to a common OpenJDK install
if [[ -z "${JAVA_HOME_CANDIDATE}" && "${OS:-}" == "Linux" ]]; then
  JAVA_HOME_CANDIDATE="/usr/lib/jvm/java-17-openjdk-amd64"
fi

# Export JAVA_HOME and prepend its bin if valid
if [[ -n "${JAVA_HOME_CANDIDATE}" ]]; then
  export JAVA_HOME="${JAVA_HOME_CANDIDATE}"
  JAVA_BIN="${JAVA_HOME}/bin"
  [[ -d "${JAVA_BIN}" ]] && __path_prepend "${JAVA_BIN}"
fi

# --------------------------- Ruby --------------------------- #
# When installed with Homebrew, prepend PATH so Homebrew Ruby takes precedence
# over the macOS built-in Ruby. Also expose gem-installed executables.
if [[ "${OS:-}" == "Darwin" && -n "${BREW_OPT_DIR:-}" ]]; then
  HOMEBREW_RUBY_BIN="${BREW_OPT_DIR}/ruby/bin"
  if [[ -x "${HOMEBREW_RUBY_BIN}/ruby" ]]; then
    # Parse Ruby version (major.minor) for gems path
    RUBY_VERSION="$(
      "${HOMEBREW_RUBY_BIN}/ruby" --version | awk '{print $2}' | cut -d. -f1,2
    )"
    RUBY_GEMS_BIN="${BREW_LIB_DIR:-${HOMEBREW:-}/lib}/ruby/gems/${RUBY_VERSION}/bin"

    # Prepend gems bin and Ruby bin to PATH
    [[ -d "${RUBY_GEMS_BIN}" ]] && __path_prepend "${RUBY_GEMS_BIN}"
    __path_prepend "${HOMEBREW_RUBY_BIN}"
  fi
fi

# --------------------------- Cleanup ------------------------ #
unset \
  PYENV_BIN HAS_PYENV HAS_PYENV_VENV \
  GO_LIBEXEC_BIN \
  JAVA_HOME_CANDIDATE JAVA_BIN \
  HOMEBREW_RUBY_BIN RUBY_VERSION RUBY_GEMS_BIN
