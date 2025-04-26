-- --------------------------------------------------------------------
--  Filename: ~/dotfiles/nvim/lua/config/options.lua
--  LazyVim Docs: https://www.lazyvim.org/configuration/general
-- --------------------------------------------------------------------

-- >>> General <<<

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.deprecation_warnings = false -- Suppress deprecation messages
-- http://www.lazyvim.org/extras/vscode
vim.g.vscode = true


-- >>> UI / Appearance <<<

vim.g.snacks_animate = true -- Enable snacks.nvim animation
vim.g.trouble_lualine = true -- Show breadcrumbs in lualine via Trouble
vim.g.lazyvim_picker = "auto" -- Use auto-detected picker (telescope or fzf)
vim.g.lazyvim_cmp = "auto" -- Auto-select completion engine (cmp or blink.cmp)
vim.g.ai_cmp = true -- Use AI completion when supported

-- >>> Clipboard / Root Detection <<<

vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" } -- Project root detection rules
vim.g.root_lsp_ignore = { "copilot" } -- Prevent LSP root conflicts

-- >>> Formatting <<<

vim.g.autoformat = false -- Disable LazyVim autoformatting globally

-- >>> Python LSP <<<

vim.g.python3_host_prog = vim.fn.expand("~/.pyenv/versions/neovim/bin/python3") -- Python for plugins
vim.g.lazyvim_python_lsp = "basedpyright" -- Use BasedPyright instead of Pyright
vim.g.lazyvim_python_ruff = "ruff_lsp" -- Use Ruff LSP instead of null-ls

-- >>> Formatting & Indentation <<<

local opt = vim.opt

opt.expandtab = true -- Convert tabs to spaces
opt.tabstop = 2 -- Tab width in spaces
opt.shiftwidth = 2 -- Indent width
opt.shiftround = true -- Round indents to nearest shiftwidth
opt.smartindent = true -- Smart auto-indentation
opt.formatoptions = "jcroqlnt" -- Better format rules
opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()" -- Use LazyVim format handler
opt.conceallevel = 2 -- Hide Markdown formatting markers
opt.foldlevel = 99 -- Open all folds by default

if vim.fn.has("nvim-0.10") == 1 then
  opt.smoothscroll = true
  opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
  opt.foldmethod = "expr"
  opt.foldtext = ""
else
  opt.foldmethod = "indent"
  opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
end

-- >>> Line Numbers & Status <<<

opt.number = true -- Absolute line numbers
opt.relativenumber = true -- Relative line numbers
opt.cursorline = true -- Highlight current line
opt.ruler = false -- Hide default ruler
opt.laststatus = 3 -- Global statusline
opt.signcolumn = "yes" -- Always show signcolumn
opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
opt.showmode = false -- Hide -- INSERT -- since lualine shows it

-- >>> Whitespace, Wrapping, Invisibles <<<

opt.linebreak = true -- Wrap lines at natural breakpoints
opt.list = true -- Show tabs and trailing spaces
opt.wrap = false -- Disable word wrap

-- >>> Completion & Popups <<<

opt.pumheight = 10 -- Max popup menu height
opt.pumblend = 10 -- Make popups slightly transparent
opt.completeopt = "menu,menuone,noselect" -- Completion behavior

-- >>> Editor Behavior <<<

opt.autowrite = true -- Save before switching buffers
opt.confirm = true -- Confirm before quitting modified files
opt.mouse = "a" -- Enable mouse support
opt.scrolloff = 4 -- Vertical scroll margin
opt.sidescrolloff = 8 -- Horizontal scroll margin
opt.jumpoptions = "view" -- Restore view on jump
opt.splitbelow = true -- New horizontal split below
opt.splitright = true -- New vertical split right
opt.splitkeep = "screen" -- Preserve screen when splitting
opt.updatetime = 200 -- CursorHold delay
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Faster which-key response
opt.virtualedit = "block" -- Allow visual block past EOL
opt.undofile = true -- Enable persistent undo
opt.undolevels = 10000 -- Max undo history
opt.wildmode = "longest:full,full" -- Command line completion mode

-- >>> Search & Grep <<<

opt.ignorecase = true -- Case-insensitive search
opt.smartcase = true -- But respect uppercase
opt.inccommand = "nosplit" -- Live preview of :%s
opt.grepprg = "rg --vimgrep" -- Use ripgrep
opt.grepformat = "%f:%l:%c:%m"

-- >>> Fillchars & Symbols <<<

opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

-- >>> Markdown <<<

vim.g.markdown_recommended_style = 0 -- Don't override indentation

-- >>> Sessions <<<

opt.sessionoptions = {
  "buffers",
  "curdir",
  "tabpages",
  "winsize",
  "help",
  "globals",
  "skiprtp",
  "folds",
}

-- >>> Visual Feedback & Spell <<<

opt.termguicolors = true -- Enable 24-bit colors
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.spelllang = { "en" } -- Set spellcheck language
