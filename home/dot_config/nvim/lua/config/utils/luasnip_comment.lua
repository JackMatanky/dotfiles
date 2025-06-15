-- -----------------------------------------------------------------------------
--  Filename: ~/dotfiles/nvim/lua/config/utils/comment_divider.lua
--  Description: Custom divider insertion logic for visual/normal modes.
--               Includes centered title generation, dynamic comment symbols,
--               and title casing with unicode-aware centering and spacing.
-- -----------------------------------------------------------------------------

---@class CommentDividerUtils
local M = {}

-- Language-specific comment symbol configuration
local COMMENT_TOKENS = {
  default = {
    lineStart = "--",
    lineSeperator = "-",
    lineEnd = "--",
  },
  lua = {
    lineStart = "--",
    lineSeperator = "-",
    lineEnd = "--",
  },
  python = {
    lineStart = "#",
    lineSeperator = "-",
    lineEnd = "#",
  },
  html = {
    lineStart = "<!--",
    lineSeperator = "-",
    lineEnd = "-->",
  },
  cpp = {
    lineStart = "/*",
    lineSeperator = "-",
    lineEnd = "*/",
  },
  toml = {
    lineStart = "#",
    lineSeperator = "-",
    lineEnd = "#",
  },
}

local DIVIDER_WIDTH = 64

-- ---------------------------------------------------------- --
--                        String Utils                        --
-- ---------------------------------------------------------- --

local function trim(str)
  return str:gsub("^%s*(.-)%s*$", "%1")
end

local function title_case(str)
  return str:gsub("(%S+)", function(word)
    return word:sub(1, 1):upper() .. word:sub(2):lower()
  end)
end

local function truncate_title(title, max_width)
  local title_width = vim.fn.strdisplaywidth(title)
  if title_width > max_width then
    return vim.fn.strcharpart(title, 0, max_width - 3) .. "..."
  end
  return title
end

-- ---------------------------------------------------------- --
--                    Comment Token Logic                     --
-- ---------------------------------------------------------- --

local function get_tokens()
  local ft = vim.bo.filetype
  return COMMENT_TOKENS[ft] or COMMENT_TOKENS.default
end

-- ---------------------------------------------------------- --
--                      Text Extraction                       --
-- ---------------------------------------------------------- --

function M.get_visual_selection()
  local _, csrow, cscol = unpack(vim.fn.getpos("'<"))
  local _, cerow, cecol = unpack(vim.fn.getpos("'>"))

  if csrow ~= cerow then
    print("[Divider] Multi-line visual selection not supported.")
    return nil
  end

  local line = vim.fn.getline(csrow)
  local selected = line:sub(cscol, cecol)
  return trim(selected)
end

function M.get_current_line()
  local line = vim.fn.getline(".")
  return trim(line)
end

-- ---------------------------------------------------------- --
--                      Divider Builders                      --
-- ---------------------------------------------------------- --

local function center_text(text, width)
  local display_width = vim.fn.strdisplaywidth(text)
  local padding = width - display_width
  local left = math.floor(padding / 2)
  local right = padding - left
  return string.rep(" ", left) .. text .. string.rep(" ", right)
end

local function build_line_divider(title)
  local tokens = get_tokens()
  local raw_title = title_case(trim(title or ""))
  local final_title = truncate_title(raw_title, DIVIDER_WIDTH)
  local content = final_title ~= "" and center_text(final_title, DIVIDER_WIDTH)
    or string.rep(tokens.lineSeperator, DIVIDER_WIDTH)
  return string.format("%s %s %s", tokens.lineStart, content, tokens.lineEnd)
end

local function build_box_divider(title)
  local tokens = get_tokens()
  local top = string.format("%s %s %s", tokens.lineStart, string.rep(tokens.lineSeperator, DIVIDER_WIDTH), tokens.lineEnd)
  local middle = string.format("%s %s %s", tokens.lineStart, center_text(truncate_title(title_case(trim(title or "")), DIVIDER_WIDTH), DIVIDER_WIDTH), tokens.lineEnd)
  local bottom = top
  return {"", top, middle, bottom, ""} -- With outer spacing
end

-- ---------------------------------------------------------- --
--                    Public Insert Functions                 --
-- ---------------------------------------------------------- --

function M.insert_divider_line()
  local mode = vim.fn.mode()
  local title = (mode == "v" or mode == "V") and M.get_visual_selection() or M.get_current_line()
  local line = build_line_divider(title)
  vim.api.nvim_put({ "", line, "" }, "l", true, true)
end

function M.insert_divider_box()
  local mode = vim.fn.mode()
  local title = (mode == "v" or mode == "V") and M.get_visual_selection() or M.get_current_line()
  local lines = build_box_divider(title)
  vim.api.nvim_put(lines, "l", true, true)
end

return M
