# Dotfiles

Dotfiles repository managed with **GNU Stow** for **macOS** and **Linux (Ubuntu)**.

# Table of Contents

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

# Installation

For first-time setup, run:

```sh
chmod +x scripts/setup.sh
./scripts/setup.sh
```

---

# Core System Tools

<details><summary>Shells</summary>

- **[Nushell](https://www.nushell.sh/)** — Modern shell with structured data support.
- **[ZSH](https://zsh.sourceforge.io/)** — Customizable traditional Unix shell.
- **[Bash](https://www.gnu.org/software/bash/)** (Optional) — Traditional Unix shell.

</details>

<details><summary>Terminal Emulators</summary>

- **[Ghostty](https://github.com/ghostty/ghostty)** — GPU-accelerated terminal emulator.
- **[Wezterm](https://wezfurlong.org/wezterm/)** — Configurable GPU-accelerated terminal.

</details>

<details><summary>Shell Enhancements</summary>

- **[Carapace](https://carapace.sh/)** — Multi-shell command completion.
- **[Starship](https://starship.rs/)** — Cross-shell prompt.
- **[Keychain](https://www.funtoo.org/Keychain)** — SSH key manager.
- **[Stow](https://www.gnu.org/software/stow/)** — Dotfiles symlink manager.

</details>

<details><summary>CLI Utilities</summary>

- **[eza](https://eza.rocks/)** — Modern `ls` alternative.
- **[fzf](https://junegunn.github.io/fzf/)** — Fuzzy finder.
- **[ripgrep](https://github.com/BurntSushi/ripgrep)** — Fast recursive search.
- **[fd](https://github.com/sharkdp/fd)** — Simpler `find` alternative.
- **[bat](https://github.com/sharkdp/bat)** (Optional) — Syntax-highlighted `cat`.
- **[zoxide](https://github.com/ajeetdsouza/zoxide)** (Optional) — Smarter `cd`.

</details>

<details><summary>Terminal Multiplexer</summary>

- **[Zellij](https://zellij.dev/)** — Terminal workspace manager.

</details>

---

# Development Environment

<details><summary>Editors</summary>

- **[Neovim](https://neovim.io/)** — Extensible Vim-based editor.
- **[Helix](https://helix-editor.com/)** — Modal text editor with LSP.
- **[Zed](https://zed.dev/)** — High-performance collaborative editor.
- **[Visual Studio Code](https://code.visualstudio.com/)** (Optional) — Lightweight IDE.

</details>

<details><summary>Version Control</summary>

- **[Git](https://git-scm.com/)** — Version control system.
- **[LazyGit](https://github.com/jesseduffield/lazygit)** — Git TUI client.
- **[Git LFS](https://git-lfs.github.com/)** — Large file storage for Git.
- **[Git Filter Repo](https://github.com/newren/git-filter-repo)** — Git history rewriting tool.

</details>

<details><summary>Languages and Runtimes</summary>

- **[Python 3.13](https://www.python.org/)** — Python programming language.
- **[Rust](https://www.rust-lang.org/)** — Systems programming language.
- **[Node.js](https://nodejs.org/)** — JavaScript runtime.
- **[Lua](https://www.lua.org/)** — Lightweight scripting language.
- **[OpenJDK](https://openjdk.org/)** — Java Development Kit.
- **[MySQL](https://www.mysql.com/)** (Optional) — Relational database.
- **[PostgreSQL](https://www.postgresql.org/)** (Optional) — Advanced database system.

</details>

<details><summary>Language Servers</summary>

- **[VS Code Language Servers](https://github.com/hrsh7th/vscode-langservers-extracted)** — HTML, CSS, JSON, ESLint.
- **[TypeScript Language Server](https://github.com/typescript-language-server/typescript-language-server)**.
- **[TexLab](https://github.com/latex-lsp/texlab)** — LaTeX support.
- **[YAML Language Server](https://github.com/redhat-developer/yaml-language-server)**.
- **[BasedPyright](https://github.com/DetachHead/basedpyright)** — Python LSP.
- **[Pylyzer](https://github.com/mtshiba/pylyzer)** — Static analyzer.
- **[Rust Analyzer](https://rust-analyzer.github.io/)** (Optional).
- **[Lua Language Server](https://github.com/LuaLS/lua-language-server)** (Optional).
- **[Marksman](https://github.com/artempyanykh/marksman)** — Markdown LSP.

</details>

<details><summary>SQL Clients</summary>

- **[MySQL Workbench](https://www.mysql.com/products/workbench/)**.
- **[pgAdmin4](https://www.pgadmin.org/)**.

</details>

<details><summary>Python Tools</summary>

- **[Python LSP Server](https://github.com/python-lsp/python-lsp-server)** (Optional).
- **[uv](https://github.com/astral-sh/uv)**.
- **[IPython](https://ipython.org/)**.
- **[Jupytext](https://jupytext.readthedocs.io/)**.
- **[ruff](https://docs.astral.sh/ruff/)**.
- **[isort](https://pycqa.github.io/isort/)**.

</details>

<details><summary>Linters & Formatters</summary>

- **[Prettier](https://prettier.io/)**.
- **[markdownlint-cli2](https://github.com/DavidAnson/markdownlint-cli2)**.
- **[stylua](https://github.com/JohnnyMorganz/StyLua)** (Optional).
- **[sqlfluff](https://docs.sqlfluff.com/)** (Optional).

</details>

---

# Personal Knowledge Management (PKM)

<details><summary>PKM Tools</summary>

- **[Obsidian](https://obsidian.md/)**.
- **[Anki](https://apps.ankiweb.net/)**.
- **[Calibre](https://calibre-ebook.com/)**.
- **[Zotero](https://www.zotero.org/)**.
- **[Xournal++](https://xournalpp.github.io/)**.

</details>

---

# Media and Document Processing

<details><summary>Office and Document Tools</summary>

- **[LibreOffice](https://www.libreoffice.org/)**.
- **[Zathura](https://pwmt.org/projects/zathura/)**.
- **[ocrmypdf](https://ocrmypdf.readthedocs.io/en/latest/)**.
- **[tesseract](https://github.com/tesseract-ocr/tesseract/)**.
- **[img2pdf](https://github.com/jwilk/img2pdf)**.
- **[qpdf](https://qpdf.readthedocs.io/en/stable/)**.
- **[Adobe Digital Editions](https://www.adobe.com/solutions/ebook/digital-editions.html)**.

</details>

<details><summary>Media Tools</summary>

- **[VLC](https://www.videolan.org/vlc/)**.
- **[pandoc](https://pandoc.org/)** (Optional).
- **[poppler](https://poppler.freedesktop.org/)** (Optional).
- **[imagemagick](https://imagemagick.org/)** (Optional).
- **[ffmpeg](https://ffmpeg.org/)** (Optional).

</details>

---

# Cloud Storage

<details><summary>Cloud Services</summary>

- **[OneDrive](https://www.microsoft.com/en-us/microsoft-365/onedrive/online-cloud-storage)**.
- **[Google Drive](https://www.google.com/drive/)**.

</details>

---

# Communication Tools

<details><summary>Communication Apps</summary>

- **[Slack](https://slack.com/)**.

</details>

---

# Browsers

- **[Zen Browser](https://zen-browser.app/)**.

---

# Unused / Archived Programs

- **mupdf-tools** — Lightweight PDF and XPS tools.
- **signal** — Secure messaging application.