# Homebrew
> [!info]
> Install core CLI packages for Linux and macOS, organized into logical groups for maximum portability and maintainability.

This repository uses a curated Brewfile to install and manage core CLI utilities across Linux and macOS.
Packages are structured into logical groups for maintainability and portability.
See [Brewfile](./packages/Brewfile) for details.

---

## Table of Contents

- [Brewfile Overview](#brewfile-overview)
  - [Structure](#structure)
    - [Terminal Environment](#terminal-environment)
    - [Version Control](#version-control)
    - [Development Environment](#development-environment)
    - [Document Processing & Viewing](#document-processing--viewing)
    - [Image Processing](#image-processing)
    - [Multimedia (Audio/Video) Processing](#multimedia-audiovideo-processing)
  - [Notes](#notes)

- [Brewfile_Cask Overview](#brewfile_cask-overview)
  - [Structure](#structure-1)
    - [Homebrew Taps](#homebrew-taps)
    - [macOS-Specific Formulae](#macos-specific-formulae)
    - [Casks (GUI Applications)](#casks-gui-applications)
    - [VS Code Extensions](#vs-code-extensions)
  - [Notes](#notes-1)

---

## Brewfile Overview
> [!info]
> Cross-platform CLI tools, language runtimes, LSPs, and utilities. Designed to work seamlessly on Linux and macOS.

This Brewfile manages core CLI packages for both Linux and macOS using [Homebrew](https://brew.sh/).
It installs terminal environments, developer tools, programming languages, document processors, and multimedia utilities in a clean, modular structure.

The Brewfile is organized into the following major sections:

---

## Structure

### Terminal Environment
> [!tip]
> Enhance your shell and terminal environment with shells, plugins, enhancements, and display utilities.

- **Shells**: Install and configure Bash and Nushell as cross-platform shells.
- **Shell Enhancements**: Improve terminal workflow with tools like *atuin* (command history), *stow* (dotfile management), *starship* (prompt customization), *zellij* (terminal multiplexer), and others.
- **Shell Plugins**: Install Bash and Zsh plugins to add completions, syntax highlighting, and autosuggestions.
- **CLI Utilities**: Core command-line tools for navigation, file search, content viewing, and task automation (e.g., *eza*, *fzf*, *fd*, *ripgrep*, *bat*, *just*).

### Version Control
> [!tip]
> Streamlined Git ecosystem tools for efficient version control workflows.

- Git and Git-related tools: *git*, *git-lfs*, *git-filter-repo*, and *lazygit* for a simple terminal Git UI.

### Development Environment
> [!tip]
> Setup major language runtimes, language servers, and development toolchains.

- **Languages & Runtimes**: Installs Python, Node.js, Lua, Java (OpenJDK), MySQL, and PostgreSQL.
- **Language Server Protocols (LSPs)**: Adds language server support for Markdown, Lua, Rust, Ruby, LaTeX, YAML, TypeScript, and Python.
- **Python Toolchain**: Python version management (*pyenv*), environment management (*pyenv-virtualenv*), fast package installation (*uv*), and interactive scripting tools (*ipython*, *jupytext*).
- **Lua Toolchain**: Lua JIT compiler (*luajit*) and Lua package manager (*luarocks*).
- **Linters & Formatters**: Install linters and formatters for Python, Lua, SQL, Markdown, and universal codebases (e.g., *ruff*, *stylua*, *markdownlint-cli2*, *sqlfluff*, *prettier*).

### Document Processing & Viewing
> [!tip]
> Tools for document conversion, OCR, and lightweight terminal document viewing.

- **Document Processing**: Utilities for converting, scanning, inspecting, and transforming PDFs and other document types (e.g., *pandoc*, *ocrmypdf*, *img2pdf*, *qpdf*, *poppler*).
- **Document Viewing**: Lightweight terminal-based PDF viewer (*zathura*) and its MuPDF backend.

### Image Processing
> [!tip]
> Manipulate and optimize images and graphs directly from the command line.

- Image tools include *imagemagick*, *webp*, *libavif* for image optimization, *tesseract* for OCR, and *graphviz* for graph rendering.

### Multimedia (Audio/Video) Processing
> [!tip]
> Powerful audio and video processing tools.

- *ffmpeg* for multimedia framework, supporting a wide range of audio and video conversions and transformations.

---

## Notes
> [!info]
> Important notes on cross-platform design and package management.

- **Cross-Platform**: All packages listed are compatible with both Linux and macOS.
- **Taps**: Specialized Homebrew taps are used for certain utilities (e.g., *lazygit*, *borders*, *zathura*), but paths are shortened for portability.
- **macOS-specific applications**: Are organized separately in a dedicated Caskfile to maintain portability in the core Brewfile.

---

## Brewfile_Cask Overview
> [!info]
> macOS-specific GUI applications, CLI utilities, and VS Code extensions, managed separately from cross-platform Brewfile packages.

This Brewfile_Cask manages Homebrew Cask installations for macOS graphical applications,
macOS-specific CLI formulae, and VS Code extensions.

It separates graphical applications and Mac-only tools from cross-platform CLI tools to maintain portability and system-specific clarity.

---

## Structure

### Homebrew Taps
- Required taps for certain formulae and casks (e.g., `felixkratz/formulae`, `jesseduffield/lazygit`, etc.).

### macOS-Specific Formulae
- CLI utilities that only make sense on macOS (e.g., `switchaudio-osx`, `nowplaying-cli`, `borders`, `lazygit`, `zathura`).

### Casks (GUI Applications)
- Applications organized into categories:
  - Media & Document Processing
  - Terminal Emulators
  - Editors & IDEs
  - SQL Clients
  - Productivity Tools
  - Knowledge Management (PKM)
  - Office Suites and Document Readers
  - Cloud Storage
  - Browsers
  - Media Players
  - Communication Tools
  - Fonts

### VS Code Extensions
- Extensions grouped by themes:
  - UI & Themes
  - Code Navigation & Productivity
  - Vim & Modal Editing
  - Git & Version Control
  - Python Development
  - JavaScript & Web Development
  - Markdown, LaTeX, and Writing
  - SQL & Databases
  - C++ and Low-Level Development
  - DevOps & Containers
  - Data Science & Research
  - Nix Development
  - CSV, JSON, and Miscellaneous Formats
  - Linters & Formatters
  - Miscellaneous Utilities

---

## Notes
> [!info]
> Cross-platform CLI tools are stored in the core Brewfile, while this file is dedicated to macOS-specific workflows.

- **Separation of concerns**: Brewfile_Cask manages GUI and macOS-only tools; Brewfile manages cross-platform CLI environments.
- **Portability**: This organization ensures minimal conflicts when syncing dotfiles across different operating systems.
- **Future-proofing**: VS Code extensions listed here will later migrate to VSCodium if necessary.
