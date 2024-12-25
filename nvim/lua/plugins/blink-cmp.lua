-- Filename: ~/dotfiles/nvim/lua/plugins/blink-cmp.lua.lua
--
-- GitHub Repo: https://github.com/saghen/blink.cmp

return {
  "saghen/blink.cmp",
  enabled = true,
  opts = function(_, opts)
    -- Merge custom sources with the existing ones from lazyvim
    -- NOTE: by default lazyvim already includes the lazydev source, so not
    -- adding it here again
    opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
      default = { "lsp", "path", "snippets", "buffer", "copilot", "luasnip", "dadbod" },
      providers = {
        lsp = {
          name = "lsp",
          enabled = true,
          module = "blink.cmp.sources.lsp",
          kind = "LSP",
          -- When linking markdown notes, I would get snippets and text in the
          -- suggestions, I want those to show only if there are no LSP
          -- suggestions
          fallbacks = { "snippets", "luasnip", "buffer" },
          score_offset = 90, -- the higher the number, the higher the priority
        },
        luasnip = {
          name = "luasnip",
          enabled = true,
          module = "blink.cmp.sources.luasnip",
          min_keyword_length = 2,
          fallbacks = { "snippets" },
          score_offset = 85, -- the higher the number, the higher the priority
        },
        path = {
          name = "Path",
          module = "blink.cmp.sources.path",
          score_offset = 3,
          -- When typing a path, I would get snippets and text in the
          -- suggestions, I want those to show only if there are no path
          -- suggestions
          fallbacks = { "snippets", "luasnip", "buffer" },
          opts = {
            trailing_slash = false,
            label_trailing_slash = true,
            get_cwd = function(context)
              return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
            end,
            show_hidden_files_by_default = true,
          },
        },
        buffer = {
          name = "Buffer",
          module = "blink.cmp.sources.buffer",
          min_keyword_length = 2,
        },
        snippets = {
          name = "snippets",
          enabled = true,
          module = "blink.cmp.sources.snippets",
          score_offset = 80, -- the higher the number, the higher the priority
        },
        -- Example on how to configure dadbod found in the main repo
        -- https://github.com/kristijanhusak/vim-dadbod-completion
        -- dadbod = {
        --   name = "Dadbod",
        --   module = "vim_dadbod_completion.blink",
        --   score_offset = 85, -- the higher the number, the higher the priority
        -- },
        -- -- Third class citizen mf always talking shit
        -- copilot = {
        --   name = "copilot",
        --   enabled = true,
        --   module = "blink-cmp-copilot",
        --   kind = "Copilot",
        --   min_keyword_length = 2,
        --   score_offset = -100, -- the higher the number, the higher the priority
        --   async = true,
        -- },
      },
    })

    -- This comes from the luasnip extra, if you don't add it, won't be able to
    -- jump forward or backward in luasnip snippets
    -- https://www.lazyvim.org/extras/coding/luasnip#blinkcmp-optional
    opts.snippets = {
      expand = function(snippet)
        require("luasnip").lsp_expand(snippet)
      end,
      active = function(filter)
        if filter and filter.direction then
          return require("luasnip").jumpable(filter.direction)
        end
        return require("luasnip").in_snippet()
      end,
      jump = function(direction)
        require("luasnip").jump(direction)
      end,
    }

    -- The default preset used by lazyvim accepts completions with enter
    -- I don't like using enter because if on markdown and typing
    -- something, but you want to go to the line below, if you press enter,
    -- the completion will be accepted
    -- https://cmp.saghen.dev/configuration/keymap.html#default
    opts.keymap = {
      preset = "default",
      ["<Tab>"] = { "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },

      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },

      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },

      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
    }

    return opts
  end,
}
-- return {
--   {
--     "saghen/blink.cmp",
--     event = "VeryLazy",
--     -- optional: provides snippets for the snippet source
--     dependencies = {
--       "rafamadriz/friendly-snippets",
--       "hrsh7th/vim-vsnip",
--     },

--     -- use a release tag to download pre-built binaries
--     version = "*",
--     -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
--     -- build = 'cargo build --release',
--     -- If you use nix, you can build from source using latest nightly rust with:
--     -- build = 'nix run .#build-plugin',

--     ---@module 'blink.cmp'
--     ---@type blink.cmp.Config
--     opts = {
--       -- 'default' for mappings similar to built-in completion
--       -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
--       -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
--       -- See the full "keymap" documentation for information on defining your own keymap.
--       keymap = { preset = "default" },

--       appearance = {
--         -- Sets the fallback highlight groups to nvim-cmp's highlight groups
--         -- Useful for when your theme doesn't support blink.cmp
--         -- Will be removed in a future release
--         use_nvim_cmp_as_default = true,
--         -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
--         -- Adjusts spacing to ensure icons are aligned
--         nerd_font_variant = "mono",
--       },

--       -- Default list of enabled providers defined so that you can extend it
--       -- elsewhere in your config, without redefining it, due to `opts_extend`
--       sources = {
--         default = { "lsp", "path", "vsnip", "buffer" }, -- Include vsnip for snippets
--       },
--       snippet = {
--         expand = function(args)
--           require("vsnip").expand_or_jump(args.body)
--         end,
--       },
--       mapping = {
--         ["<C-j>"] = {
--           action = function()
--             if require("vsnip").jumpable(1) then
--               require("vsnip").jump(1)
--             end
--           end,
--           modes = { "i", "s" },
--         },
--         ["<C-k>"] = {
--           action = function()
--             if require("vsnip").expand_or_jumpable() then
--               require("vsnip").expand_or_jump()
--             end
--           end,
--           modes = { "i", "s" },
--         },
--         ["<C-l>"] = {
--           action = function()
--             if require("vsnip").jumpable(-1) then
--               require("vsnip").jump(-1)
--             end
--           end,
--           modes = { "i", "s" },
--         },
--         ["<C-f>"] = {
--           action = function()
--             if require("vsnip").choice_active() then
--               require("vsnip").next()
--             end
--           end,
--           modes = { "i", "s" },
--         },
--         ["<C-b>"] = {
--           action = function()
--             if require("vsnip").choice_active() then
--               require("vsnip").prev()
--             end
--           end,
--           modes = { "i", "s" },
--         },
--       },
--     },
--     opts_extend = { "sources.default" },
--   },
-- }


-- | Keybinding   | Mode       | Description                                      |
-- | :----------- | :--------- | :----------------------------------------------- |
-- | `<C-j>`      | i, s       | Jump forward to the next snippet placeholder     |
-- | `<C-k>`      | i, s       | Expand snippet or jump forward                  |
-- | `<C-l>`      | i, s       | Jump backward to the previous snippet placeholder |
-- | `<C-f>`      | i, s       | Select the next choice in a choice node         |
-- | `<C-b>`      | i, s       | Select the previous choice in a choice node     |
