# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/packages/Brewfile
# Source: https://formulae.brew.sh/formula/
# Github: https://github.com/Homebrew/homebrew-core
# Description: Homebrew core packages (cross-platform, Linux/macOS).
#              For more info on Homebrew bundle, see:
#              https://docs.brew.sh/Brew-Bundle-and-Brewfile
# -----------------------------------------------------------------------------

# ----------------------- Homebrew Taps ---------------------- #
# Manage multiple Homebrew dependencies
tap 'homebrew/bundle'
# Start/stop macOS services
tap 'homebrew/services'

# ------------------------------------------------------------ #
#                     Terminal Environment                     #
# ------------------------------------------------------------ #

# -------------------------- Shells -------------------------- #
# Bourne-Again SHell, a UNIX command interpreter
brew 'bash'
# Modern shell for the GitHub era
brew 'nushell'

# -------------------- Terminal Utilities -------------------- #
# Pluggable terminal workspace, with terminal multiplexer as the base feature
brew 'zellij'
# Terminal multiplexer
brew 'tmux'
# Plugin manager for tmux
brew 'tpm'

# --------------------- Dotfiles Managers -------------------- #
# Organize software neatly under a single directory tree (e.g. /usr/local)
brew 'stow'
# Manage your dotfiles across multiple diverse machines, securely
brew 'chezmoi'

# ------------------ Environment Management ------------------ #
# Load/unload environment variables based on $PWD
brew 'direnv'
# Handy way to save and run project-specific commands
brew 'just'
# User-friendly front-end to ssh-agent to securely manage SSH keys
brew 'keychain'
# Editor of encrypted files
# brew 'sops'

# ------------------ Scripting & Development ----------------- #
# Static analysis and lint tool, for (ba)sh scripts
brew 'shellcheck'
# Autoformat shell script source code for POSIX sh, bash, zsh, ksh, and fish.
brew 'shfmt'

# -------------------- Shell Enhancements -------------------- #
# Improved shell history for zsh, bash, fish and nushell
brew 'atuin', restart_service: :changed
# Multi-shell multi-command argument completer
brew 'carapace'
# Fast, customizable cross-shell prompt
brew 'starship'
# Terminal file manager with vim-like keybindings, based on async I/O
brew 'yazi'

# ----------------------- Shell Plugins ---------------------- #
# Completion scripts for Bash 4.1+
brew 'bash-completion@2'
# Fish-like fast/unobtrusive autosuggestions for zsh
brew 'zsh-autosuggestions'
# Fish shell like syntax highlighting for zsh
brew 'zsh-syntax-highlighting'

# ----------------------- CLI Utilities ---------------------- #
# Smarter `cd` shell command to navigate your filesystem faster
brew 'zoxide'
# Modern, maintained replacement for ls
brew 'eza'
# Command-line fuzzy finder written in Go
brew 'fzf'
# Simple, fast and user-friendly alternative to find
brew 'fd'
# Fast file content search (grep and The Silver Searcher alternative)
brew 'ripgrep'
# File Viewer: Clone of cat(1) with syntax highlighting and Git integration
brew 'bat'

# Official tldr client written in Rust
brew 'tlrc'

# ------------------------------------------------------------ #
#                        Version Control                       #
# ------------------------------------------------------------ #
# Distributed revision control system
brew 'git'
# Audit git repos for secrets
brew 'gitleaks'
# Filter and rewrite Git repository history
brew 'git-filter-repo'
# Git extension for versioning large files
brew 'git-lfs'
# Syntax-highlighting pager for git and diff output
brew 'git-delta'

# A simple terminal UI for git commands, written in Go
tap 'jesseduffield/lazygit'
brew 'jesseduffield/lazygit/lazygit'

# ------------------------------------------------------------ #
#                    Development Environment                   #
# ------------------------------------------------------------ #

# ------------------- Languages & Runtimes ------------------- #
# Powerful, lightweight programming language
brew 'lua'
# MySQL: Open source RDBMS server
brew 'mysql', restart_service: :changed
# Node.js runtime platform built on V8 to build network applications
brew 'node'
# Java: Development kit for the Java programming language
brew 'openjdk'
# PostgreSQL: Object-relational database system
brew 'postgresql@17', restart_service: :changed
# Python: Interpreted, interactive, object-oriented programming language
brew 'python@3.13'
# Ruby: Powerful, clean, object-oriented scripting language
brew 'ruby'
# brew "rust"                                     # Rust programming language

# ------------- Language Server Protocols (LSPs) ------------- #
# Markdown: Language Server Protocol for Markdown
brew 'marksman'
# Lua: Language Server for the Lua language
brew 'lua-language-server'
# Rust: Experimental Rust compiler front-end for IDEs
brew 'rust-analyzer'
# Ruby language server
brew 'solargraph'
# LaTeX: Implementation of the Language Server Protocol for LaTeX
brew 'texlab'
# Language Server Protocol implementation for TypeScript wrapping tsserver
brew 'typescript-language-server'
# Language servers for HTML, CSS, JavaScript, and JSON extracted from vscode
brew 'vscode-langservers-extracted'
# Language Server for Yaml Files
brew 'yaml-language-server'

# >>> Python LSPs <<<
# Pyright fork with various improvements and built-in pylance features
brew 'basedpyright'
# Fast static code analyzer & language server for Python
brew 'pylyzer'
# brew "python-lsp-server"                # Language server for Python development

# --------------------- Python Toolchain --------------------- #
# Python version management
brew 'pyenv'
# Pyenv plugin to manage virtualenv
brew 'pyenv-virtualenv'
# Fast Python package installer and resolver (pip alternative)
brew 'uv'
# Interactive computing in Python Shell
brew 'ipython'
# Jupyter notebooks as Markdown documents, Julia, Python or R scripts
brew 'jupytext'

# ----------------------- Lua Toolchain ---------------------- #
# Just-In-Time Compiler (JIT) for the Lua programming language
brew 'luajit'
# Package manager for the Lua programming language
brew 'luarocks'

# ------------------- Linters & Formatters ------------------- #
# Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML
brew 'prettier'
# Spell checker for code and text
brew 'cspell'

# >>> Language Specific Formatters <<<
# Markdown: Fast, flexible, config-based cli for linting Markdown/CommonMark files
brew 'markdownlint-cli2'
# Python: Fast Python linter and formatter, written in Rust
brew 'ruff'
# SQL: SQL linter and auto-formatter for Humans
brew 'sqlfluff'
# SQL: Whitespace formatter for different query languages
brew 'sql-formatter'
# Lua: Opinionated Lua code formatter
brew 'stylua'

# ------------------------------------------------------------ #
#                         Modal Editors                        #
# ------------------------------------------------------------ #
# Ambitious Vim-fork focused on extensibility and agility
brew 'neovim'
# Post-modern modal text editor
brew 'helix'

# ------------------------------------------------------------ #
#                 Document Processing & Viewing                #
# ------------------------------------------------------------ #

# --------------------- Document Viewing --------------------- #
tap 'zegervdv/zathura'
# Lightweight document viewer (PDF, EPUB, PostScript)
brew 'zathura'
# MuPDF backend plugin for zathura
brew 'zathura-pdf-mupdf'
# Lightweight PDF and XPS viewer and tools
# brew "mupdf-tools"

# ------------- Document Processing & Conversion ------------- #
# Swiss-army knife of markup format conversion
brew 'pandoc'
# Convert images to PDF via direct JPEG inclusion
brew 'img2pdf'
# Tools for and transforming and inspecting PDF files
brew 'qpdf'
# PDF rendering library, based on the xpdf-3.0 code base
brew 'poppler'

# ------------ OCR: Optical Character Recognition ------------ #
# Adds an OCR text layer to scanned PDF files
brew 'ocrmypdf'
# OCR (Optical Character Recognition) engine
brew 'tesseract'

# ------------------------------------------------------------ #
#                       Image Processing                       #
# ------------------------------------------------------------ #
# CLI tools and libraries to manipulate images in many formats
brew 'imagemagick'
# Image format providing lossless and lossy compression for web images
brew 'webp'
# Library for encoding and decoding .avif files
brew 'libavif'
# Graph visualization tool (produces images)
brew 'graphviz'

# ------------------------------------------------------------ #
#              Multimedia (Audio/Video) Processing             #
# ------------------------------------------------------------ #
# Play, record, convert, and stream audio and video
brew 'ffmpeg'

# ------------------------------------------------------------ #
#                      MacOS-Only Formulae                     #
# ------------------------------------------------------------ #
if OS.mac?
  # ---------------------- CLI Utilities --------------------- #
  # Get events and tasks from the macOS calendar database
  brew 'ical-buddy'
  # Change macOS audio source from the command-line
  brew 'switchaudio-osx'
  # Retrieves currently playing media, and simulates media actions
  brew 'nowplaying-cli'
  # A window border system for macOS
  tap 'felixkratz/formulae'
  brew 'felixkratz/formulae/borders'

  # ---------------------------------------------------------- #
  #                MacOS Casks: GUI Applications               #
  # ---------------------------------------------------------- #
  cask_args appdir: '~/Applications'

  # ------------------- Terminal Emulators ------------------- #
  # Terminal emulator that uses platform-native UI and GPU acceleration
  cask 'ghostty'
  # AI terminal
  cask 'warp'
  # GPU-accelerated cross-platform terminal emulator and multiplexer
  cask 'wezterm'

  # --------------------- IDEs & Editors --------------------- #
  # Neovim Client
  cask 'neovide'
  # Keyboard-centric code editor
  cask 'zed'
  # Multiplayer code editor
  cask 'zed@preview'
  # Microsoft’s official code editor with extensions and debugging
  cask 'visual-studio-code'
  # Open-source version of Visual Studio Code without MS branding/telemetry/licensing
  # cask 'vscodium'

  # ----------------------- SQL Clients ---------------------- #
  # Visual tool to design, develop and administer MySQL servers
  cask 'mysqlworkbench'
  # Administration and development platform for PostgreSQL
  cask 'pgadmin4'

  # --------------- Knowledge Management (PKM) --------------- #
  # Markdown note-taking and PKM app
  cask 'obsidian'
  # Spaced repetition flashcard learning tool
  cask 'anki'
  # E-books management and library software
  cask 'calibre'
  # Collect, organise, cite, and share research sources
  cask 'zotero'
  # Handwritten notes and PDF annotation tool
  cask 'xournal++'

  # ----------------- Office & Document Tools ---------------- #
  # Free cross-platform office suite, fresh version
  cask 'libreoffice'
  # Collection of alternate languages for LibreOffice
  cask 'libreoffice-language-pack'
  # PDF viewer designed for reading research papers and technical books
  cask 'sioyek'
  # E-Book and document reader
  cask 'adobe-digital-editions'

  # ------------------- Productivity Tools ------------------- #
  # AeroSpace is an i3-like tiling window manager for macOS
  tap 'nikitabobko/tap'
  cask 'nikitabobko/tap/aerospace'
  # Drivers for DisplayLink docks, adapters and monitors
  cask 'displaylink'
  # Cross-platform Text Expander written in Rust
  cask 'espanso'
  # OpenAI's official ChatGPT desktop app
  cask 'chatgpt'

  # ---------------------- Cloud Storage --------------------- #
  # Google Drive client for macOS
  cask 'google-drive'
  # Microsoft cloud storage client
  cask 'onedrive'

  # ------------------------ Browsers ------------------------ #
  # Minimalist, gecko-based web browser
  cask 'zen'

  # ---------------------- Media Players --------------------- #
  # Open-source media player for video and audio
  cask 'vlc'

  # ---------------------- Communication --------------------- #
  # Team communication and collaboration software
  cask 'slack'
  # Video communication and virtual meeting platform
  cask 'zoom'

  # ---------------------- Miscellaneous --------------------- #
  # Electronics design automation suite
  cask 'kicad'

  # Peer to peer Bitorrent client
  cask 'qbittorrent'

  # Desktop password and login vault
  cask 'bitwarden'

  # ---------------------------------------------------------- #
  #                            Fonts                           #
  # ---------------------------------------------------------- #
  # Tool that provides consistent, highly configurable symbols for apps
  cask 'sf-symbols'
  cask 'font-fira-code-nerd-font'
  cask 'font-hack-nerd-font'
  cask 'font-jetbrains-mono-nerd-font'
  cask 'font-sf-mono'
  cask 'font-sf-pro'

  # ---------------------------------------------------------- #
  #                 Mac App Store Applications                 #
  # ---------------------------------------------------------- #
  # Mac App Store command-line interface
  brew 'mas'

  mas 'OneDrive', id: 823_766_827
  mas 'PDFgear', id: 6_469_021_132

  # ------------------ MacOS Built-in Tools ------------------ #
  mas 'iMovie', id: 408_981_434
  mas 'Keynote', id: 409_183_694
  mas 'Numbers', id: 409_203_825
  mas 'Pages', id: 409_201_541

  # -------------------- Safari Extensions ------------------- #
  mas 'AdBlock', id: 1_402_042_596
  mas 'darker', id: 1_637_413_102
  mas 'Documents Translator', id: 1_566_993_561
  mas 'G App Launcher', id: 1_543_803_459
  mas 'Mailbutler', id: 1_313_355_438
  mas 'Obsidian Web Clipper', id: 6_720_708_363
  mas 'OneTab', id: 1_540_160_809
end

# ------------------------------------------------------------ #
#                      VS Code Extensions                      #
# ------------------------------------------------------------ #

# ------------------------ UI & Themes ----------------------- #
vscode 'catppuccin.catppuccin-vsc'
vscode 'ibm.output-colorizer'
vscode 'naumovs.color-highlight'
vscode 'oderwat.indent-rainbow'
vscode 'vscode-icons-team.vscode-icons'

# -------------- Code Navigation & Productivity -------------- #
vscode 'alefragnani.project-manager'
vscode 'gruntfuggly.todo-tree'
# vscode "usernamehw.errorlens"

# ---------------- Productivity & AI Utilities --------------- #
# vscode "patbenatar.advanced-new-file"
vscode 'albert.tabout'
vscode 'almenon.arepl'
vscode 'codeium.codeium'
vscode 'github.copilot'
vscode 'github.copilot-chat'
vscode 'ionutvmi.path-autocomplete'
vscode 'njpwerner.autodocstring'
vscode 'randomfractalsinc.snippets-viewer'

# ------------------------- Comments ------------------------- #
vscode 'aaron-bond.better-comments'
vscode 'dnut.rewrap-revived'
vscode 'exodiusstudios.comment-anchors'
vscode 'polymermallard.box-comment'
vscode 'stackbreak.comment-divider'

# --------------------------- RegEx -------------------------- #
vscode 'chrmarti.regex'
vscode 'louiswt.regexp-preview'

# -------------------- Vim & Modal Editing ------------------- #
vscode 'asvetliakov.vscode-neovim'
vscode 'julianiaquinandi.nvim-ui-modifier'
vscode 'lancewilhelm.nvim-dashboard'
vscode 'vspacecode.whichkey'

# ------------------- Linters & Formatters ------------------- #
vscode 'esbenp.prettier-vscode'
vscode 'editorconfig.editorconfig'
vscode 'lacroixdavid1.vscode-format-context-menu'
vscode 'shardulm94.trailing-spaces'
vscode 'streetsidesoftware.code-spell-checker'
# vscode "jkillian.custom-local-formatters"
# vscode "jbockle.jbockle-format-files"

# ------------------------ Environment ----------------------- #
vscode 'mikestead.dotenv'

# ---------------------- Shell Utilities --------------------- #
vscode 'constneo.vscode-nushell-format'
vscode 'foxundermoon.shell-format'
vscode 'thenuprojectcontributors.vscode-nushell-lang'
vscode 'timonwong.shellcheck'

# ------------------- Git & Version Control ------------------ #
# vscode "eamodio.gitlens"
vscode 'github.remotehub'
vscode 'github.vscode-github-actions'
vscode 'github.vscode-pull-request-github'
vscode 'gitlab.gitlab-workflow'
vscode 'mhutchie.git-graph'
vscode 'vivaxy.vscode-conventional-commits'
vscode 'vsls-contrib.gistfs'

# -------------------- Remote Repositories ------------------- #
vscode 'ms-vscode-remote.remote-ssh'
vscode 'ms-vscode-remote.remote-ssh-edit'
vscode 'ms-vscode.azure-repos'
vscode 'ms-vscode.remote-explorer'
vscode 'ms-vscode.remote-repositories'

# --------------------- Jupyter Notebooks -------------------- #
vscode 'ms-toolsai.jupyter'
vscode 'ms-toolsai.jupyter-keymap'
vscode 'ms-toolsai.jupyter-renderers'
vscode 'ms-toolsai.vscode-jupyter-cell-tags'
vscode 'ms-toolsai.vscode-jupyter-slideshow'

# ----------------- Language Server Protocols ---------------- #
vscode 'nefrob.vscode-just-syntax'
vscode 'redhat.java'
vscode 'redhat.vscode-xml'
vscode 'redhat.vscode-yaml'
vscode 'sumneko.lua'
vscode 'tamasfe.even-better-toml'

# -------------------------- Python -------------------------- #
vscode 'charliermarsh.ruff'
vscode 'detachhead.basedpyright'
vscode 'joshrmosier.streamlit-runner'
vscode 'kevinrose.vsc-python-indent'
vscode 'marimo-team.vscode-marimo'
vscode 'ms-python.black-formatter'
vscode 'ms-python.debugpy'
vscode 'ms-python.python'
vscode 'plotlydashsnippets.plotly-dash-snippets'

# ------------------------ JavaScript ------------------------ #
vscode 'dbaeumer.vscode-eslint'
vscode 'ms-vscode.js-debug-nightly'

# --------------------------- HTML --------------------------- #
vscode 'formulahendry.auto-close-tag'
vscode 'formulahendry.auto-complete-tag'
vscode 'formulahendry.auto-rename-tag'
vscode 'george-alisson.html-preview-vscode'
vscode 'mohd-akram.vscode-html-format'

# ------------------------- Markdown ------------------------- #
vscode 'bierner.markdown-mermaid'
vscode 'bierner.markdown-yaml-preamble'
vscode 'bpruitt-goddard.mermaid-markdown-syntax-highlighting'
vscode 'darkriszty.markdown-table-prettify'
vscode 'davidanson.vscode-markdownlint'
vscode 'yzhang.markdown-all-in-one'
vscode 'felixzeller.markdown-oxide'
vscode 'marvhen.reflow-markdown'

# ---------------- Markdown, LaTeX, & Writing ---------------- #
# vscode "shd101wyy.markdown-preview-enhanced"
# vscode "kortina.vscode-markdown-notes"

# --------------------------- LaTeX -------------------------- #
vscode 'james-yu.latex-workshop'

# ---------------------------- SQL --------------------------- #
vscode 'inferrinizzard.prettier-sql-vscode'

# ------------------ CSV & Spreadsheet Tools ----------------- #
vscode 'grapecity.gc-excelviewer'
vscode 'mechatroner.rainbow-csv'
vscode 'ms-toolsai.datawrangler'
vscode 'janisdd.vscode-edit-csv'

# ------------------------ Data Viewer ----------------------- #
vscode 'randomfractalsinc.geo-data-viewer'
vscode 'randomfractalsinc.vscode-data-preview'

# ------------------ Miscellaneous Utilities ----------------- #
vscode 'spadin.zmk-tools'
vscode 'formulahendry.code-runner'
vscode 'techer.open-in-browser'
vscode 'tomoki1207.pdf'
