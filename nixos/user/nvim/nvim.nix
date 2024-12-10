{
  config,
  pkgs,
  ...
}: {
  # imports = [
  #   ./nvim-lua-config.nix
  # ];
  programs.nixvim = let
    toLua = str: "lua << EOF \n${str}\nEOF\n";
    toLuaFile = file: "lua << EOF \n${builtins.readFile file}\nEOF\n";
  in {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraLuaConfig = ''
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ' '

      vim.o.clipboard = 'unnamedplus'

      vim.o.number = true

      vim.o.tabstop = 4
      vim.o.shiftwidth = 4

      vim.o.updatetime = 300

      vim.o.termguicolors = true

      vim.o.mouse = 'a'
    '';

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      nvchad
    ];
    extraConfig = "";
  };
}
