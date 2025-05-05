-- -----------------------------------------------------------------------------
--  Filename: ~/.config/nvim/lua/config/keymaps.lua
--  Docs: https://www.lazyvim.org/configuration/general
--  Description: Context-aware keymaps for Neovim and VSCode
--  Default: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- -----------------------------------------------------------------------------

-- Keymaps are automatically loaded on the VeryLazy event.
-- This file supplements LazyVim defaults with custom mappings.

-- ------------------------------------------------------ --
--                  Safe Mapping Utility                  --
-- ------------------------------------------------------ --
-- Wrapper around vim.keymap.set that respects Lazy.nvim key handlers.
-- Avoids overwriting user-defined Lazy keys. Use this for all mappings.
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
-- Toggle line wrapping and print result
local function toggleWordWrap()
  vim.wo.wrap = not vim.wo.wrap
  print("Word wrap " .. (vim.wo.wrap and "enabled" or "disabled"))
end

-- Temporarily enable clipboard, yank visual selection, then disable
local function copyToClipboard()
  vim.cmd("set clipboard+=unnamedplus")
  vim.cmd("norm! y")
  vim.cmd("set clipboard-=unnamedplus")
  print("Copied to clipboard!")
end

-- Helper to invoke VSCode commands using VSCodeCall
local function vscodeCall(command)
  vim.cmd("call VSCodeCall('" .. command .. "')")
end

-- Helper to invoke VSCode commands using VSCodeNotify
local function vscodeNotify(command)
  vim.cmd("call VSCodeNotify('" .. command .. "')")
end

-- ------------------------------------------------------ --
--                     Neovim Keymaps                     --
-- ------------------------------------------------------ --
local function defineNeovimKeymaps()
  -- Move current line or block up/down
  safeMap("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
  safeMap("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
  safeMap("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
  safeMap("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

  -- Arrow-like cursor movement in insert mode
  safeMap("i", "<C-h>", "<Left>", { desc = "Move left" })
  safeMap("i", "<C-l>", "<Right>", { desc = "Move right" })
  safeMap("i", "<C-j>", "<Down>", { desc = "Move down" })
  safeMap("i", "<C-k>", "<Up>", { desc = "Move up" })

  -- Search and replace word under cursor
  safeMap("n", "<leader>sr", function()
    local word = vim.fn.expand("<cword>")
    local new = vim.fn.input("Replace '" .. word .. "' with: ")
    if new ~= "" then
      vim.cmd("%s/\\<" .. word .. "\\>/" .. new .. "/gI")
    end
  end, { desc = "Search and replace word under cursor" })

  -- Clear search highlight with Esc
  safeMap("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear search highlight" })

  -- Window navigation shortcuts
  safeMap("n", "<C-h>", "<C-w>h")
  safeMap("n", "<C-j>", "<C-w>j")
  safeMap("n", "<C-k>", "<C-w>k")
  safeMap("n", "<C-l>", "<C-w>l")

  -- Window split management
  safeMap("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
  safeMap("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
  safeMap("n", "<leader>w-", "<C-W>s", { desc = "Split below" })
  safeMap("n", "<leader>w|", "<C-W>v", { desc = "Split right" })
  safeMap("n", "<leader>-", "<C-W>s", { desc = "Split below (alias)" })
  safeMap("n", "<leader>|", "<C-W>v", { desc = "Split right (alias)" })

  -- Misc navigation & toggles
  safeMap("n", "<leader>ct", toggleWordWrap, { desc = "Toggle word wrap" })
  safeMap("n", "<leader>bc", "<cmd>BufferLinePick<CR>", { desc = "Pick buffer" })
end

-- ------------------------------------------------------ --
--                     VSCode Keymaps                     --
-- ------------------------------------------------------ --
local function defineVscodeKeymaps()
  -- Terminal controls
  safeMap("n", "<C-/>", function() vscodeCall("workbench.action.terminal.focus") end)
  safeMap("t", "<C-h>", function() vscodeCall("workbench.action.terminal.focusPreviousPane") end)
  safeMap("t", "<C-l>", function() vscodeCall("workbench.action.terminal.focusNextPane") end)

  -- File explorer and quick open
  safeMap("n", "<leader>fe", function() vscodeNotify("workbench.files.action.focusFilesExplorer") end)
  safeMap("n", "<leader>ff", function() vscodeNotify("workbench.action.quickOpen") end)
  safeMap("n", "<leader>gg", function() vscodeNotify("workbench.view.scm") end)

  -- Symbol and editor navigation
  safeMap("n", "<leader>cs", function() vscodeCall("workbench.action.gotoSymbol") end)
  safeMap("n", "<S-l>", function() vscodeNotify("workbench.action.nextEditor") end)
  safeMap("n", "<S-h>", function() vscodeNotify("workbench.action.previousEditor") end)

  -- LSP and diagnostics
  safeMap("n", "gr", function() vscodeNotify("editor.action.referenceSearch.trigger") end)
  safeMap("n", "<leader>cr", function() vscodeNotify("editor.action.rename") end)
  safeMap("n", "<leader>ca", function() vscodeNotify("editor.action.quickFix") end)
  safeMap("n", "<leader>cA", function() vscodeNotify("editor.action.sourceAction") end)
  safeMap("n", "<leader>sd", function() vscodeNotify("workbench.action.problems.focus") end)
  safeMap("n", "<leader>cp", function() vscodeNotify("workbench.panel.markers.view.focus") end)
  safeMap("n", "<leader>cd", function() vscodeNotify("editor.action.marker.next") end)

  -- Bookmark management
  safeMap("n", "<leader>sml", function() vscodeNotify("bookmarks.list") end)
  safeMap("n", "<leader>smL", function() vscodeNotify("bookmarks.listFromAllFiles") end)
  safeMap("n", "<leader>smm", function() vscodeNotify("bookmarks.toggle") end)
  safeMap("n", "<leader>smd", function() vscodeNotify("bookmarks.clear") end)
  safeMap("n", "<leader>smr", function() vscodeNotify("bookmarks.clearFromAllFiles") end)

  -- Clipboard and undo/redo
  safeMap("v", "<C-c>", function()
    vscodeNotify("editor.action.clipboardCopyAction")
    print("📎 Copied to clipboard!")
  end)
  safeMap("n", "u", function() vscodeNotify("undo") end)
  safeMap("n", "<C-r>", function() vscodeNotify("redo") end)
end

-- ------------------------------------------------------ --
--                    Keymap Dispatcher                   --
-- ------------------------------------------------------ --
-- Load mappings based on whether we're in VSCode
if vim.g.vscode then
  print("⚡ Connected to VSCode-Neovim")
  defineVscodeKeymaps()
else
  defineNeovimKeymaps()
end
