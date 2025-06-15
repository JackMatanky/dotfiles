# 🧠 Shell Configuration System: Philosophy and Implementation

This README documents the design principles, structure, and behavior of my
modular shell configuration system. It includes the full rationale and technical
implementation details for `bash`, `zsh`, and the shared `cli` layer.

---

## 📌 Design Philosophy

The system is built with the following goals:

- **Modularity**: Configurations are broken into composable, logically grouped scripts.
- **Portability**: Supports both Bash and Zsh on macOS and Linux without duplication.
- **Maintainability**: Uses filename-based load ordering and descriptive naming.
- **Visibility**: Optional logging shows exactly what gets sourced.
- **Shell-agnostic logic**: Shared functionality lives in `cli/`, while
                            shell-specific details remain in `bash/` or `zsh/`.

---

## 🗂 Directory Structure

```txt
~/.config/
├── bash/
│   ├── .bashrc                   # Interactive shell config
│   └── .bash_profile             # Login shell config (macOS)
├── zsh/
│   ├── .zshrc                    # Interactive shell config
│   └── .zprofile                 # Login shell config (macOS)
└── cli/
    ├── lib/
    │   ├── log.sh                # Logging utilities
    │   ├── source_sh_files.sh    # Modular sourcing logic
    │   └── load_core.sh          # Entrypoint: sources profile/ and cmd/
    ├── profile/                  # Environment declarations
    │   ├── 00-core.sh
    │   ├── 10-brew.sh
    │   └── 20-lang.sh
    └── cmd/                      # Aliases and shell functions
```

---

## 📦 Profile Script Responsibilities

The following table outlines each `cli/profile/*.sh` file, its load order, and
its contents:

| Filename          | Purpose                                 | Contents                                                                                                                                     |
|-------------------|------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| `00-core.sh`      | Base environment + user defaults         | OS detection, XDG base directories, default editors, terminal, locale, shell paths (e.g., Nushell, Zellij, SSH config)                      |
| `10-brew.sh`      | Homebrew setup                           | `HOMEBREW` detection, brew path exports, CFLAGS/LDFLAGS, OS-specific PATH manipulation, fallback logic for missing brew installs            |
| `20-lang.sh`      | Language environment managers            | Pyenv (init, virtualenv), Java `JAVA_HOME`, Homebrew Ruby (version detection, gem path injection)                                           |

This modular layout ensures each layer only declares what it needs. For example,
`10-brew.sh` must be loaded **before** `20-lang.sh` so Ruby and Java can detect
Homebrew paths.

---

## 🧾 Environment Variable Registry

| Variable             | Defined In            | Description                                                                 |
|----------------------|------------------------|-----------------------------------------------------------------------------|
| `OS`                 | `00-core.sh`           | OS identifier from `uname -s`, used for platform-specific logic             |
| `XDG_CONFIG_HOME`    | `00-core.sh`           | User-level config directory (`~/.config`)                                   |
| `XDG_CACHE_HOME`     | `00-core.sh`           | Cache directory for transient files (`~/.cache`)                            |
| `XDG_DATA_HOME`      | `00-core.sh`           | Data directory for user apps (`~/.local/share`)                             |
| `XDG_STATE_HOME`     | `00-core.sh`           | State directory for non-essential runtime data (`~/.local/state`)          |
| `NU_CONFIG_DIR`      | `00-core.sh`           | Config path for Nushell (`$XDG_CONFIG_HOME/nushell`)                        |
| `ZELLIJ_CONFIG_DIR`  | `00-core.sh`           | Base config dir for Zellij                                                  |
| `ZELLIJ_LAYOUT_DIR`  | `00-core.sh`           | Layout directory for Zellij sessions                                        |
| `ZELLIJ_THEME_DIR`   | `00-core.sh`           | Theme directory for Zellij                                                  |
| `TMUX_PLUGIN_MANAGER_PATH` | `00-core.sh`     | Path for TPM to install plugins                                             |
| `EDITOR`             | `00-core.sh`           | Default editor (e.g., `nvim`)                                               |
| `VISUAL`             | `00-core.sh`           | Default visual editor (e.g., `zed`)                                         |
| `TERMINAL`           | `00-core.sh`           | Terminal app used (e.g., `ghostty`)                                         |
| `FILE_PICKER`        | `00-core.sh`           | Preferred file picker (e.g., `yazi`)                                        |
| `SSH_CONFIG_DIR`     | `00-core.sh`           | Directory for SSH config                                                    |
| `SSH_CONFIG_FILE`    | `00-core.sh`           | Path to primary SSH config file                                             |
| `GIT_CONFIG_GLOBAL`  | `00-core.sh`           | Global Git configuration file path                                          |
| `LANG`               | `00-core.sh`           | Default locale                                                              |
| `PATH`               | `00-core.sh`           | Appended with `$HOME/.cargo/bin`                                            |
| `HOMEBREW`           | `10-brew.sh`           | Homebrew base path (`/opt/homebrew` or Linux fallback)                      |
| `BREW_OPT_DIR`       | `10-brew.sh`           | Homebrew `opt` directory                                                    |
| `BREW_BIN_DIR`       | `10-brew.sh`           | Homebrew binary directory                                                   |
| `BREW_SBIN_DIR`      | `10-brew.sh`           | Homebrew sbin directory                                                     |
| `BREW_LIB_DIR`       | `10-brew.sh`           | Homebrew library path                                                       |
| `BREW_INCLUDE_DIR`   | `10-brew.sh`           | Homebrew include path                                                       |
| `CFLAGS`             | `10-brew.sh`           | Compiler include flags for C extensions                                     |
| `LDFLAGS`            | `10-brew.sh`           | Linker flags for Homebrew libraries                                         |
| `PATH`               | `10-brew.sh`           | Prepended with Homebrew, Neovim, and OpenJDK binaries                       |
| `PYENV_ROOT`         | `20-lang.sh`           | Base directory for Pyenv                                                    |
| `JAVA_HOME`          | `20-lang.sh`           | Java home path (via `/usr/libexec/java_home` or Linux fallback)            |
| `PATH`               | `20-lang.sh`           | Prepended with Pyenv shims, Ruby, and Gem bin directories                  |

## 🔧 Function & Tool Initialization Registry

| Function / Tool      | Defined In             | Description                                                              |
|----------------------|------------------------|--------------------------------------------------------------------------|
| `log_info`, `log_warn`, `log_error` | `lib/log.sh`             | Colorized logging functions using `tput`                                 |
| `source_sh_files`    | `lib/source_sh_files.sh` | Sources all readable `.sh` files from a directory                        |
| `direnv`             | `*.bashrc`, `*.zshrc`  | Initialized if available using `direnv hook bash/zsh`                   |
| `starship`           | `*.bashrc`, `*.zshrc`  | Prompt initialized using `eval "$(starship init bash/zsh)"`              |
| `carapace`           | `*.bashrc`, `*.zshrc`  | Completion tool sourced via `source <(carapace _carapace bash/zsh)`     |
| `atuin`              | `*.bashrc`, `*.zshrc`  | Shell history replacement, initialized via `eval "$(atuin init bash/zsh)"` |
| `zoxide`             | `*.bashrc`, `*.zshrc`  | Smart directory jumper, initialized using `eval "$(zoxide init bash/zsh)"` |

---

## 🧩 Modular Load Logic

### `source_sh_files`

Located at: `cli/lib/source_sh_files.sh`

This function sources all readable `.sh` files in a target directory
**in lexicographic order**. This enables control over load sequencing
(e.g., 00-core.sh → 10-brew.sh).

It supports:

- Cross-shell compatibility (Bash + Zsh)
- Logging with `log_info` / `log_warn` if defined
- Space-safe filename handling via `IFS=$'\n'`
- Skipping unreadable files with optional warnings

#### Example usage

```sh
source_sh_files "$XDG_CONFIG_HOME/cli/profile"
source_sh_files "$XDG_CONFIG_HOME/cli/cmd"
```

---

### `load_core.sh`

Located at: `cli/lib/load_core.sh`

This is the **entry point** for initializing your entire shell environment. It:

1. Loads the logging utilities (`log_info`, `log_warn`)
2. Loads the `source_sh_files` helper
3. Loads all files in `cli/profile/` (environment variables, paths)
4. Loads all files in `cli/cmd/` (aliases, functions, helpers)

```bash
# Example: ~/.zshrc or ~/.bashrc
CLI_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/cli"
LIB_DIR="$CLI_DIR/lib"
SCRIPT_LOADER="$LIB_DIR/load_core.sh"

[[ -f "$SCRIPT_LOADER" ]] && source "$SCRIPT_LOADER"
```

The loader allows you to keep your `.zshrc` and `.bashrc` minimal while still
supporting full configurability.

---

## 🧪 Logging Utilities

Located at: `cli/lib/log.sh`

Used by all CLI helpers to display:

- `[INFO]` in green
- `[WARN]` in yellow
- `[ERROR]` in red (future use)

Logging only activates if `tput` is available and writing to a terminal.

---

## 🧵 Zsh and Bash Integration

### `.bash_profile` and `.zprofile`

These are for login shells only. They do three things:

1. Source their corresponding interactive config file (`.bashrc` or `.zshrc`)
2. Initialize the SSH agent with Keychain
3. Export `SSH_AUTH_SOCK` to GUI apps via `launchctl`

```sh
# ZSH
ZSHRC="$HOME/.config/zsh/.zshrc"
[[ -f "$ZSHRC" ]] && source "$ZSHRC"
```

### `.bashrc` and `.zshrc`

These are for interactive shells. They:

- Suppress login message
- Initialize shell plugin systems (e.g., FZF, Carapace, Starship)
- Source the CLI loader system:

```sh
CLI_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/cli"
LIB_DIR="$CLI_DIR/lib"
SCRIPT_LOADER="$LIB_DIR/load_core.sh"

[[ -f "$SCRIPT_LOADER" ]] && source "$SCRIPT_LOADER"
```

---

## 🔀 Filename-Driven Load Order

The `profile/` directory uses numbered prefixes:

- `00-core.sh`: Sets OS + XDG paths, user environment (e.g., `$EDITOR`)
- `10-brew.sh`: Handles Homebrew-specific paths
- `20-lang.sh`: Loads language tooling (pyenv, ruby, java)

This ensures dependency order (e.g., `$HOMEBREW` before using `BREW_BIN_DIR`).

---

## ⚠️ Notes and Tips

- `env/` was renamed to `profile/` to avoid `.gitignore` conflicts and semantic ambiguity
- `typeset -f` is used over `declare -F` for Zsh compatibility
- Modular loading allows easy extension with files like `30-node.sh` or `functions.sh`
- Redefining `CLI_DIR` in `.bashrc` and `.zshrc` is harmless and ensures consistency

---

## ✅ Example Startup Log

```bash
[INFO] Sourced: ~/.config/cli/profile/00-core.sh
[INFO] Sourced: ~/.config/cli/profile/10-brew.sh
[INFO] Sourced: ~/.config/cli/profile/20-lang.sh
[INFO] Sourced: ~/.config/cli/cmd/aliases.sh
```

---

## 🧠 Conclusion

This setup balances clarity and extensibility. It supports both your daily
workflows and future modular growth — whether for new languages, tools, or
system behaviors.

All logic lives in sourceable `.sh` files under version control, and shell
startup is observable and fully debuggable.

```sh
# Manual reload example:
source ~/.config/cli/lib/load_core.sh
```

Use this README as your foundation for tuning, extending, or sharing your shell
configuration system.
