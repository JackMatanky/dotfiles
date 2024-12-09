# Zed Extensions Repo: https://github.com/zed-industries/extensions/tree/main/extensions
{
  config,
  pkgs,
  ...
}: {
  programs.zed-editor.extensions = [
    # AsciiDoc: https://github.com/andreicek/zed-asciidoc
    "asciidoc"
    # Autocorrect: https://github.com/huacnlee/zed-autocorrect
    "autocorrect"
    # Base16 Theme: https://github.com/bswinnerton/base16-zed
    "base16"
    # Bash: https://github.com/d1y/bash.zed
    "basher"
    # Basedpyright: https://github.com/m1guer/basedpyright-zed
    "basedpyright"
    # CSV: https://github.com/huacnlee/zed-csv
    "csv"
    # Database Markup Language (DBML): https://github.com/shuklaayush/zed-dbml
    "dbml"
    # DeviceTree: https://github.com/anikinmd/zed_devicetree
    "devicetree"
    # Environment Support: https://github.com/zarifpour/zed-env
    "env"
    # Gemini Syntax Highlighting
    "gemini"
    # Git Firefly: https://github.com/d1y/git_firefly
    "git-firefly"
    "html"
    # Justfile: https://github.com/jackTabsCode/zed-just
    "just"
    # LaTeX: https://github.com/rzukic/zed-latex
    "latex"
    # Lua
    "lua"
    # Makefile: https://github.com/caius/zed-make
    "make"
    # Markdown Oxide: https://github.com/Feel-ix-343/markdown-oxide-zed
    "markdown-oxide"
    # Marksman MD: https://github.com/vitallium/zed-marksman
    "marksman"
    # Mermaid: https://github.com/gabeidx/zed-mermaid
    "mermaid"
    # Nix
    "nix"
    # Nushell
    "nu"
    # Python LSP: https://github.com/rgbkrk/python-lsp-zed-extension
    "pylsp"
    # Python Refactoring: https://github.com/rowillia/zed-python-refactoring
    "python-refactoring"
    # Rainbow CSV: https://github.com/weartist/zed-rainbow-csv
    "rainbow-csv"
    "ruff"
    "sagemath"
    # "snippets"
    # SQL: https://github.com/zed-extensions/sql
    "sql"
    # Tmux: https://github.com/dangh/zed-tmux
    "tmux"
    "toml"
    # Typos Language Server: https://github.com/BaptisteRoseau/zed-typos
    "typos"

    "typst"
    "xml"
  ];
}
