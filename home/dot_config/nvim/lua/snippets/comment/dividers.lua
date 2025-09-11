-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/comment/dividers.lua
-- Description: Comment divider snippets to replace comment-divider plugin
-- ----------------------------------------------------------------------------

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- Function to create comment dividers based on filetype
local function create_comment_divider(text, comment_char)
  local line_length = 80
  local text_length = #text
  local dash_count = math.max(0, line_length - text_length - 2 * #comment_char - 2)
  local left_dashes = string.rep("-", math.floor(dash_count / 2))
  local right_dashes = string.rep("-", math.ceil(dash_count / 2))

  return comment_char .. left_dashes .. " " .. text .. " " .. right_dashes .. comment_char
end

-- Filetype-specific comment characters
local comment_chars = {
  python = "#",
  lua = "--",
  javascript = "//",
  typescript = "//",
  rust = "//",
  go = "//",
  c = "//",
  cpp = "//",
  java = "//",
  sh = "#",
  bash = "#",
  zsh = "#",
  fish = "#",
  vim = '"',
  html = "<!--",
  css = "/*",
  sql = "--",
}

return {
  -- Basic divider
  s("div", {
    f(function()
      local ft = vim.bo.filetype
      local comment_char = comment_chars[ft] or "#"
      local line = string.rep("-", 76)
      if comment_char == "<!--" then
        return "<!-- " .. line .. " -->"
      elseif comment_char == "/*" then
        return "/* " .. line .. " */"
      else
        return comment_char .. " " .. line .. " " .. comment_char
      end
    end),
    t({"", ""}),
    i(0),
  }),

  -- Section divider with text
  s("divs", {
    f(function(args)
      local ft = vim.bo.filetype
      local comment_char = comment_chars[ft] or "#"
      local text = args[1][1] or "SECTION"

      if comment_char == "<!--" then
        return "<!-- " .. create_comment_divider(text:upper(), "") .. " -->"
      elseif comment_char == "/*" then
        return "/* " .. create_comment_divider(text:upper(), "") .. " */"
      else
        return create_comment_divider(text:upper(), comment_char)
      end
    end, {1}),
    t({"", ""}),
    i(0),
  }, {
    -- Get text for the divider
    stored = {
      [1] = i(1, "Section"),
    },
  }),

  -- Title block with description
  s("divt", {
    f(function(args)
      local ft = vim.bo.filetype
      local comment_char = comment_chars[ft] or "#"
      local title = args[1][1] or "TITLE"
      local desc = args[2][1] or "Description"

      local lines = {}
      if comment_char == "<!--" then
        table.insert(lines, "<!-- " .. string.rep("-", 76) .. " -->")
        table.insert(lines, "<!-- " .. string.format("%-76s", title:upper()) .. " -->")
        table.insert(lines, "<!-- " .. string.format("%-76s", desc) .. " -->")
        table.insert(lines, "<!-- " .. string.rep("-", 76) .. " -->")
      elseif comment_char == "/*" then
        table.insert(lines, "/* " .. string.rep("-", 76) .. " */")
        table.insert(lines, "/* " .. string.format("%-76s", title:upper()) .. " */")
        table.insert(lines, "/* " .. string.format("%-76s", desc) .. " */")
        table.insert(lines, "/* " .. string.rep("-", 76) .. " */")
      else
        table.insert(lines, comment_char .. " " .. string.rep("-", 76) .. " " .. comment_char)
        table.insert(lines, comment_char .. string.format(" %-76s ", title:upper()) .. comment_char)
        table.insert(lines, comment_char .. string.format(" %-76s ", desc) .. comment_char)
        table.insert(lines, comment_char .. " " .. string.rep("-", 76) .. " " .. comment_char)
      end

      return lines
    end, {1, 2}),
    t({"", ""}),
    i(0),
  }, {
    stored = {
      [1] = i(1, "Title"),
      [2] = i(2, "Description of what this section does"),
    },
  }),

  -- File header divider
  s("divh", {
    f(function(args)
      local ft = vim.bo.filetype
      local comment_char = comment_chars[ft] or "#"
      local filename = args[1][1] or vim.fn.expand("%:t")
      local description = args[2][1] or "Description"

      local lines = {}
      if comment_char == "<!--" then
        table.insert(lines, "<!-- " .. string.rep("-", 76) .. " -->")
        table.insert(lines, "<!-- Filename: " .. filename .. string.rep(" ", 76 - 11 - #filename) .. " -->")
        table.insert(lines, "<!-- Description: " .. description .. string.rep(" ", 76 - 15 - #description) .. " -->")
        table.insert(lines, "<!-- " .. string.rep("-", 76) .. " -->")
      elseif comment_char == "/*" then
        table.insert(lines, "/* " .. string.rep("-", 76) .. " */")
        table.insert(lines, "/* Filename: " .. filename .. string.rep(" ", 76 - 11 - #filename) .. " */")
        table.insert(lines, "/* Description: " .. description .. string.rep(" ", 76 - 15 - #description) .. " */")
        table.insert(lines, "/* " .. string.rep("-", 76) .. " */")
      else
        table.insert(lines, comment_char .. " " .. string.rep("-", 76) .. " " .. comment_char)
        table.insert(lines, comment_char .. " Filename: " .. filename .. string.rep(" ", 76 - 11 - #filename) .. " " .. comment_char)
        table.insert(lines, comment_char .. " Description: " .. description .. string.rep(" ", 76 - 15 - #description) .. " " .. comment_char)
        table.insert(lines, comment_char .. " " .. string.rep("-", 76) .. " " .. comment_char)
      end

      return lines
    end, {1, 2}),
    t({"", ""}),
    i(0),
  }, {
    stored = {
      [1] = i(1, function() return vim.fn.expand("%:t") end),
      [2] = i(2, "File description"),
    },
  }),
}
