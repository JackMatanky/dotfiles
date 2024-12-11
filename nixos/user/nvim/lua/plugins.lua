return require('lazy').setup({
  -- Git repos
  { 'nvim-treesitter/nvim-treesitter' },
  { 'kyazdani42/nvim-web-devicons' }, -- Optional, for file icons
  { 'nvim-telescope/telescope.nvim', tag = '0.1.1' },
  -- ... add your other plugins from extraPlugins
}, {})
