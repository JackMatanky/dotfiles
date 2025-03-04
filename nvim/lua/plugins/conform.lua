
-- --------------------------------------------------------------------
--  Filename: ~/dotfiles/nvim/lua/plugins/conform.lua
--  LazyVim Docs: https://www.lazyvim.org/extras/coding/luasnip
--  Conform Docs: https://github.com/stevearc/conform.nvim
-- --------------------------------------------------------------------

return {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
        formatters = {
            ["markdown-toc"] = {
                condition = function(_, ctx)
                for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
                    if line:find("<!%-%- toc %-%->") then
                        return true
                    end
                end
                end,
            },
            ["markdownlint-cli2"] = {
                command = "markdownlint-cli2",
                args = { "--fix", "--config", "/Users/jack/.config/formatters/.markdownlint.jsonc", "--", "$FILENAME" },
                condition = function(_, ctx)
                -- Ensure markdownlint runs only if there are diagnostics from it
                local diag = vim.tbl_filter(function(d)
                    return d.source == "markdownlint"
                    end, vim.diagnostic.get(ctx.buf))
                return #diag > 0
                end,
            },
        },
        formatters_by_ft = {
            ["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
            ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
        },
    },
}
