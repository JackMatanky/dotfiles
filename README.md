# Dotfiles

Dotfiles repository managed with **GNU Stow** for **macOS** and **Linux (Ubuntu)**.

## Table of Contents

- [Installation](#installation)
- [Core System Tools](#core-system-tools)
- [Development Environment](#development-environment)
- [Personal Knowledge Management (PKM)](#personal-knowledge-management-pkm)
- [Media and Document Processing](#media-and-document-processing)
- [Cloud Storage](#cloud-storage)
- [Communication Tools](#communication-tools)
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

    - Modern shell with structured data support.

    ```sh
    brew install nushell
    ```

- [ZSH](https://zsh.sourceforge.io/)

    - Traditional Unix shell with powerful customization.

    - ZSH Specific Plugins:

        - [ZSH Autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
        - [ZSH Syntax Highlighting] (https://github.com/zsh-users/zsh-syntax-highlighting)
        - [ZSH Autocomplete](https://github.com/marlonrichert/zsh-autocomplete)

        ```sh
        brew install zsh-autosuggestions
        brew install zsh-syntax-highlighting
        brew install zsh-autocomplete
        ```

- [Bash](https://www.gnu.org/software/bash/)

    - (Optional) — Traditional Unix shell.

    ```sh
    brew install bash
    ```

    - Bash Specific Plugins:

        - [Bash Completion](https://github.com/scop/bash-completion)

        ```sh
        brew install bash-completion@2
        ```

        Note: Add the following line to your ~/.bash_profile:

        ```sh
        [[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]] && . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
        ```

### Terminal Emulators

- [Ghostty](https://github.com/ghostty/ghostty)
    - GPU-accelerated terminal emulator.

    ```sh
    brew install --cask ghostty
    ```

- [Wezterm](https://wezfurlong.org/wezterm/)

    ```sh
    brew install --cask wezterm
    ```

### Shell Enhancements

- [GNU Stow](https://www.gnu.org/software/stow/)
    - Dotfiles symlink farm manager which takes distinct sets of software and/or data located in separate directories on the filesystem, and makes them appear to be installed in a single directory tree.
    - Docs: https://www.gnu.org/software/stow/manual/stow.html

    ```sh
    brew install stow
    ```

- [Keychain](https://www.funtoo.org/Keychain)
    - Keychain helps you to manage SSH and GPG keys in a convenient and secure manner. It acts as a frontend to ssh-agent and ssh-add, but allows you to easily have one long running ssh-agent process per system, rather than the norm of one ssh-agent per login session.

    ```sh
    brew install keychain
    ```

- [Atuin](https://github.com/atuinsh/atuin)
    - Improved shell history manager for zsh, bash, fish and nushell
    - Docs: https://docs.atuin.sh

    ```sh
    brew install atuin
    ```

- [Carapace](https://carapace.sh/)
    - Multi-shell command completion

    ```sh
    brew install carapace
    ```

- [eza](https://eza.rocks/)

    ```sh
    brew install eza
    ```

- [fzf](https://junegunn.github.io/fzf/)

    ```sh
    brew install fzf
    ```

- [ripgrep](https://github.com/BurntSushi/ripgrep)

    ```sh
    brew install ripgrep
    ```

- [fd](https://github.com/sharkdp/fd)

    ```sh
    brew install fd
    ```

### Multiplexxer

- [Zellij](https://zellij.dev/)

    ```sh
    brew install zellij
    ```

### Prompt

- [Starship](https://starship.rs/)

    ```sh
    brew install starship
    ```

### File Manager

- [Yazi](https://github.com/sxyazi/yaz)
    - [docs](https://yazi-rs.github.io/)

    ```sh
    brew install yazi
    ```

### SSH


### Version Control

- [Git](https://git-scm.com/)

    ```sh
    brew install git
    ```

- [LazyGit](https://github.com/jesseduffield/lazygit)

    ```sh
    brew install lazygit
    ```

- [Git Large File Storage](https://git-lfs.github.com/)

    ```sh
    brew install git-lfs
    ```

- [Git Filter Repo](https://github.com/newren/git-filter-repo)

    ```sh
    brew install git-filter-repo
    ```

## Development

- [Neovim](https://neovim.io/)

    ```sh
    brew install neovim
    ```

- [Helix](https://helix-editor.com/)

    ```sh
    brew install helix
    ```

- [Zed](https://zed.dev/)

    ```sh
    brew install --cask zed
    ```

### Languages

#### Language Server Protocol

- [VS Code Language Servers](https://github.com/hrsh7th/vscode-langservers-extracted)

    ```sh
    brew install vscode-langservers-extracted
    ```

Includes: - `vscode-html-language-server` - `vscode-css-language-server` - `vscode-json-language-server` - `vscode-eslint-language-server`

- [TypeScript Language Server](https://github.com/typescript-language-server/typescript-language-server)

    ```sh
    brew install typescript-language-server
    ```

- [TexLab](https://github.com/latex-lsp/texlab)

    ```sh
    brew install texlab
    ```

- [Yaml Language Server](https://github.com/redhat-developer/yaml-language-server)

    ```sh
    brew install yaml-language-server
    ```

#### Python

- [Python](https://www.python.org/)

    ```sh
    brew install python@3.13
    ```

- [Python Language Server](https://github.com/python-lsp/python-lsp-server)

    ```sh
    brew install python-lsp-server
    ```

- [BasedPyright](https://github.com/DetachHead/basedpyright)

    ```sh
    brew install basedpyright
    ```

- [Pylyzer](https://github.com/mtshiba/pylyzer)

    ```sh
    brew install pylyzer
    ```

- [uv](https://github.com/astral-sh/uv)

    ```sh
    brew install uv
    ```

- [iPython](https://ipython.org/)

    ```sh
    brew install ipython
    ```

- [Jupytext](https://jupytext.readthedocs.io/)

    ```sh
    brew install jupytext
    ```

- [ruff Formatter](https://docs.astral.sh/ruff/)

    ```sh
    brew install ruff
    ```

- [isort](https://pycqa.github.io/isort/)

    ```sh
    brew install isort
    ```

#### Java

- [Java Development Kit]()

used for zotero libreoffice plugin

    ```sh
    brew install openjdk
    ```

If you need to have openjdk first in your PATH, run:
echo 'export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"' >> /Users/jack/.config/zsh/.zshrc

For compilers to find openjdk you may need to set:
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"

#### Markdown

- [Marksman](https://github.com/python-lsp/python-lsp-server)

    ```sh
    brew install marksman
    ```

- [Markdown Lint](https://github.com/igorshubovych/markdownlint-cli)

    ```sh
    brew install markdownlint-cli
    ```

#### Rust

- [Rust](https://www.rust-lang.org/)

    ```sh
    brew install rust
    ```

#### Formatters

- [Prettier](https://prettier.io/)

    ```sh
    brew install prettier
    ```

## Browser

- [Zen Browser](https://zen-browser.app/)

    ```sh
    brew install --cask zen-browser
    ```

## PKM

- [Obsidian](https://obsidian.md/)

    ```sh
    brew install --cask obsidian
    ```

- [Anki](https://apps.ankiweb.net/)

```sh
brew install --cask anki
brew install webp
brew install avif
```

- [Calibre](https://calibre-ebook.com)

    ```sh
    brew install --cask calibre
    ```

## Document Viewer and Processor

- [LibreOffice](https://www.libreoffice.org/)

    ```sh
    brew install --cask libreoffice
    ```

- LibreOffice Language Pack

    ```sh
    brew install --cask libreoffice-language-pack
    ```

- Zathura Document Viewer
    - [Docs](https://pwmt.org/projects/zathura/)
    - [GitHub](https://github.com/pwmt/zathura)

    ```sh
    brew install zathura
    ```

- MuPDF Plugin

```sh
brew install zathura-pdf-mupdf
mkdir -p $(brew --prefix zathura)/lib/zathura
ln -s $(brew --prefix zathura-pdf-mupdf)/libpdf-mupdf.dylib $(brew --prefix zathura)/lib/zathura/libpdf-mupdf.dylib
```

- OCRmyPDF
    - [Docs](https://ocrmypdf.readthedocs.io/en/latest/)
    - [GitHub](https://github.com/ocrmypdf/OCRmyPDF)

    ```sh
    brew install ocrmypdf
    ```

- [tesseract OCR](https://github.com/tesseract-ocr/)

    ```sh
    brew install tesseract
    ```

- qpdf: Tool for manipulating PDF files
    - [Docs](https://qpdf.readthedocs.io/en/stable/index.html)
    - [GitHub](https://github.com/qpdf/qpdf)

    ```sh
    brew install qpdf
    ```

- [img2pdf](https://github.com/jwilk/img2pdf)

    ```sh
    brew install img2pdf
    ```
