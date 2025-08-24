-- ----------------------------------------------------------------------------
--  Filename: ~/.config/nvim/init.lua
--  Description: Main Neovim entry point with environment-specific modules
--  Source: https://github.com/cStralpt/lazycodium-starter-template/
-- ----------------------------------------------------------------------------

require("config.lazy")

-- ---------------------------------------------------------- --
--        Load UI-specific modules for VSCode or Neovide      --
-- ---------------------------------------------------------- --
if vim.g.vscode then
  require("config.ui.vscode")
elseif vim.g.neovide then
  require("config.ui.neovide")
end

-- ---------------------------------------------------------- --
--     Regular Neovim (non-VSCode, non-Neovide) settings      --
-- ---------------------------------------------------------- --

-- Transparency settings for popup menu and floating windows
-- ⚠️ If you don’t like the effect, comment out these lines:
-- vim.o.winblend = 20
-- vim.o.pumblend = 20

-- Fallback transparency for terminal (non-VSCode, non-Neovide)
-- local transparencyGroups = {
--   Normal = { bg = "NONE", ctermbg = "NONE" },
--   NormalNC = { bg = "NONE", ctermbg = "NONE" },
--   NeoTreeNormal = { bg = "NONE", ctermbg = "NONE" },
--   NeoTreeNormalNC = { bg = "NONE", ctermbg = "NONE" },
-- }

-- for group, hl in pairs(transparencyGroups) do
--   vim.cmd(
--     string.format("highlight %s guibg=%s ctermbg=%s", group, hl.bg, hl.ctermbg)
--   )
-- end
