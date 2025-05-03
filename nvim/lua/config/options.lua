-- -----------------------------------------------------------------------------
--  Filename: ~/dotfiles/nvim/lua/config/options.lua
--  Docs: https://www.lazyvim.org/configuration/general
--  Description: Override or extend LazyVim defaults
-- -----------------------------------------------------------------------------

-- ------------------------------------------------------ --
--                       Leader Keys                      --
-- ------------------------------------------------------ --
-- Already set by LazyVim:
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = "\\"

-- ------------------------------------------------------ --
--                       Python LSP                       --
-- ------------------------------------------------------ --
vim.g.python3_host_prog = vim.fn.expand("~/.pyenv/versions/neovim/bin/python3")

-- ------------------------------------------------------ --
--                     Editor Behavior                    --
-- ------------------------------------------------------ --
local opt = vim.opt

-- Override LazyVim default timeoutlen to increase delay in VSCode
opt.timeoutlen = vim.g.vscode and 1000 or 300

-- LazyVim sets most UI/editor defaults already
-- Keep these if you rely on custom plugin integration
opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]

-- ------------------------------------------------------ --
--                        Markdown                        --
-- ------------------------------------------------------ --
-- Avoid default Markdown indentation behavior
vim.g.markdown_recommended_style = 0
