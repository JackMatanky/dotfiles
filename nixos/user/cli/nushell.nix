{
  config,
  pkgs,
  lib,
  ...
}: let
  myAliases = import ./aliases.nix;
  starshipDir = builtins.path {
    path = ../../../starship;
    name = "starship";
  };
in {
  programs.nushell = {
    enable = true;
    shellAliases = myAliases;

    # Set environment variables
    environmentVariables = {
      EDITOR = "zed"; # Set the default editor to Zed
      VISUAL = "zed";
      STARSHIP_CONFIG = "${starshipDir}/starship.toml"; # Path to the Starship configuration file
    };
  };
}
