{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # ... your other imports
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.neovim = {
    enable = true;

    # Package manager (choose one)
    plugins = with pkgs.vimPlugins; [lazy.nvim];

    # Essential plugins (customize to your needs)
    extraPlugins = with pkgs.vimPlugins; [
      telescope.nvim
      treesitter
      nvim-treesitter-textobjects
      comment.nvim
      lualine.nvim
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-nvim-lsp
      cmp-nvim-lua
      lspkind-nvim
      null-ls
      mason.nvim
      mason-lspconfig.nvim
    ];

    # Configure options
    options = {
      relativenumber = true;
      number = true;
      tabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      smartindent = true;
      ignorecase = true;
      smartcase = true;
      incsearch = true;
      hlsearch = false;
      termguicolors = true;
      scrolloff = 8;
      sidescrolloff = 8;
    };

    # Keybindings (examples)
    maps.normal = {
      "<leader>pv" = ":PackerSync<CR>"; # If using packer.nvim
      "<leader>ps" = ":PackerStatus<CR>"; # If using packer.nvim
      "<C-s>" = ":w<CR>";
      "<leader>c" = ":CommentToggle<CR>"; # For comment.nvim
      "<leader>ff" = ":Telescope find_files<CR>";
      "<leader>fg" = ":Telescope live_grep<CR>";
      "<leader>fb" = ":Telescope buffers<CR>";
      "<leader>fh" = ":Telescope help_tags<CR>";
    };

    # Colorscheme
    # colorscheme = {
    #   base16 = {
    #     enable = true;
    #     colorscheme = "dracula";
    #   };
    # };

    # LSP Configuration (using mason.nvim)
    lsp = {
      servers = ["sumneko_lua" "pyright"]; # Add your desired LSP servers
      automaticConfiguration = {
        enable = true;
      };
    };
  };
}
