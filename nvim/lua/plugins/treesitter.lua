return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        ensure_installed = {
            "bash", "c", "cpp", "css", "go", "html", "java", "javascript", "jsdoc", "json",
            "lua", "luadoc", "markdown", "markdown_inline", "php", "python", "rust", "scss",
            "sql", "toml", "tsx", "typescript", "vim", "xml", "yaml"
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  }
}

-- return require("lazy").setup({
--   {
--     "nvim-treesitter/nvim-treesitter",
--     build = ":TSUpdate",
--     -- Keep your other settings here, like keys, opts.ensure_installed, etc.
--     opts = {
--       ensure_installed = {
--         "bash", "c", "diff", "html", "javascript", "jsdoc", "json", "jsonc",
--         "lua", "luadoc", "luap", "markdown", "markdown_inline", "printf",
--         "python", "query", "regex", "toml", "tsx", "typescript", "vim",
--         "vimdoc", "xml", "yaml"
--       },
--       highlight = { enable = true },
--       indent = { enable = true },
--       incremental_selection = {
--         enable = true,
--         keymaps = {
--           init_selection = "<C-space>",
--           node_incremental = "<C-space>",
--           scope_incremental = false,
--           node_decremental = "<bs>",
--         },
--       },
--       textobjects = {
--         move = {
--           enable = true,
--           goto_next_start = {
--             ["]f"] = "@function.outer",
--             ["]c"] = "@class.outer",
--             ["]a"] = "@parameter.inner"
--           },
--           goto_next_end = {
--             ["]F"] = "@function.outer",
--             ["]C"] = "@class.outer",
--             ["]A"] = "@parameter.inner"
--           },
--           goto_previous_start = {
--             ["[f"] = "@function.outer",
--             ["[c"] = "@class.outer",
--             ["[a"] = "@parameter.inner"
--           },
--           goto_previous_end = {
--             ["[F"] = "@function.outer",
--             ["[C"] = "@class.outer",
--             ["[A"] = "@parameter.inner"
--           },
--         },
--       },
--     },
--     -- The config function is placed near the end
--     config = function()
--       local configs = require("nvim-treesitter.configs")
--       configs.setup({
--         -- You can keep your ensure_installed list here if you prefer
--         -- Or remove it if it's already in `opts` as shown above
--         -- ensure_installed = { ... },
--         highlight = { enable = true },
--         indent = { enable = true },
--         -- ... your other tree-sitter options ...
--       })
--     end,
--   }
-- })
