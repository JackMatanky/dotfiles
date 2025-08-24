-- --------------------------------------------------------------------
--  Filename: ~/.config/nvim/lua/plugins/render_markdown.lua
--  LazyVim Docs: https://www.lazyvim.org/extras/lang/markdown#render-markdownnvim
--  Render Markdown Docs: https://github.com/MeanderingProgrammer/render-markdown.nvim
-- --------------------------------------------------------------------

return {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = true,
    opts = {
        heading = {
            sign = false, -- Disable signs in the gutter
            icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
        },
        bullet = {
            enabled = true,
        },
        checkbox = {
            enabled = true, -- Enable checkbox state rendering
            position = "inline", -- Checkbox icon replaces text inline
            unchecked = {
                icon = "   󰄱 ", -- Icon for unchecked checkboxes
                highlight = "RenderMarkdownUnchecked", -- Highlight for unchecked checkboxes
                scope_highlight = nil,
            },
            checked = {
                icon = "   󰱒 ", -- Icon for checked checkboxes
                highlight = "RenderMarkdownChecked", -- Highlight for checked checkboxes
                scope_highlight = nil,
            },
        },
        code = {
            sign = false, -- Disable sign column for code blocks
            width = "block", -- Full-width code block
            right_pad = 1, -- Padding for right-aligned code blocks
        },
        html = {
            enabled = true, -- Enable HTML rendering
            comment = {
                conceal = false, -- Show HTML comments instead of concealing them
            },
        },
        latex = {
            enabled = true, -- Enable LaTeX rendering
            render_modes = false, -- Disable different render modes (use default)
            converter = "latex2text", -- Use latex2text for rendering
            highlight = "RenderMarkdownMath", -- Set syntax highlighting for math
            position = "above", -- Render math above its original position
            top_pad = 1, -- No extra padding above equations
            bottom_pad = 1, -- No extra padding below equations
        },
    },
    ft = { "markdown", "norg", "rmd", "org", "codecompanion" }, -- Supported file types
    config = function(_, opts)
    require("render-markdown").setup(opts) -- Apply the configuration
    Snacks.toggle({
        name = "Render Markdown",
        get = function()
        return require("render-markdown.state").enabled
        end,
        set = function(enabled)
        local m = require("render-markdown")
        if enabled then
            m.enable() -- Enable Markdown rendering
            else
            m.disable() -- Disable Markdown rendering
        end
        end,
    }):map("<leader>um") -- Toggle rendering with <leader>um
    end,
}
