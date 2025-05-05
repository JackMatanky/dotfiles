-- ----------------------------------------------------------------------------
--  Filename      : ~/dotfiles/nvim/lua/config/utils/comment_divider.lua
--  Description   : Wrapper functions to enhance comment-divider.nvim behavior.
--                  These allow automatic use of visual selections or prompts.
-- ----------------------------------------------------------------------------

---@class CommentDividerUtils
local M = {}

-- ---------------------------------------------------------- --
--                      Internal Helpers                      --
-- ---------------------------------------------------------- --

--- Extract a single-line visual selection from the buffer.
--- Used to auto-generate divider titles if text is highlighted.
---@return string|nil  # Selected text or nil if invalid
function M.get_visual_selection()
  local _, csrow, cscol = unpack(vim.fn.getpos("'<")) -- visual start
  local _, cerow, cecol = unpack(vim.fn.getpos("'>")) -- visual end

  -- Only support single-line selections (no multi-line titles)
  if csrow ~= cerow then
    return nil
  end

  local line = vim.fn.getline(csrow)
  return line:sub(cscol, cecol)
end

--- Check if the user is in visual mode and extract the selection.
--- Escapes visual mode before returning to avoid side effects.
---@return string|nil  # Title from selection or nil
function M.get_title_from_visual()
  local mode = vim.fn.mode()

  -- If not in visual mode, skip
  if mode ~= "v" and mode ~= "V" then
    return nil
  end

  local title = M.get_visual_selection()

  -- Exit visual mode manually (required to prevent interference)
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
    "n",
    true
  )

  return title
end

--- Prompt the user to manually enter a title string.
---@param prompt string
---@return string
function M.get_title_from_prompt(prompt)
  return vim.fn.input(prompt)
end

--- Resolve a title for the divider using visual mode or prompt fallback.
---@param prompt string
---@return string
function M.resolve_title(prompt)
  return M.get_title_from_visual() or M.get_title_from_prompt(prompt)
end

-- ---------------------------------------------------------- --
--                     Command Execution                      --
-- ---------------------------------------------------------- --

--- Run the appropriate divider command with or without a title.
---@param cmd string          # The full command name
---@param title string|nil    # The divider title, or nil to insert a plain line
function M.run_divider_command(cmd, title)
  if title and title ~= "" then
    vim.cmd(cmd .. " " .. title)
  else
    vim.cmd(cmd)
  end
end

-- ---------------------------------------------------------- --
--                      Public Interface                      --
-- ---------------------------------------------------------- --

--- Type-safe base for divider commands
---@alias DividerType "Line"|"Box"

--- Insert a divider (line or box), using selection or prompt.
---@param base DividerType
function M.insert_divider(base)
  local cmd = "CommentDivider" .. base
  local prompt = "Comment" .. base .. " title: "
  local title = M.resolve_title(prompt)
  M.run_divider_command(cmd, title)
end

--- Insert a titled horizontal divider line
function M.insert_divider_line()
  M.insert_divider("Line")
end

--- Insert a titled divider box (top and bottom)
function M.insert_divider_box()
  M.insert_divider("Box")
end

return M
