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
