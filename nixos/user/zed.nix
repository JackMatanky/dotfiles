{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
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
      zed-editor
      # inputs.simple-completion-language-server
    ];
    file = {
      "${configDir}settings.json".source = "${zedDir}/settings.json";
      "${configDir}keymap.json".source = "${zedDir}/keymap.json";
      "${snippetsDir}".source = "${zedDir}/snippets";
    };
  };
}
