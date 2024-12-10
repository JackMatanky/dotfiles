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
    # ./alacritty.nix
    ./espanso.nix
    ./firefox.nix
    ./fonts.nix
    ./git.nix
    ./gnome.nix
    ./python.nix
    ./pkm.nix
    ./sh.nix
    ./ssh.nix
    ./zed/zed.nix
  ];
}
