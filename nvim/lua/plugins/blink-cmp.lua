-- lua/plugins/lsp/vsnip-integ.lua
return {
  {
    "saghen/blink.cmp",
    event = "VeryLazy",
    -- optional: provides snippets for the snippet source
    dependencies = {
      "rafamadriz/friendly-snippets",
      "hrsh7th/vim-vsnip",
    },

    -- use a release tag to download pre-built binaries
    version = "*",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = { preset = "default" },

      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { "lsp", "path", "vsnip", "buffer" }, -- Include vsnip for snippets
      },
      snippet = {
        expand = function(args)
          require("vsnip").expand_or_jump(args.body)
        end,
      },
      mapping = {
        ["<C-j>"] = {
          action = function()
            if require("vsnip").jumpable(1) then
              require("vsnip").jump(1)
            end
          end,
          modes = { "i", "s" },
        },
        ["<C-k>"] = {
          action = function()
            if require("vsnip").expand_or_jumpable() then
              require("vsnip").expand_or_jump()
            end
          end,
          modes = { "i", "s" },
        },
        ["<C-l>"] = {
          action = function()
            if require("vsnip").jumpable(-1) then
              require("vsnip").jump(-1)
            end
          end,
          modes = { "i", "s" },
        },
        ["<C-f>"] = {
          action = function()
            if require("vsnip").choice_active() then
              require("vsnip").next()
            end
          end,
          modes = { "i", "s" },
        },
        ["<C-b>"] = {
          action = function()
            if require("vsnip").choice_active() then
              require("vsnip").prev()
            end
          end,
          modes = { "i", "s" },
        },
      },
    },
    opts_extend = { "sources.default" },
  },
}


-- | Keybinding   | Mode       | Description                                      |
-- | :----------- | :--------- | :----------------------------------------------- |
-- | `<C-j>`      | i, s       | Jump forward to the next snippet placeholder     |
-- | `<C-k>`      | i, s       | Expand snippet or jump forward                  |
-- | `<C-l>`      | i, s       | Jump backward to the previous snippet placeholder |
-- | `<C-f>`      | i, s       | Select the next choice in a choice node         |
-- | `<C-b>`      | i, s       | Select the previous choice in a choice node     |
