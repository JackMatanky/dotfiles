{
  config,
  pkgs,
  pkgs-unstable,
  # userSettings,
  ...
}: let
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
      "${config}settings.json".source = ../../zed/settings.json;
      "${config}keymap.json".source = ../../zed/keymap.json;
      "${snippets}".source = ../../zed/snippets;
    };
  };
}
