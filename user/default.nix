{
  config,
  pkgs,
  # lib,
  # inputs,
  # systemSettings,
  # userSettings,
  ...
}: {
  imports = [
    ./alacritty.nix
    ./git.nix
    ./oh-my-posh.nix
    ./python.nix
    ./sh.nix
    ./ssh.nix
    ./zed.nix
  ];
}
