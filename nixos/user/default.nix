{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./cli/cli.nix
    ./espanso.nix
    ./firefox.nix
    ./fonts.nix
    ./git.nix
    ./gnome.nix
    ./nvim/nvim.nix
    ./python.nix
    ./pkm.nix
    ./ssh.nix
    ./zed/zed.nix
  ];
}
