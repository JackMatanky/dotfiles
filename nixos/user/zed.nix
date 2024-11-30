{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  systemSettings,
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
    file = {
      "${configDir}settings.json".source = "${zedDir}/settings.json";
      "${configDir}keymap.json".source = "${zedDir}/keymap.json";
      "${snippetsDir}".source = "${zedDir}/snippets";
    };
    packages =
      (with pkgs-unstable; [
        zed-editor
      ])
      ++ [
        inputs.simple-completion-language-server.defaultPackage.${systemSettings.system}
      ];
  };
  # programs = {
  #   simple-completion-language-server = pkgs.callPackage inputs.simple-completion-language-server {};
  # };
}
