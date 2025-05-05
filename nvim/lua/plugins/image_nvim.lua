-- --------------------------------------------------------------------
--  Filename: ~/dotfiles/nvim/lua/plugins/image_nvim.lua
--  Image.nvim Docs: https://github.com/3rd/image.nvim
--  Description: Image support for Neovim using Kitty's Graphic Protocol
-- --------------------------------------------------------------------

-- NOTE: This plugin does not work in GUI clients like Neovide,
-- so we explicitly disable it using `enabled = not vim.g.neovide`.

return {
  {
    -- luarocks.nvim is a Neovim plugin designed to streamline the installation
    -- of luarocks packages directly within Neovim. It simplifies the process
    -- of managing Lua dependencies, ensuring a hassle-free experience for
    -- Neovim users.
    -- https://github.com/vhyrro/luarocks.nvim
    "vhyrro/luarocks.nvim",
    priority = 1001, -- this plugin needs to run before anything else
    enabled = not vim.g.neovide,
    opts = {
      hererocks = true,
      rocks = { "magick" },
    },
  },
  {
    "3rd/image.nvim",
    enabled = not vim.g.neovide, -- ❌ Disabled when using Neovide (GUI)
    vscode = false,
    dependencies = { "luarocks.nvim" },

    config = function()
      require("image").setup({
        backend = "kitty", -- Uses Kitty Graphics Protocol
        kitty_method = "normal",

        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            -- Set to false to not render images from a URL
            download_remote_images = true,
            -- Change to render images only at the cursor's location
            -- Helps with performance on large files
            only_render_image_at_cursor = true,
            -- markdown extensions (ie. quarto) can go here
            filetypes = { "markdown", "vimwiki", "html" },
          },

          neorg = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = false,
            filetypes = { "norg" },
          },

          -- Disabled by default
          -- Detect and render images referenced in HTML files
          -- Make sure you have an HTML Treesitter parser installed
          html = {
            enabled = true,
            only_render_image_at_cursor = true,
            -- Enabling "markdown" below allows you to view HTML images in .md files
            -- https://github.com/3rd/image.nvim/issues/234
            filetypes = { "html", "xhtml", "htm", "markdown" },
          },

          -- Disabled by default
          -- Detect and render images referenced in CSS files
          -- Requires a CSS Treesitter parser
          css = {
            enabled = true,
          },
        },

        max_width = nil,
        max_height = nil,
        max_width_window_percentage = nil,

        -- You can set this to reduce image size in the buffer
        -- Default = 50; smaller = smaller images
        max_height_window_percentage = 40,

        -- Toggles images when windows are overlapped
        window_overlap_clear_enabled = false,
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },

        -- Auto show/hide images when the editor gains/loses focus
        editor_only_render_when_focused = true,

        -- Auto show/hide images in the correct tmux window
        -- Requires `set -g visual-activity off` in tmux.conf
        tmux_show_only_in_active_window = true,

        -- Render image files directly when opened
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
      })
    end,
  },
}
