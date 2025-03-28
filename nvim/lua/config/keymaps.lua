-- --------------------------------------------------------------------
--  Filename: ~/dotfiles/nvim/lua/config/keymaps.lua
--  LazyVim Docs: https://www.lazyvim.org/configuration/general
--  GitHub:  https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua (Default Options)
-- --------------------------------------------------------------------- 

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- DO NOT USE `LazyVim.safe_keymap_set` IN YOUR OWN CONFIG!!
-- use `vim.keymap.set` instead

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Move line up/down in normal mode
map("n", "<A-j>", ":m .+1<CR>==", opts)
map("n", "<A-k>", ":m .-2<CR>==", opts)

-- Move block up/down in visual mode
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)
