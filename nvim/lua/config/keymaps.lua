local map = vim.keymap.set

-- Set leader key to space
vim.g.mapleader = " "

-- Normal mode
map("n", "<leader>w", ":w<CR>")      -- Save file
map("n", "<leader>q", ":q<CR>")      -- Quit
map("n", "<leader>Q", ":qa!<CR>")    -- Force quit
map("n", "<leader>h", ":nohlsearch<CR>") -- Clear search highlights
map("n", "<C-s>", ":w<CR>")          -- Save file with Ctrl+S
map("n", "<C-p>", ":FZF<CR>")        -- Open FZF (file finder)

-- Navigate splits
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Keybindings Reference Table
--
-- Keybinding: The actual key combination you press.
--
-- <leader> represents your leader key (space in this case).
-- <C-x> represents Ctrl + x.
--
-- Mode: The Neovim mode in which the keybinding applies:
--
-- n: Normal mode
-- i: Insert mode
-- v: Visual mode
-- x: Visual Line mode
-- s: Select mode
-- c: Command-line mode
-- o: Operator-pending mode
-- ! : Shell mode
-- t : Terminal mode

-- | Keybinding       | Mode | Description                                      |
-- | :--------------- | :--- | :----------------------------------------------- |
-- | `<leader>w`      | n    | Save the current file                            |
-- | `<leader>q`      | n    | Quit the current buffer                           |
-- | `<leader>Q`      | n    | Force quit Neovim                               |
-- | `<leader>h`      | n    | Clear search highlights                          |
-- | `<C-s>`          | n    | Save the current file                            |
-- | `<C-p>`          | n    | Open FZF (file finder) - (deprecated, use Telescope instead)            |
-- | `<C-h>`          | n    | Move to the left split                           |
-- | `<C-j>`          | n    | Move to the split below                        |
-- | `<C-k>`          | n    | Move to the split above                         |
-- | `<C-l>`          | n    | Move to the right split                          |
-- | `<leader>e`      | n    | Toggle Nvim-Tree file explorer (from `core.lua`)   |
-- | `<leader>ff`     | n    | Telescope: find files (from `core.lua`)         |
-- | `<leader>fg`     | n    | Telescope: live grep (from `core.lua`)          |
-- | `<leader>fb`     | n    | Telescope: find buffers (from `core.lua`)        |
-- | `<leader>fh`     | n    | Telescope: help tags (from `core.lua`)           |
-- | `gD`             | n    | LSP: Go to declaration (from `lsp.lua`)         |
-- | `gd`             | n    | LSP: Go to definition (from `lsp.lua`)         |
-- | `K`              | n    | LSP: Show hover information (from `lsp.lua`)    |
-- | `gi`             | n    | LSP: Go to implementation (from `lsp.lua`)      |
-- | `<C-k>`          | n    | LSP: Show signature help (from `lsp.lua`)       |
-- | `<space>wa`      | n    | LSP: Add workspace folder (from `lsp.lua`)      |
-- | `<space>wr`      | n    | LSP: Remove workspace folder (from `lsp.lua`)   |
-- | `<space>wl`      | n    | LSP: List workspace folders (from `lsp.lua`)    |
-- | `<space>D`      | n    | LSP: Go to type definition (from `lsp.lua`)     |
-- | `<space>rn`      | n    | LSP: Rename symbol (from `lsp.lua`)             |
-- | `<space>ca`      | n,v  | LSP: Code actions (from `lsp.lua`)              |
-- | `gr`             | n    | LSP: Go to references (from `lsp.lua`)         |
-- | `<space>f`       | n    | LSP: Format document (from `lsp.lua`)           |
-- | `<space>e`       | n    | LSP: Open diagnostics float (from `lsp.lua`)     |
-- | `[d`             | n    | LSP: Go to previous diagnostic (from `lsp.lua`) |
-- | `]d`             | n    | LSP: Go to next diagnostic (from `lsp.lua`)     |
-- | `<space>q`       | n    | LSP: Set diagnostics to location list (from `lsp.lua`) |
