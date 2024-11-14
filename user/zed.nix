{
  config,
  pkgs,
  pkgs-unstable,
  # userSettings,
  ...
}: let
  # Create the Python environment with Python 3.12 and necessary packages
  config = ".config/zed/";
  snippets = "${config}snippets/";
  gitcommit-snip = "gitcommit.json";
  html-snip = "html.json";
  javascript-snip = "javascript.json";
  latex-snip = "latex.json";
  markdown-snip = "markdown.json";
  nix-snip = "nix.json";
  python-snip = "python.json";
  sql-snip = "sql.json";
in {
  home = {
    packages = with pkgs-unstable; [
      zed-editor # Zed IDE
    ];
    file = {
      "${config}settings.json".source = ./.zed/settings.json;
      "${config}keymap.json".source = ./.zed/keymap.json;
      "${snippets}${gitcommit-snip}".source = ./.zed/snippets/${gitcommit-snip};
      "${snippets}${html-snip}".source = ./.zed/snippets/${html-snip};
      "${snippets}${javascript-snip}".source = ./.zed/snippets/${javascript-snip};
      "${snippets}${latex-snip}".source = ./.zed/snippets/${latex-snip};
      "${snippets}${markdown-snip}".source = ./.zed/snippets/${markdown-snip};
      "${snippets}${nix-snip}".source = ./.zed/snippets/${nix-snip};
      "${snippets}${python-snip}".source = ./.zed/snippets/${python-snip};
      "${snippets}${sql-snip}".source = ./.zed/snippets/${sql-snip};
    };
  };
}
