-- ----------------------------------------------------------------------------
--  Filename: ~/dotfiles/nvim/lua/config/utils/comment_divider.lua
--  Description: Wrapper functions to enhance comment-divider.nvim behavior.
--               These auto-execute or prefill :CommentDividerLine/Box with selected text.
-- ----------------------------------------------------------------------------

---@class CommentDividerUtils
local M = {}

-- ---------------------------------------------------------- --
--                       Constants                            --
-- ---------------------------------------------------------- --

local TRIM_PATTERN = "^%s*(.-)%s*$"

-- ---------------------------------------------------------- --
--                      Internal Helpers                      --
-- ---------------------------------------------------------- --

-- ------------------ Selection Validation ------------------ --
--- Check whether the current visual selection is single-line.
---@return boolean
local function is_single_line_visual()
  local _, csrow = unpack(vim.fn.getpos("'<"))
  local _, cerow = unpack(vim.fn.getpos("'>"))
  return csrow == cerow
end

-- ------------------- String Formatting  ------------------- --
--- Trim leading and trailing whitespace from a string.
---@param str string
---@return string
local function trim_whitespace(str)
  return (str:gsub(TRIM_PATTERN, "%1"))
end

--- Sanitize user input: remove newlines and trim whitespace.
---@param str string
---@return string
local function sanitize_input(str)
  return trim_whitespace((str:gsub("[\n\r]", "")))
end

-- ---------------------- Detect Text  ---------------------- --
--- Extract a single-line visual selection and return trimmed text.
---@return string|nil  # Selected text or nil if invalid
function M.get_visual_selection()
  if not is_single_line_visual() then
    print("[Divider] Multi-line selection not supported.")
    return nil
  end
  local _, csrow, cscol = unpack(vim.fn.getpos("'<"))
  local _, _, cecol = unpack(vim.fn.getpos("'>"))
  local line = vim.fn.getline(csrow)
  local selected = line:sub(cscol, cecol)
  local trimmed = trim_whitespace(selected)
  print("[Divider] Visual selection: " .. trimmed)
  return trimmed
end

--- Extract the current line content and trim whitespace.
---@return string
function M.get_current_line()
  local line = vim.fn.getline(".")
  return trim_whitespace(line)
end

--- Return the best title based on current mode and context.
---@return string|nil
local function get_inferred_title()
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" then
    return M.get_visual_selection()
  else
    return M.get_current_line()
  end
end

-- -------------------- Execute Command  -------------------- --
--- Feed a command to the command-line prompt for manual editing.
---@param cmd string
local function feed_command_prompt(cmd)
  local feed = ":" .. cmd .. " "
  print("[Divider] Prompting: " .. feed)
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(feed, true, false, true),
    "c",
    false
  )
end

--- Execute the comment-divider command directly.
---@param cmd string
---@param title string
local function execute_comment_divider(cmd, title)
  local full_cmd = cmd .. " " .. title
  print("[Divider] Executing: " .. full_cmd)
  vim.cmd(full_cmd)
end

-- ---------------------------------------------------------- --
--                     Command Dispatcher                     --
-- ---------------------------------------------------------- --

--- Core logic to handle :CommentDivider commands.
--- If text is found, executes immediately. Otherwise, prompts user.
---@param cmd string  # "CommentDividerLine" or "CommentDividerBox"
function M.insert_divider_command(cmd)
  local raw = get_inferred_title()
  local input = sanitize_input(raw or "")

  if input == "" then
    feed_command_prompt(cmd)
  else
    execute_comment_divider(cmd, input)
  end
end

-- ---------------------------------------------------------- --
--                      Public Interface                      --
-- ---------------------------------------------------------- --

--- Available base types for comment divider commands.
---@alias DividerType "Line"|"Box"

--- Insert a divider of the specified type using visual or line input.
---@param base DividerType
function M.insert_divider(base)
  M.insert_divider_command("CommentDivider" .. base)
end

--- Insert a :CommentDividerLine command.
function M.insert_divider_line()
  print("[Divider] insert_divider_line() called")
  M.insert_divider("Line")
end

--- Insert a :CommentDividerBox command.
function M.insert_divider_box()
  print("[Divider] insert_divider_box() called")
  M.insert_divider("Box")
end

return M
