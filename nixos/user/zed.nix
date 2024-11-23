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
    file = {
      "${configDir}settings.json".source = "${zedDir}/settings.json";
      "${configDir}keymap.json".source = "${zedDir}/keymap.json";
      "${snippetsDir}".source = "${zedDir}/snippets";
    };
    packages = with pkgs-unstable; [
      zed-editor
    ];
    # ++ [
    #   (pkgs.callPackage inputs.simple-completion-language-server {})
    # ];
  };
  programs = {
    simple-completion-language-server = pkgs.callPackage inputs.simple-completion-language-server {};
  };
}
