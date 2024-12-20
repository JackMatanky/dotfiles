{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./cli/cli.nix
    ./espanso/espanso.nix
    ./nvim/nvim.nix
    ./zed/zed.nix
    ./firefox.nix
    ./fonts.nix
    ./git.nix
    ./gnome.nix
    ./python.nix
    ./pkm.nix
    ./ssh.nix
  ];
}
