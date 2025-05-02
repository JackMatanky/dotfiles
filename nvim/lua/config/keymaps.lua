-- -----------------------------------------------------------------------------
--  Filename: ~/.config/nvim/lua/config/keymaps.lua
--  Docs: https://www.lazyvim.org/configuration/general
--  Description: Context-aware keymaps for Neovim and VSCode
-- -----------------------------------------------------------------------------

-- Keymaps are automatically loaded on the VeryLazy event.
-- This file supplements LazyVim defaults with custom mappings.
-- See LazyVim's default keymaps: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- ------------------------
--  Safe Mapping Utility
-- ------------------------
-- Wrapper around vim.keymap.set that respects Lazy.nvim key handlers.
-- Avoids overwriting user-defined Lazy keys. Use this for all mappings.
local function map(mode, lhs, rhs, opts)
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

-- ------------------------
--  Helper Functions
-- ------------------------

-- Toggle line wrapping and print result
local function ToggleWordWrap()
  vim.wo.wrap = not vim.wo.wrap
  print("Word wrap " .. (vim.wo.wrap and "enabled" or "disabled"))
end

-- Temporarily enable system clipboard, yank visually selected text, then disable clipboard
local function copyToClipBoard()
  vim.cmd("set clipboard+=unnamedplus")
  vim.cmd("norm! y")
  vim.cmd("set clipboard-=unnamedplus")
  print("copied!")
end

-- Wrapper for VSCodeCall or VSCodeNotify
local function callVSCodeFunction(vsCodeCommand)
  vim.cmd(vsCodeCommand)
end

-- ------------------------
--  Neovim Keymaps
-- ------------------------
-- These are only loaded in standalone Neovim (not VSCode).

local function neovimMappings()
  -- Move lines or blocks up/down using Alt-j/k in normal and visual modes
  map("n", "<A-j>", ":m .+1<CR>==")
  map("n", "<A-k>", ":m .-2<CR>==")
  map("v", "<A-j>", ":m '>+1<CR>gv=gv")
  map("v", "<A-k>", ":m '<-2<CR>gv=gv")

  -- Arrow-like movement in insert mode using Ctrl keys
  map("i", "<C-h>", "<Left>")
  map("i", "<C-l>", "<Right>")
  map("i", "<C-j>", "<Down>")
  map("i", "<C-k>", "<Up>")

  -- Search-and-replace current word using Ctrl-d in insert mode
  map("i", "<C-d>", function()
    local new_text = vim.fn.input("Replace with?: ")
    local cmd = "normal! *Ncgn" .. new_text
    vim.cmd(cmd)
  end, { desc = "ctrl+d vs code alternative" })

  -- Start search from insert mode using Ctrl-f
  map("i", "<C-f>", "<Esc>/")

  -- Delete next word or character using backspace or Ctrl-l in insert mode
  map("i", "<BS>", "<cmd>norm! de<CR>", { desc = "delete next word to right" })
  map("i", "<C-l>", "<Del>", { remap = true, desc = "delete one char forward" })

  -- Select entire buffer in insert mode using Ctrl-a
  map("i", "<C-a>", function()
    vim.cmd("norm! ggVG")
    print("Selected all lines")
  end, { desc = "select all lines in buffer" })

  -- Copy to clipboard using Ctrl-c in visual or insert modes
  map({ "v", "i" }, "<C-c>", copyToClipBoard, { desc = "copy selection" })

  -- Toggle line wrap, pick buffer visually, open parent directory via oil.nvim
  map("n", "<leader>ct", ToggleWordWrap, { desc = "toggle word wrap" })
  map("n", "<leader>bc", "<cmd>BufferLinePick<CR>", { desc = "pick buffer" })
  map("n", "-", require("oil").open, { desc = "open parent directory" })

  -- Clear search highlights using <Esc>
  map("n", "<Esc>", "<cmd>noh<CR>", { desc = "clear search highlight" })

  -- Navigate between windows using Ctrl-h/j/k/l
  map("n", "<C-h>", "<C-w>h")
  map("n", "<C-j>", "<C-w>j")
  map("n", "<C-k>", "<C-w>k")
  map("n", "<C-l>", "<C-w>l")

  -- Manage splits via leader bindings
  map("n", "<leader>ww", "<C-W>p", { desc = "other window" })
  map("n", "<leader>wd", "<C-W>c", { desc = "delete window" })
  map("n", "<leader>w-", "<C-W>s", { desc = "split below" })
  map("n", "<leader>w|", "<C-W>v", { desc = "split right" })
  map("n", "<leader>-", "<C-W>s", { desc = "split below (alias)" })
  map("n", "<leader>|", "<C-W>v", { desc = "split right (alias)" })
end

-- ------------------------
--  VSCode Keymaps
-- ------------------------
-- These keymaps only load when running inside VSCode with vscode-neovim

local function vscodeMappings()
  -- Terminal access
  map("n", "<C-/>", function()
    callVSCodeFunction("call VSCodeCall('workbench.action.terminal.focus')")
  end, { desc = "focus terminal" })

  map("t", "<C-h>", function()
    callVSCodeFunction("call VSCodeCall('workbench.action.terminal.focusPreviousPane')")
  end, { desc = "previous terminal pane" })

  map("t", "<C-l>", function()
    callVSCodeFunction("call VSCodeCall('workbench.action.terminal.focusNextPane')")
  end, { desc = "next terminal pane" })

  -- File explorer and quick open
  map("n", "<leader>fe", function()
    callVSCodeFunction("call VSCodeNotify('workbench.files.action.focusFilesExplorer')")
  end, { desc = "focus file explorer" })

  map("n", "<leader>ff", function()
    callVSCodeFunction("call VSCodeNotify('workbench.action.quickOpen')")
  end, { desc = "open file search" })

  map("n", "<leader>gg", function()
    callVSCodeFunction("call VSCodeNotify('workbench.view.scm')")
  end, { desc = "open git view" })

  -- Symbol navigation
  map("n", "<leader>cs", function()
    callVSCodeFunction("call VSCodeCall('workbench.action.gotoSymbol')")
  end, { desc = "go to symbol" })

  -- Editor tab switching
  map("n", "<S-l>", function()
    callVSCodeFunction("call VSCodeNotify('workbench.action.nextEditor')")
  end, { desc = "next editor" })

  map("n", "<S-h>", function()
    callVSCodeFunction("call VSCodeNotify('workbench.action.previousEditor')")
  end, { desc = "previous editor" })

  -- LSP-like features (references, rename, fixes)
  map("n", "gr", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.referenceSearch.trigger')")
  end, { desc = "peek references" })

  map("n", "<leader>cr", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.rename')")
  end, { desc = "rename symbol" })

  map("n", "<leader>ca", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.quickFix')")
  end, { desc = "quick fix" })

  map("n", "<leader>cA", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.sourceAction')")
  end, { desc = "source action" })

  -- Diagnostic panels
  map("n", "<leader>sd", function()
    callVSCodeFunction("call VSCodeNotify('workbench.action.problems.focus')")
  end, { desc = "problems panel" })

  map("n", "<leader>cp", function()
    callVSCodeFunction("call VSCodeNotify('workbench.panel.markers.view.focus')")
  end, { desc = "focus markers panel" })

  map("n", "<leader>cd", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.marker.next')")
  end, { desc = "next diagnostic" })

  -- Bookmark controls
  map("n", "<leader>sml", function()
    callVSCodeFunction("call VSCodeNotify('bookmarks.list')")
  end, { desc = "bookmarks in file" })

  map("n", "<leader>smL", function()
    callVSCodeFunction("call VSCodeNotify('bookmarks.listFromAllFiles')")
  end, { desc = "bookmarks in all files" })

  map("n", "<leader>smm", function()
    callVSCodeFunction("call VSCodeNotify('bookmarks.toggle')")
  end, { desc = "toggle bookmark" })

  map("n", "<leader>smd", function()
    callVSCodeFunction("call VSCodeNotify('bookmarks.clear')")
  end, { desc = "clear bookmarks in file" })

  map("n", "<leader>smr", function()
    callVSCodeFunction("call VSCodeNotify('bookmarks.clearFromAllFiles')")
  end, { desc = "clear all bookmarks" })

  -- Clipboard and undo/redo
  map("v", "<C-c>", function()
    callVSCodeFunction("call VSCodeNotify('editor.action.clipboardCopyAction')")
    print("📎 added to clipboard!")
  end, { desc = "copy to clipboard" })

  map("n", "u", function()
    callVSCodeFunction("call VSCodeNotify('undo')")
  end, { desc = "undo" })

  map("n", "<C-r>", function()
    callVSCodeFunction("call VSCodeNotify('redo')")
  end, { desc = "redo" })
end

-- ------------------------
--  Keymap Dispatcher
-- ------------------------

if vim.g.vscode then
  print("⚡ Connected to VSCode-Neovim")
  vscodeMappings()
else
  neovimMappings()
end
