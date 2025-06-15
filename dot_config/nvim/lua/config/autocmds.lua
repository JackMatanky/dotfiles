-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- ----------------------------------------------------------------------------

-- Opens PDF files in Zathura, either within a new Zellij pane or directly.
--
-- This autocommand triggers when Neovim attempts to open a PDF file. It checks if
-- the Neovim session is running within Zellij by examining the `ZELLIJ_VERSION`
-- environment variable. If Zellij is detected, Zathura is launched in a new pane.
-- Otherwise, Zathura is launched as a standalone process.
--
-- @author [Your Name/Alias]
-- @since [Date]
--
-- Error handling is included to notify the user if Zathura fails to start.
-- The Neovim buffer for the PDF is closed after Zathura is launched.
--
-- Dependencies:
-- - Zathura
-- - Zellij (optional, for pane splitting)
--
-- Configuration:
-- Place this code within your Neovim configuration file (e.g., `init.lua`).
-- Ensure Zathura and Zellij are installed and accessible in your PATH.
--
-- Usage:
-- Simply open a PDF file within Neovim. The autocommand will automatically
-- launch Zathura.

vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = "*.pdf", -- Trigger when opening a PDF file
  callback = function(args)
    local pdf_file = vim.fn.expand("<afile>") -- Get the full path of the PDF

    local zellij_version = vim.fn.getenv("ZELLIJ_VERSION") -- Check if running inside Zellij

    local command = {} -- Initialize command table

    if zellij_version ~= "" then
      -- If inside Zellij, open in a new pane
      command = { "zellij", "action", "new-pane", "--", "zathura", pdf_file }
    else
      -- Otherwise, open Zathura directly
      command = { "zathura", pdf_file }
    end

    local job_id = vim.fn.jobstart(command, { detach = true }) -- Start Zathura in the background

    if job_id == 0 then
      -- If job failed to start, notify user
      vim.notify("Failed to start Zathura.", vim.log.levels.ERROR)
    else
      -- If job started successfully, close the Neovim buffer
      vim.cmd("bdelete")
    end
  end,
})
