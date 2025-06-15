-- -----------------------------------------------------------------------------
--  Filename: ~/.config/nvim/lua/config/keymaps.lua
--  Docs: https://www.lazyvim.org/configuration/general
--  Default: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--  Description: Context-aware keymaps for Neovim and VSCode
-- -----------------------------------------------------------------------------

-- Keymaps are automatically loaded on the VeryLazy event.
-- This file supplements LazyVim defaults with custom mappings.

-- ------------------------------------------------------ --
--                  Safe Mapping Utility                  --
-- ------------------------------------------------------ --
---@desc Wrapper around vim.keymap.set that respects Lazy key handlers.
---      Avoids overwriting user-defined Lazy keys. Use this for all mappings.
---@param mode string|table
---@param lhs string
---@param rhs string|function
---@param opts table|nil
local function safeMap(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- ------------------------------------------------------ --
--                    Helper Functions                    --
-- ------------------------------------------------------ --

---@desc Toggle line wrapping and print the current state
---@return nil
local function toggleWordWrap()
  vim.wo.wrap = not vim.wo.wrap
  print("Word wrap " .. (vim.wo.wrap and "enabled" or "disabled"))
end

---@desc Call a VSCode command using VSCodeCall
---@param command string
---@return nil
local function vscodeCall(command)
  vim.cmd("call VSCodeCall('" .. command .. "')")
end

---@desc Call a VSCode command using VSCodeNotify
---@param command string
---@return nil
local function vscodeNotify(command)
  vim.cmd("call VSCodeNotify('" .. command .. "')")
end

-- ------------------------------------------------------ --
--                 Global Clipboard Maps                  --
-- ------------------------------------------------------ --

-- Global clipboard support for ⌘V across various modes (macOS)
vim.api.nvim_set_keymap(
  "",
  "<D-v>",
  "+p<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "!",
  "<D-v>",
  "<C-R>+",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "t",
  "<D-v>",
  "<C-R>+",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "v",
  "<D-v>",
  "<C-R>+",
  { noremap = true, silent = true }
)

-- ------------------------------------------------------ --
--                     Neovim Keymaps                     --
-- ------------------------------------------------------ --

---@desc Define Neovim-specific custom keymaps
---@return nil
local function defineNeovimKeymaps()
  -- Move current line or block up/down with Alt + Arrow
  safeMap(
    "n",
    "<A-Down>",
    "<cmd>execute 'move .+' . v:count1<cr>==",
    { desc = "Move Down" }
  )
  safeMap(
    "n",
    "<A-Up>",
    "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==",
    { desc = "Move Up" }
  )
  safeMap("i", "<A-Down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
  safeMap("i", "<A-Up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
  safeMap(
    "v",
    "<A-Down>",
    ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv",
    { desc = "Move Down" }
  )
  safeMap(
    "v",
    "<A-Up>",
    ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv",
    { desc = "Move Up" }
  )

  -- Word movement in insert mode using Option+Arrow (macOS)
  vim.keymap.set("i", "<A-Left>", "<C-Left>", { desc = "Move word left" })
  vim.keymap.set("i", "<A-Right>", "<C-Right>", { desc = "Move word right" })

  -- Search and replace word under cursor
  safeMap("n", "<leader>sr", function()
    local word = vim.fn.expand("<cword>")
    local new = vim.fn.input("Replace '" .. word .. "' with: ")
    if new ~= "" then
      vim.cmd("%s/\\<" .. word .. "\\>/" .. new .. "/gI")
    end
  end, { desc = "Search and replace word under cursor" })

  -- Toggle options
  safeMap("n", "<leader>ct", toggleWordWrap, { desc = "Toggle word wrap" })
  safeMap(
    "n",
    "<leader>bc",
    "<cmd>BufferLinePick<CR>",
    { desc = "Pick buffer" }
  )
end

-- ------------------------------------------------------ --
--                    Neovide Keymaps                     --
-- ------------------------------------------------------ --

if vim.g.neovide then
  vim.keymap.set("n", "<D-s>", ":w<CR>", { desc = "Save file" })
  vim.keymap.set("v", "<D-c>", '"+y', { desc = "Copy to clipboard" })
  vim.keymap.set("n", "<D-v>", '"+P', { desc = "Paste (normal mode)" })
  vim.keymap.set("v", "<D-v>", '"+P', { desc = "Paste (visual mode)" })
  vim.keymap.set("c", "<D-v>", "<C-R>+", { desc = "Paste (command mode)" })
  vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli', { desc = "Paste (insert mode)" })
end

-- ------------------------------------------------------ --
--                     VSCode Keymaps                     --
-- ------------------------------------------------------ --

---@desc Define VSCode-specific keymaps using VSCodeNotify and VSCodeCall
---@return nil
local function defineVscodeKeymaps()
  -- Terminal controls
  safeMap("n", "<C-/>", function()
    vscodeCall("workbench.action.terminal.focus")
  end)
  safeMap("t", "<C-h>", function()
    vscodeCall("workbench.action.terminal.focusPreviousPane")
  end)
  safeMap("t", "<C-l>", function()
    vscodeCall("workbench.action.terminal.focusNextPane")
  end)

  -- File explorer and quick open
  safeMap("n", "<leader>fe", function()
    vscodeNotify("workbench.files.action.focusFilesExplorer")
  end)
  safeMap("n", "<leader>ff", function()
    vscodeNotify("workbench.action.quickOpen")
  end)
  safeMap("n", "<leader>gg", function()
    vscodeNotify("workbench.view.scm")
  end)

  -- Symbol and editor navigation
  safeMap("n", "<leader>cs", function()
    vscodeCall("workbench.action.gotoSymbol")
  end)
  safeMap("n", "<S-l>", function()
    vscodeNotify("workbench.action.nextEditor")
  end)
  safeMap("n", "<S-h>", function()
    vscodeNotify("workbench.action.previousEditor")
  end)

  -- LSP and diagnostics
  safeMap("n", "gr", function()
    vscodeNotify("editor.action.referenceSearch.trigger")
  end)
  safeMap("n", "<leader>cr", function()
    vscodeNotify("editor.action.rename")
  end)
  safeMap("n", "<leader>ca", function()
    vscodeNotify("editor.action.quickFix")
  end)
  safeMap("n", "<leader>cA", function()
    vscodeNotify("editor.action.sourceAction")
  end)
  safeMap("n", "<leader>sd", function()
    vscodeNotify("workbench.action.problems.focus")
  end)
  safeMap("n", "<leader>cp", function()
    vscodeNotify("workbench.panel.markers.view.focus")
  end)
  safeMap("n", "<leader>cd", function()
    vscodeNotify("editor.action.marker.next")
  end)

  -- Bookmark management
  safeMap("n", "<leader>sml", function()
    vscodeNotify("bookmarks.list")
  end)
  safeMap("n", "<leader>smL", function()
    vscodeNotify("bookmarks.listFromAllFiles")
  end)
  safeMap("n", "<leader>smm", function()
    vscodeNotify("bookmarks.toggle")
  end)
  safeMap("n", "<leader>smd", function()
    vscodeNotify("bookmarks.clear")
  end)
  safeMap("n", "<leader>smr", function()
    vscodeNotify("bookmarks.clearFromAllFiles")
  end)

  -- Clipboard and undo/redo
  safeMap("v", "<C-c>", function()
    vscodeNotify("editor.action.clipboardCopyAction")
    print("📎 Copied to clipboard!")
  end)
  safeMap("n", "u", function()
    vscodeNotify("undo")
  end)
  safeMap("n", "<C-r>", function()
    vscodeNotify("redo")
  end)
end

-- ------------------------------------------------------ --
--                    Keymap Dispatcher                   --
-- ------------------------------------------------------ --

---@desc Load keymaps depending on Neovim host (VSCode or terminal)
if vim.g.vscode then
  print("⚡ Connected to VSCode-Neovim")
  defineVscodeKeymaps()
else
  defineNeovimKeymaps()
end
