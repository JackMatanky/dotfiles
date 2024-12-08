{
  config,
  pkgs,
  inputs,
  ...
}: let
  zedDir = builtins.path {
    path = ../../../zed;
    name = "zed";
  };
  configDir = ".config/zed/";
  # Function to strip comments from JSON files
  # stripComments = file: let
  #   fileContent = builtins.readFile file;
  #   # Remove full-line comments (lines starting with optional spaces followed by //)
  #   noFullLineComments = builtins.replaceStrings ["^\\s*//.*"] [""] fileContent;
  #   # Remove trailing inline comments (// at the end of a line)
  #   noTrailingComments = builtins.replaceStrings ["//.*$"] [""] noFullLineComments;
  # in
  #   noTrailingComments;
  # userSettingsJson = builtins.fromJSON (stripComments "${zedDir}/settings.json");
  # userKeymapJson = builtins.fromJSON (stripComments "${zedDir}/keymap.json");
in {
  imports = [
    ./zed-extensions.nix
    ./zed-keymap.nix
    ./zed-settings.nix
  ];

  home = {
    file = {
      # "${configDir}settings.json".source = "${zedDir}/settings.json";
      # "${configDir}keymap.json".source = "${zedDir}/keymap.json";
      "${configDir}snippets/".source = "${zedDir}/snippets";
    };
    # packages = with pkgs-unstable; [
    #   zed-editor
    # ];
    #   ++ [
    #     inputs.simple-completion-language-server.defaultPackage.${systemSettings.system}
    #   ];
    # };
  };
  programs.zed-editor = {
    enable = true;
    # extraPackages = with pkgs; [
    #   nixd
    # ];
  };

  # simple-completion-language-server = pkgs.callPackage inputs.simple-completion-language-server {};
  # };
}
