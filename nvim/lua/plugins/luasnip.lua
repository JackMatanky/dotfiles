-- --------------------------------------------------------------------
--  Filename: ~/dotfiles/nvim/lua/plugins/luasnip.lua
--  LazyVim Docs: https://www.lazyvim.org/extras/coding/luasnip
--  LuaSnip Docs: https://github.com/L3MON4D3/LuaSnip
-- --------------------------------------------------------------------

-- Tip:
-- If you're a dotfiles scavenger, definitely watch this video (you're welcome)
-- https://youtu.be/FmHhonPjvvA?si=8NrcRWu4GGdmTzee

return {
  "L3MON4D3/LuaSnip", -- Main snippet engine
  lazy = false, -- Load only when needed (LazyVim optimization)

  -- Build LuaSnip with optional jsregexp support (not required but useful)
  build = (not LazyVim.is_win())
      and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
    or nil,

  dependencies = {
    {
      "rafamadriz/friendly-snippets", -- Predefined VSCode-style snippets
      config = function()
        local luasnip = require("luasnip")
        if luasnip and luasnip.loaders and luasnip.loaders.from_vscode then
          -- Load default VSCode-style snippets from friendly-snippets
          luasnip.loaders.from_vscode.lazy_load()
          -- Load user-defined snippets from ~/.config/nvim/snippets/
          luasnip.loaders.from_vscode.lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
        else
          vim.notify("LuaSnip loaders are not available", vim.log.levels.WARN)
        end
      end,
    },
  },

  -- LuaSnip configuration
  opts = function()
    local luasnip = require("luasnip")

    return {
      history = true, -- Enable snippet history (allows cycling through previous expansions)
      delete_check_events = "TextChanged", -- Auto-delete snippet when text is modified

      -- Custom snippet navigation (integrates with LazyVim's completion)
      setup = function()
        -- Move forward in a snippet if possible (e.g., pressing <Tab>)
        LazyVim.cmp.actions.snippet_forward = function()
          if luasnip.jumpable(1) then
            vim.schedule(function() -- Schedule to avoid UI blocking
              luasnip.jump(1)
            end)
            return true -- Indicate that the action was handled
          end
        end

        -- Stop snippet mode (unlink snippet) when needed
        LazyVim.cmp.actions.snippet_stop = function()
          if luasnip.expand_or_jumpable() then -- Check if inside an active snippet
            luasnip.unlink_current() -- Exit snippet mode
            return true
          end
        end
      end,
    }
  end,
}
