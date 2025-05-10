# Dotfiles

Dotfiles repository managed with **GNU Stow** for **macOS** and **Linux (Ubuntu)**.

## Table of Contents

- [Dotfiles](#dotfiles)
  - [Table of Contents](#table-of-contents)
  - [Installation](#installation)
  - [Core System Tools](#core-system-tools)
    - [Shells](#shells)
    - [Terminal Emulators](#terminal-emulators)
    - [Core CLI Tools](#core-cli-tools)
    - [Shell Enhancements](#shell-enhancements)
    - [CLI Utilities](#cli-utilities)
    - [Terminal Multiplexers](#terminal-multiplexers)
    - [Version Control](#version-control)
  - [Development Environment](#development-environment)
    - [Language Server Protocols (LSPs)](#language-server-protocols-lsps)
    - [Python Tooling](#python-tooling)
    - [Java](#java)
    - [Markdown Tooling](#markdown-tooling)
    - [Rust](#rust)
    - [Formatters](#formatters)
  - [Personal Knowledge Management (PKM)](#personal-knowledge-management-pkm)
  - [Media and Document Processing](#media-and-document-processing)
  - [Browsers](#browsers)
  - [Unused / Archived Programs](#unused--archived-programs)

---

## Installation

For first-time setup, run:

```sh
chmod +x scripts/setup.sh
./scripts/setup.sh
```

---

## Core System Tools

### Shells

- [Nushell](https://www.nushell.sh/)

  - Modern structured-shell with pipelines and tables.

  ```sh
  brew install nushell
  ```

- [ZSH](https://zsh.sourceforge.io/)

  - Highly customizable traditional Unix shell.

  - ZSH Specific Plugins:

    - [ZSH Autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
    - [ZSH Syntax Highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
    - [ZSH Autocomplete](https://github.com/marlonrichert/zsh-autocomplete)

    ```sh
    brew install zsh-autosuggestions
    brew install zsh-syntax-highlighting
    brew install zsh-autocomplete
    ```

- [Bash](https://www.gnu.org/software/bash/) (Optional)

  - Classic Unix shell.

  ```sh
  brew install bash
  ```

  - Bash Specific Plugins:

    - [Bash Completion](https://github.com/scop/bash-completion)

    ```sh
    brew install bash-completion@2
    ```

    [Homebrew](https://formulae.brew.sh/formula/bash-completion@2) reccomends to
    add the following to `.bash_profile`:

    ```sh
    [[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]] && . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
    ```

    This ensures Bash completion is initialized properly in macOS login shells,
    which source .bash_profile by default.  
    However, in this dotfiles setup, all interactive shell logic — including
    Bash completions — is centralized in .bashrc, and .bash_profile simply
    sources .bashrc. This avoids duplication, keeps .bash_profile minimal, and
    ensures that completions are still available in both login and interactive
    shells without repeating logic.  
    For a modular and maintainable setup, it is therefore preferable to keep
    the completion logic in .bashrc only.
    See, [Bash Startup Files](https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html)

### Terminal Emulators

- [Ghostty](https://github.com/ghostty/ghostty)

  - GPU-accelerated, fast terminal emulator.

  ```sh
  brew install --cask ghostty
  ```

- [Wezterm](https://wezfurlong.org/wezterm/)

  - Highly configurable GPU-accelerated terminal emulator.

  ```sh
  brew install --cask wezterm
  ```

### Core CLI Tools

- [GNU Stow](https://www.gnu.org/software/stow/)

  - Dotfiles symlink farm manager which takes distinct sets of software and/or
    data located in separate directories on the filesystem, and makes them
    appear to be installed in a single directory tree.
  - Docs: <https://www.gnu.org/software/stow/manual/stow.html>

  ```sh
  brew install stow
  ```

- [Keychain](https://www.funtoo.org/Keychain)

  - Keychain helps you to manage SSH and GPG keys in a convenient and secure
    manner. It acts as a frontend to ssh-agent and ssh-add, but allows you to
    easily have one long running ssh-agent process per system, rather than the
    norm of one ssh-agent per login session.

  ```sh
  brew install keychain
  ```

### Shell Enhancements

- [Direnv](https://direnv.net/)

  - Load/unload environment variables based on $PWD
  - GitHub: <https://github.com/direnv/direnv>

  ```sh
  brew install direnv
  ```

- [shellcheck](https://www.shellcheck.net/)

  - Static analysis and lint tool, for (ba)sh scripts

  ```sh
  brew install shellcheck
  ```

- [shfmt](https://github.com/mvdan/sh)

  - Shell formatter for POSIX sh, bash, zsh, ksh, and fish.

  ```sh
  brew install shfmt
  ```

- [Atuin](https://github.com/atuinsh/atuin)

  - Shell history replacement with structured search and optional sync for zsh,
    bash, fish and nushell
  - Docs: <https://docs.atuin.sh>

  ```sh
  brew install atuin
  ```

- [Carapace](https://carapace.sh/)

  - Shell completion engine for multiple shells.

  ```sh
  brew install carapace
  ```

- [Starship](https://starship.rs/)

  - Cross-shell minimal prompt with extensive customization.

  ```sh
  brew install starship
  ```

- [Yazi](https://github.com/sxyazi/yazi)

  - Docs: <https://yazi-rs.github.io/>
  - Fast, modern terminal file manager with preview support.

  ```sh
  brew install yazi
  ```

### CLI Utilities

- [zoxide](https://github.com/ajeetdsouza/zoxide)

  - Smarter `cd` command with fuzzy matching.

  ```sh
  brew install zoxide
  ```

- [eza](https://eza.rocks/)

  - Modern `ls` replacement with color and git support.

  ```sh
  brew install eza
  ```

- [fzf](https://junegunn.github.io/fzf/)

  - Powerful fuzzy finder for files and history.

  ```sh
  brew install fzf
  ```

- [fd](https://github.com/sharkdp/fd)

  - Simple, fast alternative to `find`.

  ```sh
  brew install fd
  ```

- [ripgrep](https://github.com/BurntSushi/ripgrep)

  - Fast and recursive `grep` alternative.

  ```sh
  brew install ripgrep
  ```

- [bat](https://github.com/sharkdp/bat) (Optional)

  - Syntax-highlighted and paginated alternative to `cat`.

  ```sh
  brew install bat
  ```

### Terminal Multiplexers

- [Zellij](https://zellij.dev/)

  - Terminal workspace manager and multiplexer.

  ```sh
  brew install zellij
  ```

- [tmux](https://github.com/tmux/tmux) (Optional)

  - Traditional terminal multiplexer.

  ```sh
  brew install tmux
  ```

  - [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)

    - Tmux plugin manager

    ```sh
    brew install tpm
    ```

    To initialize TPM add this to your tmux configuration file
    (~/.tmux.conf or $XDG_CONFIG_HOME/tmux/tmux.conf):

    ```sh
    run '$HOMEBREW_PREFIX/opt/tpm/share/tpm/tpm'
    ```

### Version Control

- [Git](https://git-scm.com/)

  - Distributed version control system.

  ```sh
  brew install git
  ```

- [LazyGit](https://github.com/jesseduffield/lazygit)

  - Simple TUI for git commands.

  ```sh
  brew install lazygit
  ```

- [Git LFS](https://git-lfs.github.com/)

  - Support for large files in git repositories.

  ```sh
  brew install git-lfs
  ```

- [Git Filter Repo](https://github.com/newren/git-filter-repo)

  - Efficient git history rewriting tool.

  ```sh
  brew install git-filter-repo
  ```

- [Delta](https://github.com/dandavison/delta)

  - Docs: <https://dandavison.github.io/delta/introduction.html>
  - A syntax-highlighting pager for git, diff, grep, and blame output

  ```sh
  brew install git-delta
  ```

- [GitLeaks](https://gitleaks.io/)
  
  - GitHub: https://github.com/gitleaks/gitleaks
  - Gitleaks is a tool for detecting secrets like passwords, API keys, and tokens
    in git repos, files, and whatever else you wanna throw at it via stdin.
  
  ```sh
  brew install gitleaks
  ```

## Development Environment

- [Neovim](https://neovim.io/)

  - Hyperextensible Vim-based text editor.

  ```sh
  brew install neovim
  ```

- [Helix](https://helix-editor.com/)

  - Postmodern modal text editor.

  ```sh
  brew install helix
  ```

- [Zed](https://zed.dev/)

  - High-performance collaborative code editor.

  ```sh
  brew install --cask zed
  ```

- [VS Code](https://code.visualstudio.com/)

  - Extensible code editor.

  ```sh
  brew install --cask visual-studio-code
  ```

  - Note: When first opening VS Code, ssh-agent did not work properly.
    See, [VS Code SSH Passphrase Error and Solution](_notes/vscode_ssh_passphrase_error.md)

### Language Server Protocols (LSPs)

- [VS Code Language Servers](https://github.com/hrsh7th/vscode-langservers-extracted)

  - Extracted LSP servers:
    - HTML: `vscode-html-language-server`
    - CSS: `vscode-css-language-server`
    - JSON: `vscode-json-language-server`
    - ESLint: `vscode-eslint-language-server`

  ```sh
  brew install vscode-langservers-extracted
  ```

- [TypeScript Language Server](https://github.com/typescript-language-server/typescript-language-server)

  ```sh
  brew install typescript-language-server
  ```

- [TexLab](https://github.com/latex-lsp/texlab)

  - LaTeX Language Server.

  ```sh
  brew install texlab
  ```

- [Yaml Language Server](https://github.com/redhat-developer/yaml-language-server)

  ```sh
  brew install yaml-language-server
  ```

- [Solargraph](https://solargraph.org)

  - Ruby Language Server
  - Note: Primarily used for handling Homebrew related tasks on my machine.

  ```sh
  brew install solargraph
  ```

### Python Tooling

- [Python](https://www.python.org/)

  - Latest version of the Python programming language.

  ```sh
  brew install python@3.13
  ```

- [BasedPyright](https://github.com/DetachHead/basedpyright)

  - Open source LSP and pype checker for Python based on Pyright.

  ```sh
  brew install basedpyright
  ```

- [Pylyzer](https://github.com/mtshiba/pylyzer)

  - Fast static analysis for Python.

  ```sh
  brew install pylyzer
  ```

- [uv](https://github.com/astral-sh/uv)

  - Extremely fast Python package installer and resolver.

  ```sh
  brew install uv
  ```

- [IPython](https://ipython.org/)

  - Rich interactive Python shell.

  ```sh
  brew install ipython
  ```

- [Jupytext](https://jupytext.readthedocs.io/)

  - Sync Jupyter notebooks and plain text scripts.

  ```sh
  brew install jupytext
  ```

- [ruff](https://docs.astral.sh/ruff/)

  - Extremely fast Python linter and formatter.

  ```sh
  brew install ruff
  ```

- [isort](https://pycqa.github.io/isort/)

  - Automatically sort Python imports.

  ```sh
  brew install isort
  ```

### Java

- [OpenJDK](https://openjdk.org/)

  - Open-source Java Development Kit.

  ```sh
  brew install openjdk
  ```

  If you need to add to `PATH`:

  ```sh
  echo 'export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"' >> ~/.zshrc
  ```

  And for compilers:

  ```sh
  export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"
  ```

### Markdown Tooling

- [Marksman](https://github.com/artempyanykh/marksman)

  - Markdown Language Server.

  ```sh
  brew install marksman
  ```

- [Markdownlint CLI](https://github.com/igorshubovych/markdownlint-cli)

  - Markdown linter and style checker.

  ```sh
  brew install markdownlint-cli
  ```

### Rust

- [Rust](https://www.rust-lang.org/)

  - Systems programming language.

  ```sh
  brew install rust
  ```

### Formatters

- [Prettier](https://prettier.io/)

  - Code formatter supporting multiple languages.

  ```sh
  brew install prettier
  ```

- [cSpell](https://cspell.org)

  - GitHub: <https://github.com/streetsidesoftware/cspell>

  - Spell checker for code and text.

  ```sh
  brew install cspell
  ```

---

## Personal Knowledge Management (PKM)

- [Obsidian](https://obsidian.md/)

  - Personal knowledge base and markdown editor.

  ```sh
  brew install --cask obsidian
  ```

- [Anki](https://apps.ankiweb.net/)

  - Spaced repetition flashcard software.

  ```sh
  brew install --cask anki
  brew install webp
  brew install avif
  ```

- [Calibre](https://calibre-ebook.com/)

  - Comprehensive e-book management software.

  ```sh
  brew install --cask calibre
  ```

---

## Media and Document Processing

- [LibreOffice](https://www.libreoffice.org/)

  - Free office suite and language pack

  ```sh
  brew install --cask libreoffice
  brew install --cask libreoffice-language-pack
  ```

- [Zathura Document Viewer](https://pwmt.org/projects/zathura/)

  - [GitHub](https://github.com/pwmt/zathura)
  - Lightweight document viewer.

  ```sh
  brew install zathura
  ```

  - MuPDF Plugin for Zathura:

    ```sh
    brew install zathura-pdf-mupdf
    mkdir -p $(brew --prefix zathura)/lib/zathura
    ln -s $(brew --prefix zathura-pdf-mupdf)/libpdf-mupdf.dylib $   (brew --prefix zathura)/lib/zathura/libpdf-mupdf.dylib
    ```

- [OCRmyPDF](https://ocrmypdf.readthedocs.io/en/latest/)

  - [GitHub](https://github.com/ocrmypdf/OCRmyPDF)
  - Adds OCR text layers to PDFs.

  ```sh
  brew install ocrmypdf
  ```

- [tesseract OCR](https://github.com/tesseract-ocr/)

  - Optical character recognition engine.

  ```sh
  brew install tesseract
  ```

- [qpdf](https://qpdf.readthedocs.io/en/stable/)

  - [GitHub](https://github.com/qpdf/qpdf)
  - PDF transformation and inspection tool.

  ```sh
  brew install qpdf
  ```

- [img2pdf](https://github.com/jwilk/img2pdf)

  - Convert images to PDF without quality loss.

  ```sh
  brew install img2pdf
  ```

---

## Browsers

- [Zen Browser](https://zen-browser.app/)

  - Lightweight, distraction-free browser.

  ```sh
  brew install --cask zen-browser
  ```

---

## Unused / Archived Programs

- [VSCodium](https://vscodium.com)

  - [Docs](https://vscodium.com); [GitHub](https://github.com/VSCodium/vscodium)
  - a community-driven, freely-licensed binary distribution of Microsoft’s
    editor VS Code without Microsoft branding, telemetry, and licensing.

  ```sh
  brew install --cask vscodium
  ```

  - Microsoft Marketplace Setup:

    - <https://github.com/flathub/com.vscodium.codium/issues/90>
    - <https://github.com/VSCodium/vscodium/pull/674>

  - Note:
    - I stopped using VSCodium because it became to slow and often their were
      glitches in the UI

- [MuPDF Tools](https://mupdf.com/) (Archived)

  - Lightweight PDF and XPS viewer toolkit.

  ```sh
  brew install mupdf-tools
  ```

- [Signal](https://signal.org/) (Archived)

  - Secure private messaging app.

  ```sh
  brew install --cask signal
  ```
