-- lua/config/options.lua

-- Indentation
vim.o.tabstop = 4         -- Number of spaces a tab counts for
vim.o.shiftwidth = 4      -- Number of spaces for indent
vim.o.expandtab = true     -- Use spaces instead of tabs
vim.o.smartindent = true   -- Smart auto-indenting

-- Search
vim.o.hlsearch = true      -- Highlight search results
vim.o.incsearch = true     -- Search as you type
vim.o.ignorecase = true    -- Case-insensitive search
vim.o.smartcase = true     -- Case-sensitive if search has uppercase

-- UI
vim.o.number = true        -- Show line numbers
vim.o.relativenumber = true -- Show relative line numbers
vim.o.cursorline = true    -- Highlight current line
vim.o.showmatch = true     -- Highlight matching brackets
vim.o.termguicolors = true -- Enable true colors
vim.o.scrolloff = 8       -- Keep 8 lines visible when scrolling
vim.o.sidescrolloff = 8   -- Keep 8 lines visible when side-scrolling
vim.o.wrap = false        -- Don't wrap lines

-- Clipboard
vim.o.clipboard = "unnamedplus" -- Use system clipboard

-- Other
vim.o.swapfile = false     -- Don't create swap files
