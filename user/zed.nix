{
  config,
  pkgs,
  pkgs-unstable,
  # userSettings,
  ...
}: let
  zedDir = builtins.path {
    path = ../../zed;
    name = "zed";
  };
  configDir = ".config/zed/";
  snippetsDir = "${configDir}snippets/";
  # gitcommit-snip = "gitcommit.json";
  # html-snip = "html.json";
  # javascript-snip = "javascript.json";
  # latex-snip = "latex.json";
  # markdown-snip = "markdown.json";
  # nix-snip = "nix.json";
  # python-snip = "python.json";
  # sql-snip = "sql.json";
in {
  home = {
    packages = with pkgs-unstable; [
      zed-editor # Zed IDE
    ];
    file = {
      "${configDir}settings.json".source = "${zedDir}/settings.json";
      "${configDir}keymap.json".source = "${zedDir}/keymap.json";
      "${snippetsDir}".source = "${zedDir}/snippets";
    };
  };
}
