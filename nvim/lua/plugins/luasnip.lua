-- --------------------------------------------------------------------
--  Filename: ~/dotfiles/nvim/lua/plugins/rainbow_csv.lua
--  LazyVim Docs: https://www.lazyvim.org/extras/coding/luasnip
--  LuaSnip Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- --------------------------------------------------------------------

return {
  {
    "L3MON4D3/LuaSnip",
    -- keep LazyVim defaults, but add our Lua loader:
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },
    opts = {
      history             = true,
      delete_check_events = "TextChanged",
      -- you can enable autosnippets if desired:
      enable_autosnippets = true,
    },
    config = function(_, opts)
      local ls = require("luasnip")
      ls.setup(opts)
      -- load your Lua-style snippets folder:
      require("luasnip.loaders.from_lua").lazy_load({
        paths = { vim.fn.stdpath("config") .. "/snippets" },
      })
      -- still load VSCode snippets too:
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
}
