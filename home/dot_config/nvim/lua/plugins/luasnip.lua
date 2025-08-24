-- --------------------------------------------------------------------
--  Filename: ~/.config/nvim/lua/plugins/luasnip.lua
--  LazyVim Docs: https://www.lazyvim.org/extras/coding/luasnip
--  LuaSnip Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- --------------------------------------------------------------------

return {
  {
    "L3MON4D3/LuaSnip",
    -- The `init` function is used to load custom snippets without overriding
    -- the default `config` function from LazyVim. This ensures that LuaSnip
    -- is correctly integrated with the configured completion engine (e.g., nvim-cmp or blink.cmp).
    init = function()
      require("luasnip.loaders.from_lua").lazy_load({
        paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
      })
    end,
    -- Add any custom `opts` here to override the defaults.
    -- For example, to enable autosnippets:
    opts = {
      enable_autosnippets = true,
      -- Additional options can also be kept here
      history = true,
      update_events = "TextChanged,TextChangedI",
    },
  },
}
