{
  config,
  pkgs,
  inputs,
  ...
}: let
  # zedDir = builtins.path {
  #   path = ../../../zed;
  #   name = "zed";
  # };
  configDir = ".config/zed/";
in {
  imports = [
    ./zed-extensions.nix
    ./zed-keymap.nix
    ./zed-settings.nix
  ];

  home = {
    file = {
      "${configDir}snippets/".source = ./snippets;
    };
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
