-- ----------------------------------------------------------------------------
--  Filename: config/ui/neovide.lua
--  Description: GUI-specific Neovide configuration and keymaps
--  Source: https://github.com/cStralpt/lazycodium-starter-template/blob/main/init.lua
-- ----------------------------------------------------------------------------

-- Neovide transparency (0 = opaque, 1 = fully transparent)
vim.g.neovide_opacity = 0.9
-- For Catppuccin Macchiato
vim.g.neovide_background_color = "#24273a"

-- System clipboard paste: Ctrl+Shift+V in insert and terminal modes
vim.keymap.set("i", "<C-S-v>", "<C-r>+")
vim.keymap.set(
  "t",
  "<C-S-v>",
  [[<C-\><C-n>"+pi]],
  { noremap = true, silent = true }
)

-- Frame and rendering refresh rates
vim.g.neovide_refresh_rate = 100
vim.g.neovide_refresh_rate_idle = 5

-- Cursor animations and visual effects
vim.g.neovide_cursor_animate_in_insert_mode = true
vim.g.neovide_cursor_animate_command_line = true
vim.g.neovide_cursor_vfx_mode = ""

-- Blur effects for floating windows
vim.g.neovide_window_blurred = true
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0

-- GUI font (adjust to your installed fonts and preference)
vim.opt.guifont = "FiraCode Nerd Font:h15"
