-- --------------------------------------------------------------------
--  Filename: ~/.config/nvim/lua/plugins/conform.lua
--  LazyVim Docs: https://www.lazyvim.org/extras/coding/luasnip
--  Conform Docs: https://github.com/stevearc/conform.nvim
-- --------------------------------------------------------------------

return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" }, -- Ensure Mason is installed for managing formatters
  lazy = true, -- Lazy-load the plugin to optimize startup time
  cmd = "ConformInfo", -- Load Conform only when `:ConformInfo` is used

  -- Keybindings for manual formatting
  keys = {
    {
      "<leader>cF",
      function()
        -- Manually format injected languages
        require("conform").format({
          formatters = { "injected" },
          timeout_ms = 3000,
        })
      end,
      mode = { "n", "v" }, -- Available in Normal and Visual mode
      desc = "Format Injected Langs",
    },
  },

  -- Register Conform as the primary formatter in LazyVim
  init = function()
    LazyVim.on_very_lazy(function()
      LazyVim.format.register({
        name = "conform.nvim",
        priority = 100, -- Higher priority ensures this formatter runs first
        primary = true, -- Mark Conform as the primary formatter
        format = function(buf)
          require("conform").format({ bufnr = buf }) -- Format the given buffer
        end,
        sources = function(buf)
          local ret = require("conform").list_formatters(buf)
          return vim.tbl_map(function(v)
            return v.name
          end, ret)
        end,
      })
    end)
  end,

  -- Plugin options: Formatters, filetype mappings, and conditions
  opts = {
    -- Default options for formatting
    default_format_opts = {
      timeout_ms = 3000, -- Formatting timeout
      async = false, -- Synchronous formatting (recommended)
      quiet = false, -- Show formatting messages
      lsp_format = "fallback", -- Use LSP formatting if a formatter is not available
    },

    -- Mapping of formatters to specific file types
    formatters_by_ft = {
      fish = { "fish_indent" },
      go = { "goimports", "gofumpt" },
      justfile = { "just" },
      lua = { "stylua" },
      markdown = { "prettier", "markdownlint-cli2", "markdown-toc" },
      ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
      python = { "ruff_format", "ruff_organize_imports" },
      sh = { "shfmt" },
    },

    -- Custom formatter configurations
    formatters = {
      -- Ensure injected languages inside markdown, HTML, etc., are formatted without errors
      injected = {
        options = { ignore_errors = true },
      },

      -- Only format Markdown files with a TOC (Table of Contents) when `<!-- toc -->` is present
      ["markdown-toc"] = {
        condition = function(_, ctx)
          for _, line in
            ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false))
          do
            if line:find("<!%-%- toc %-%->") then
              return true -- Run formatter if TOC marker is found
            end
          end
        end,
      },

      -- Use `markdownlint-cli2` for Markdown formatting, but only if there are existing diagnostics from it
      ["markdownlint-cli2"] = {
        command = "markdownlint-cli2",
        args = {
          "--fix",
          "--config",
          os.getenv("HOME") .. "/.config/.markdownlint.jsonc", -- Config file for markdownlint
          "--",
          "$FILENAME",
        },
        condition = function(_, ctx)
          -- Check if config file exists
          local config_file = os.getenv("HOME")
            .. "/.config/.markdownlint.jsonc"
          if vim.fn.filereadable(config_file) == 0 then
            return false
          end

          -- Ensure markdownlint runs only if it has already detected linting issues
          local diag = vim.tbl_filter(function(d)
            return d.source == "markdownlint"
          end, vim.diagnostic.get(ctx.buf))
          return #diag > 0
        end,
      },
    },
  },
}
