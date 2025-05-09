# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/packages/Brewfile
# Source: https://formulae.brew.sh/formula/
# Github: https://github.com/Homebrew/homebrew-core
# Description: Homebrew core packages (cross-platform, Linux/macOS).
#              For more info on Homebrew bundle, see:
#              https://docs.brew.sh/Brew-Bundle-and-Brewfile
# -----------------------------------------------------------------------------

# >>> Homebrew Taps <<<
tap 'homebrew/bundle'                   # Manage multiple Homebrew dependencies
tap 'homebrew/services'                 # Start/stop macOS services

# ---------------------------------------------
# Terminal Environment
# ---------------------------------------------
# >>> Shells <<<
brew 'bash'                             # Bourne-Again SHell, a UNIX command interpreter
brew 'nushell'                          # Modern shell with structured data support

# >>> Terminal Utilities <<<
brew 'zellij'                           # Terminal workspace manager and multiplexer
brew 'tmux'                             # Terminal multiplexer
brew 'tpm'                              # Tmux plugin manager

# >>> Core Shell Tools <<<
brew 'stow'                             # Dotfiles symlink manager: Organize software neatly under a single directory tree (e.g. /usr/local)
brew 'keychain'                         # Securely manage SSH keys
brew 'just'                             # Handy way to save and run project-specific commands

# >>> Shell Enhancements <<<
brew 'direnv'                           # Load/unload environment variables based on $PWD
brew 'atuin', restart_service: :changed # Improved shell history for zsh, bash, fish and nushell
brew 'carapace'                         # Multi-shell multi-command argument completer
brew 'starship'                         # Fast, customizable shell prompt
brew 'shfmt'                            # Shell formatter for POSIX sh, bash, zsh, ksh, and fish.
brew 'yazi'                             # Terminal file manager with vim-like keybindings

# >>> Shell Plugins <<<
brew 'bash-completion@2'                # Completion scripts for Bash 4.1+
brew 'zsh-autosuggestions'              # Fish-like fast/unobtrusive autosuggestions for zsh
brew 'zsh-syntax-highlighting'          # Syntax highlights for commands in Zsh

# >>> CLI Utilities <<<
brew 'zoxide'                           # Smarter `cd` shell command to navigate your filesystem faster
brew 'eza'                              # Modern, maintained replacement for ls
brew 'fzf'                              # Command-line fuzzy finder written in Go
brew 'fd'                               # Simple, fast and user-friendly alternative to find
brew 'ripgrep'                          # Fast file content search (grep alternative)
brew 'bat'                              # File Viewer: Clone of cat(1) with syntax highlighting and Git integration

# ---------------------------------------------
# Version Control
# ---------------------------------------------
brew 'git'                              # Distributed revision control system
brew 'git-filter-repo'                  # Filter and rewrite Git repository history
brew 'git-lfs'                          # Git extension for versioning large files
brew 'git-delta'                        # Syntax-highlighting pager for git and diff output
brew 'jesseduffield/lazygit/lazygit'    # Simple terminal UI for Git commands

# ---------------------------------------------
# Development Environment
# ---------------------------------------------
# >>> Languages & Runtimes <<<
brew 'lua'                                      # Lightweight scripting language
brew 'mysql', restart_service: :changed         # MySQL: Open source RDBMS server
brew 'node'                                     # Node.js runtime platform built on V8 to build network applications
brew 'openjdk'                                  # Development kit for the Java programming language
brew 'postgresql@17', restart_service: :changed # PostgreSQL: Object-relational database system
brew 'python@3.13'                              # Python programming language
brew 'ruby'                                     # Ruby programming language
# brew "rust"                                     # Rust programming language

# >>> Language Server Protocols (LSPs) <<<
brew 'marksman'                         # Markdown LSP
brew 'lua-language-server'              # Lua LSP
brew 'rust-analyzer'                    # Rust LSP
brew 'solargraph'                       # Ruby LSP
brew 'texlab'                           # LaTeX LSP
brew 'typescript-language-server'       # TypeScript LSP wrapping tsserver
brew 'vscode-langservers-extracted'     # LSP for HTML, CSS, JavaScript, and JSON
brew 'yaml-language-server'             # YAML LSP

# --- Python LSPs ---
brew 'basedpyright'                     # Pyright fork with Pylance features
brew 'pylyzer'                          # Fast static code analyzer for Python
# brew "python-lsp-server"                # Language server for Python development

# >>> Python Toolchain <<<
brew 'pyenv'                            # Python version manager
brew 'pyenv-virtualenv'                 # Pyenv plugin for virtual environment management
brew 'uv'                               # Fast Python package installer and resolver (pip alternative)
brew 'ipython'                          # Interactive computing in Python shell
brew 'jupytext'                         # Convert Jupyter notebooks to plain scripts

# >>> Lua Toolchain <<<
brew 'luajit'                           # Just-In-Time (JIT) compiler for Lua
brew 'luarocks'                         # Lua package manager

# >>> Linters & Formatters <<<
brew 'prettier'                         # Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML
brew 'cspell'                           # Spell checker for code and text

# --- Language Specific Formatters ---
brew 'markdownlint-cli2'                  # Fast, flexible, config-based cli for linting Markdown/CommonMark files
brew 'ruff'                               # Fast Python linter and formatter, written in Rust
brew 'sqlfluff'                           # SQL linter and auto-formatter for Humans
brew 'sql-formatter'                      # Whitespace formatter for different query languages
brew 'stylua'                             # Opinionated Lua code formatter

# ---------------------------------------------
# Modal Editors
# ---------------------------------------------
brew 'neovim'                             # Ambitious Vim-fork focused on extensibility and agility
brew 'helix'                              # Post-modern modal text editor

# ---------------------------------------------
# Document Processing & Viewing
# ---------------------------------------------
# >>> Document Viewing <<<
tap 'zegervdv/zathura'
brew 'zathura' # Lightweight document viewer (PDF, EPUB, PostScript)
brew 'zathura-pdf-mupdf' # MuPDF backend plugin for zathura
# brew "mupdf-tools"                       # Lightweight PDF and XPS viewer and tools

# >>> Document Processing & Conversion <<<
brew 'pandoc'                             # Swiss-army knife of markup format conversion
brew 'img2pdf'                            # Convert images to PDF via direct JPEG inclusion
brew 'pdftoppm'                           # Convert PDF pages to images
brew 'qpdf'                               # Tools for transforming and inspecting PDF files
brew 'poppler'                            # PDF rendering library, based on the xpdf-3.0 code base

# >>> OCR: Optical Character Recognition <<<
brew 'ocrmypdf'                           # Adds an OCR text layer to scanned PDF files
brew 'tesseract'                          # OCR (Optical Character Recognition) engine

# ---------------------------------------------
# Image Processing
# ---------------------------------------------
brew 'imagemagick'                      # CLI tool for image manipulation
brew 'webp'                             # Image format providing lossless and lossy compression for web images
brew 'libavif'                          # AVIF image format tools
brew 'graphviz'                         # Graph visualization tool (produces images)

# ---------------------------------------------
# Multimedia (Audio/Video) Processing
# ---------------------------------------------
brew 'ffmpeg' # Play, record, convert, and stream audio and video

# ---------------------------------------------
# macOS-Only Formulae
# ---------------------------------------------
if OS.mac?
  # >>> CLI Utilities <<<
  brew 'switchaudio-osx'                # CLI for switching macOS audio devices
  brew 'nowplaying-cli'                 # Retrieves currently playing media, and simulates media actions
  brew 'felixkratz/formulae/borders'    # A window border system for macOS

  # ---------------------------------------------
  # MacOS Casks: GUI Applications
  # ---------------------------------------------
  cask_args appdir: '~/Applications'
  # >>> Terminal Emulators <<<
  cask 'ghostty'                        # Terminal emulator that uses platform-native UI and GPU acceleration
  cask 'wezterm'                        # GPU-accelerated cross-platform terminal emulator and multiplexer

  # >>> IDEs & Editors <<<
  cask 'zed'                            # Keyboard-centric code editor
  cask 'visual-studio-code'             # Microsoft’s official code editor with extensions and debugging
  # cask 'vscodium'                       # Open-source version of Visual Studio Code without MS branding/telemetry/licensing

  # >>> SQL Clients <<<
  cask 'mysqlworkbench'                 # Visual tool to design, develop and administer MySQL servers
  cask 'pgadmin4'                       # Administration and development platform for PostgreSQL

  # >>> Knowledge Management (PKM) <<<
  cask 'obsidian'                       # Markdown note-taking and PKM app
  cask 'anki'                           # Spaced repetition flashcard learning
  cask 'xournal++'                      # Handwritten notes and PDF annotation tool
  cask 'calibre'                        # eBook management and library software
  cask 'zotero'                         # Collect, organize, cite, and share research sources

  # >>> Office & Document Tools <<<
  cask 'libreoffice'                    # Free cross-platform office suite, fresh version
  cask 'libreoffice-language-pack'      # Collection of alternate languages for LibreOffice
  cask 'sioyek'                         # PDF reader optimized for research papers and technical papers
  cask 'adobe-digital-editions'         # eBook and document reader

  # >>> Productivity Tools <<<
  cask 'displaylink'                    # Drivers for DisplayLink docks, adapters and monitors
  cask 'nikitabobko/tapaerospace'       # AeroSpace is an i3-like tiling window manager for macOS
  cask 'espanso'                        # Cross-platform Text Expander written in Rust
  cask 'chatgpt'                        # OpenAI's official ChatGPT desktop app

  # >>> Cloud Storage <<<
  cask 'google-drive'                   # Google Drive client for macOS
  cask 'onedrive'                       # Microsoft cloud storage client

  # >>> Browsers <<<
  cask 'zen-browser' # Minimalist, gecko-based web browser

  # >>> Media Players <<<
  cask 'vlc' # Open-source media player for video and audio

  # >>> Communication <<<
  cask 'slack'                          # Team communication and collaboration software
  cask 'zoom'                           # Video communication and virtual meeting platform

  # ---------------------------------------------
  # Fonts
  # ---------------------------------------------
  cask 'sf-symbols'                           # Tool that provides consistent, highly configurable symbols for apps
  cask 'font-fira-code-nerd-font'             # Fira Code font with Nerd Font glyphs
  cask 'font-hack-nerd-font'                  # Hack font with Nerd Font glyphs
  cask 'font-jetbrains-mono-nerd-font'        # JetBrains Mono font with Nerd Font glyphs
  cask 'font-sf-mono'                         # Apple's SF Mono font
  cask 'font-sf-pro'                          # Apple's SF Pro font

  # ---------------------------------------------
  # Mac App Store Applications
  # ---------------------------------------------
  brew 'mas' # Mac App Store command-line interface

  mas 'OneDrive', id: 823_766_827
  mas 'PDFgear', id: 6_469_021_132

  # >>> MacOS Built-in Tools <<<
  mas 'iMovie', id: 408_981_434
  mas 'Keynote', id: 409_183_694
  mas 'Numbers', id: 409_203_825
  mas 'Pages', id: 409_201_541

  # >>> Safari Extensions <<<
  mas 'OneTab', id: 1_540_160_809
  mas 'AdBlock', id: 1_402_042_596
  mas 'darker', id: 1_637_413_102
  mas 'G App Launcher', id: 1_543_803_459
  mas 'Documents Translator', id: 1_566_993_561
  mas 'Obsidian Web Clipper', id: 6_720_708_363
end

# ---------------------------------------------
# VS Code Extensions
# ---------------------------------------------

# # >>> UI & Themes <<<
# vscode "catppuccin.catppuccin-vsc"
# vscode "vscode-icons-team.vscode-icons"

# # >>> Code Navigation & Productivity <<<
# vscode "gruntfuggly.todo-tree"
# vscode "exodiusstudios.comment-anchors"
# vscode "usernamehw.errorlens"

# # >>> Productivity & Utilities <<<
# vscode "streetsidesoftware.code-spell-checker"
# vscode "patbenatar.advanced-new-file"
# vscode "njpwerner.autodocstring"
# vscode "aaron-bond.better-comments"
# vscode "albert.tabout"

# # >>> Vim & Modal Editing <<<
# vscode "asvetliakov.vscode-neovim"
# vscode "vspacecode.whichkey"

# # >>> Linters & Formatters <<<
# vscode "esbenp.prettier-vscode"
# vscode "editorconfig.editorconfig"
# vscode "jkillian.custom-local-formatters"
# vscode "jbockle.jbockle-format-files"
# vscode "lacroixdavid1.vscode-format-context-menu"
# vscode "inferrinizzard.prettier-sql-vscode"

# # >>> Python <<<
# vscode "ms-python.python"
# vscode "ms-python.debugpy"
# vscode "charliermarsh.ruff"
# vscode "detachhead.basedpyright"
# vscode "marimo-team.vscode-marimo"

# # >>> HTML <<<
# vscode "formulahendry.auto-close-tag"
# vscode "formulahendry.auto-rename-tag"

# # >>> Git & Version Control <<<
# vscode "eamodio.gitlens"
# vscode "github.vscode-github-actions"
# vscode "github.vscode-pull-request-github"
# vscode "gitlab.gitlab-workflow"
# vscode "vsls-contrib.gistfs"

# # >>> Markdown, LaTeX, & Writing <<<
# vscode "davidanson.vscode-markdownlint"
# vscode "shd101wyy.markdown-preview-enhanced"
# vscode "james-yu.latex-workshop"
# vscode "kortina.vscode-markdown-notes"

# # >>> Languages <<<
# vscode "redhat.vscode-yaml"
# vscode "tamasfe.even-better-toml"
# vscode "thenuprojectcontributors.vscode-nushell-lang"

# # >>> CSV <<<
# vscode "mechatroner.rainbow-csv"
# vscode "janisdd.vscode-edit-csv"
# vscode "grapecity.gc-excelviewer"

# # >>> Miscellaneous Utilities <<<
# vscode "spadin.zmk-tools"
