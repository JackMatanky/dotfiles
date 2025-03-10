# Dotfile

My dotfiles repo managed with GNU Stow on MacOS.

## CLI

### Shell

- [Nushell](https://www.nushell.sh/)

  ```bash
  brew install nushell
  ```

- [ZSH](https://zsh.sourceforge.io/)

  - [ZSH Autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)

  ```bash
  brew install zsh-autosuggestions
  ```

  - [ZSH Syntax Highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

  ```bash
  brew install zsh-syntax-highlighting
  ```

  - [ZSH Autocomplete](https://github.com/marlonrichert/zsh-autocomplete)

  ```bash
  brew install zsh-autocomplete
  ```

#### Plugins

- [Carapace](https://carapace.sh/)

```bash
brew install carapace
```

- [eza](https://eza.rocks/)

```bash
brew install eza
```

- [fzf](https://junegunn.github.io/fzf/)

```bash
brew install fzf
```

- [ripgrep](https://github.com/BurntSushi/ripgrep)

```bash
brew install ripgrep
```

- [fd](https://github.com/sharkdp/fd)

```bash
brew install fd
```

### Terminal Emulator

- [Wezterm](https://wezfurlong.org/wezterm/)

```bash
brew install --cask wezterm
```

### Multiplexxer

- [Zellij](https://zellij.dev/)

```bash
brew install zellij
```

### Prompt

- [Starship](https://starship.rs/)

```bash
brew install starship
```

### File Manager

- [Yazi](https://github.com/sxyazi/yaz)
  - [docs](https://yazi-rs.github.io/)

```bash
brew install yazi
```

## Development

- [Neovim](https://neovim.io/)

```bash
brew install neovim
```

- [Helix](https://helix-editor.com/)

```bash
brew install helix
```

- [Zed](https://zed.dev/)

```bash
brew install --cask zed
```

### Languages

#### Language Server Protocol

- [VS Code Language Servers](https://github.com/hrsh7th/vscode-langservers-extracted)

```bash
brew install vscode-langservers-extracted
```

Includes: - `vscode-html-language-server` - `vscode-css-language-server` - `vscode-json-language-server` - `vscode-eslint-language-server`

- [TypeScript Language Server](https://github.com/typescript-language-server/typescript-language-server)

```bash
brew install typescript-language-server
```

- [TexLab](https://github.com/latex-lsp/texlab)

```bash
brew install texlab
```

- [Yaml Language Server](https://github.com/redhat-developer/yaml-language-server)

```bash
brew install yaml-language-server
```

#### Python

- [Python](https://www.python.org/)

```bash
brew install python@3.13
```

- [Python Language Server](https://github.com/python-lsp/python-lsp-server)

```bash
brew install python-lsp-server
```

- [BasedPyright](https://github.com/DetachHead/basedpyright)

```bash
brew install basedpyright
```

- [Pylyzer](https://github.com/mtshiba/pylyzer)

```bash
brew install pylyzer
```

- [uv](https://github.com/astral-sh/uv)

```bash
brew install uv
```

- [iPython](https://ipython.org/)

```bash
brew install ipython
```

- [Jupytext](https://jupytext.readthedocs.io/)

```bash
brew install jupytext
```

- [ruff Formatter](https://docs.astral.sh/ruff/)

```bash
brew install ruff
```

- [isort](https://pycqa.github.io/isort/)

```bash
brew install isort
```

#### Java

- [Java Development Kit]()

used for zotero libreoffice plugin

```bash
brew install openjdk
```

If you need to have openjdk first in your PATH, run:
echo 'export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"' >> /Users/jack/.config/zsh/.zshrc

For compilers to find openjdk you may need to set:
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"

#### Markdown

- [Marksman](https://github.com/python-lsp/python-lsp-server)

```bash
brew install marksman
```

- [Markdown Lint](https://github.com/igorshubovych/markdownlint-cli)

```bash
brew install markdownlint-cli
```

#### Rust

- [Rust](https://www.rust-lang.org/)

```bash
brew install rust
```

#### Formatters

- [Prettier](https://prettier.io/)

```bash
brew install prettier
```

### Version Control

```bash
brew install git
brew install lazygit
```

```bash
brew install keychain
```

## Brower

- [Firefox](https://www.mozilla.org/firefox/)

```bash
brew install --cask firefox
```

## PKM

- [Obsidian](https://obsidian.md/)

```bash
brew install --cask obsidian
```

- [LibreOffice](https://www.libreoffice.org/)

```bash
brew install --cask libreoffice
```

- LibreOffice Language Pack

```bash
brew install --cask libreoffice-language-pack
```

- [Anki](https://apps.ankiweb.net/)

```bash
brew install --cask anki
brew install webp
brew install avif
```

- [tesseract OCR](https://github.com/tesseract-ocr/)

```bash
brew install tesseract
```

- [Zathura Document Viewer](https://pwmt.org/projects/zathura/)

```bash
brew install zathura
```

- MuPDF Plugin

```bash
brew install zathura-pdf-mupdf
mkdir -p $(brew --prefix zathura)/lib/zathura
ln -s $(brew --prefix zathura-pdf-mupdf)/libpdf-mupdf.dylib $(brew --prefix zathura)/lib/zathura/libpdf-mupdf.dylib
```
