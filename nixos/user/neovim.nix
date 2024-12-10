{
  config,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    extraConfig = "";
  };
}
