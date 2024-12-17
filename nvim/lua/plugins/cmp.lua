-- Configure nvim-cmp plugin for autocompletion
require('cmp').setup {
  config = function()
    -- nvim-cmp setup
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'

    cmp.setup({
      view = {
        entries = "native"  -- Use the native completion entry format
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)  -- Expand luasnip snippets
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),  -- Scroll docs down
        ['<C-f>'] = cmp.mapping.scroll_docs(4),   -- Scroll docs up
        ['<C-Space>'] = cmp.mapping.complete(),    -- Start completion
        ['<CR>'] = cmp.mapping.confirm {         -- Confirm selection with Enter
          behavior = cmp.ConfirmBehavior.Replace,  -- Replace current text
          select = true,                          -- Select the first item
        },
        ['<Tab>'] = cmp.mapping(function(fallback)  -- Cycle through completion items with Tab
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),  -- In insert and select modes
        ['<S-Tab>'] = cmp.mapping(function(fallback) -- Cycle backwards with Shift-Tab
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),  -- In insert and select modes
      },
      sources = {
        { name = 'nvim_lsp' },  -- LSP-based completion
        { name = 'luasnip' },  -- Snippet completion
        { name = "neorg" },    -- Neorg completion
      },
    })
  end
}
