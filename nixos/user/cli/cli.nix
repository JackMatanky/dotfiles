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
  imports = [
    ./alacritty.nix
    ./bash.nix
    ./nushell.nix
    ./zsh.nix
  ];
  home = {
    file = {
      # ".bashrc".source = "${cliDir}/.bashrc";
      # ".zshrc".source = "${cliDir}/.zshrc";
      # ".config/nushell".source = "${cliDir}/nushell";
      # ".config/alacritty/alacritty.toml".source = "${alacrittyDir}/alacritty.toml";
      ".config/starship/starship.toml".source = "${starshipDir}/starship.toml";
    };
  };
  programs = {
    tmux = {
      enable = true;
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };

    carapace = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };

    zoxide = {
      enable = true;
    };
  };
}
