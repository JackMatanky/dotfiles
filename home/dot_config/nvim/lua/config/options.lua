-- -----------------------------------------------------------------------------
--  Filename: ~/.config/nvim/lua/config/options.lua
--  Docs: https://www.lazyvim.org/configuration/general
--  Description: Override or extend LazyVim defaults
-- -----------------------------------------------------------------------------

-- ---------------------------------------------------------- --
--                      Lazyvim Defaults                      --
-- ---------------------------------------------------------- --

-- Sets the terminal to use with `vim.o.shell`
-- and adds some additional configuration:
LazyVim.terminal.setup("/opt/homebrew/bin/nu")

-- Picker to use: "telescope", "fzf", or "auto"
vim.g.lazyvim_picker = "snacks"

-- Completion engine: "nvim-cmp", "blink.cmp", or "auto"
vim.g.lazyvim_cmp = "blink.cmp"

-- set to `true` to follow the main branch
-- A working rust toolchain is required to build the plugin in this case.
vim.g.lazyvim_blink_main = false

-- Introduced in version 10.x
-- Docs: https://www.lazyvim.org/news#10x
vim.g.lazygit_config = false

-- ---------------------------------------------------------- --
--                         Python LSP                         --
-- ---------------------------------------------------------- --
vim.g.python3_host_prog = vim.fn.expand("~/.pyenv/versions/neovim/bin/python3")

-- Introduced in version 10.x
-- Docs: https://www.lazyvim.org/news#10x
vim.g.lazyvim_python_lsp = "basedpyright"

-- Python formatter preferences (Ruff CLI is much faster than Black)
-- Use "ruff" (CLI) instead of "ruff_lsp" for formatting and linting
vim.g.lazyvim_python_ruff = "ruff"

-- ---------------------------------------------------------- --
--                      Editor Behavior                       --
-- ---------------------------------------------------------- --
-- local opt = vim.opt

-- Override LazyVim default timeoutlen to increase delay in VSCode
-- opt.timeoutlen = vim.g.vscode and 1000 or 300

-- LazyVim sets most UI/editor defaults already
-- Keep these if you rely on custom plugin integration
-- opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]

-- ---------------------------------------------------------- --
--                          Markdown                          --
-- ---------------------------------------------------------- --
-- Avoid default Markdown indentation behavior
-- vim.g.markdown_recommended_style = 0
