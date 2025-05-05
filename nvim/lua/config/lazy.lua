-- --------------------------------------------------------------------
--  Filename: ~/dotfiles/nvim/lua/config/lazy.lua
--  Docs: https://www.lazyvim.org/configuration/lazy.nvim
-- --------------------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- Add LazyVim and import core plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- Import/override with custom plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins are lazy-loaded
    -- while custom plugins are loaded during startup.
    -- If you know what you're doing, you can set this to `true` to
    -- have all your custom plugins lazy-loaded by default.
    lazy = false,

    -- It's recommended to leave version=false for now,
    -- since many plugins that support versioning have outdated
    -- releases, which may break your Neovim install.
    version = false, -- always use the latest git commit

    -- Use only for installing the latest version of plugins
    -- that support semantic versioning (semver) well
    -- version = "*",
  },

  -- Automatically check for plugin updates periodically
  checker = {
    enabled = true,
    notify = false, -- notify on update
  },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        -- "tutor",
        "zipPlugin",
      },
    },
  },
})
