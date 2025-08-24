-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/markdown/base.lua
-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Description: This file contains all the standard, non-conditional Markdown
--              snippets. It is designed to be 'required' by the main loader
--              file and does not contain any conditional logic itself.
-- ----------------------------------------------------------------------------

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local c = ls.choice_node
local t = ls.text_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt

-- --------------------- HELPER FUNCTION -------------------- --
-- Helper function to generate a Markdown table of arbitrary size.
-- This encapsulates the logic, making the snippet definition cleaner.
local function generate_table(rows, cols)
  if not rows or not cols or rows == 0 or cols == 0 then
    return s(nil, {}) -- Return empty snippet if input is invalid
  end

  local fmt_str = ""
  local insert_nodes = {}
  local cell_count = 1

  -- Header row
  for _ = 1, cols do
    fmt_str = fmt_str .. "| {} "
  end
  fmt_str = fmt_str .. "|\n"
  for _ = 1, cols do
    table.insert(insert_nodes, i(cell_count))
    cell_count = cell_count + 1
  end

  -- Separator row
  for _ = 1, cols do
    fmt_str = fmt_str .. "|---"
  end
  fmt_str = fmt_str .. "|\n"

  -- Body rows
  for _ = 2, rows do
    for _ = 1, cols do
      fmt_str = fmt_str .. "| {} "
    end
    fmt_str = fmt_str .. "|\n"
    for _ = 1, cols do
      table.insert(insert_nodes, i(cell_count))
      cell_count = cell_count + 1
    end
  end

  -- Add final tab stop for cursor position
  table.insert(insert_nodes, i(0))
  fmt_str = fmt_str .. "{}"

  return s(nil, fmt(fmt_str, insert_nodes))
end

return {
  -- ------------------------ Headers ----------------------- --
  s({
    trig = "hdr",
    name = "Header (dynamic)",
    dscr = "Creates a Markdown header with a dynamic choice of level (1-6).",
  }, {
    c(1, { t("#"), t("##"), t("###"), t("####"), t("#####"), t("######") }),
    t(" "),
    i(2),
  }),
  s(
    {
      trig = "h(%d)",
      regTrig = true,
      name = "Header (Regex)",
      dscr = "Dynamically creates a header of level 1-6 based on the trigger (e.g., h3).",
    },
    d(1, function(args)
      local level = tonumber(args[1][1])
      if level and level > 0 and level <= 6 then
        local hashes = string.rep("#", level)
        return s(nil, { t(hashes .. " "), i(1) })
      end
      return s(nil, {})
    end)
  ),

  -- -------------------- Links & Images -------------------- --
  s({
    trig = { "l", "link" },
    name = "Link",
    dscr = "Inserts a Markdown link with placeholders for text and URL.",
  }, { t("["), i(1, "text"), t("]("), i(2, "url"), t(")"), i(0) }),
  s({
    trig = { "u", "url" },
    name = "URL",
    dscr = "Inserts a bare URL enclosed in angle brackets.",
  }, { t("<"), i(1), t(">"), i(0) }),
  s({
    trig = "img",
    name = "Image",
    dscr = "Inserts a Markdown image with placeholders for alt text and path.",
  }, { t("!["), i(1, "alt text"), t("]("), i(2, "path"), t(")"), i(0) }),

  -- -------------------- Text Formatting ------------------- --
  s({
    trig = "strikethrough",
    name = "Strikethrough",
    dscr = "Applies strikethrough formatting (`~~text~~`).",
  }, { t("~~"), i(1), t("~~"), i(0) }),
  s({
    trig = { "bold", "b" },
    name = "Bold",
    dscr = "Applies bold formatting (`**text**`).",
  }, { t("**"), i(1), t("**"), i(0) }),
  s({
    trig = { "i", "italic" },
    name = "Italic",
    dscr = "Applies italic formatting (`*text*`).",
  }, { t("*"), i(1), t("*"), i(0) }),
  s({
    trig = { "bold and italic", "bi" },
    name = "Bold & Italic",
    dscr = "Applies bold and italic formatting (`***text***`).",
  }, { t("***"), i(1), t("***"), i(0) }),

  -- -------------------- Block Elements -------------------- --
  s({
    trig = "quote",
    name = "Blockquote",
    dscr = "Creates a blockquote (`> text`).",
  }, { t("> "), i(1) }),
  s({
    trig = "code",
    name = "Inline Code",
    dscr = "Creates an inline code block (` `).",
  }, { t("`"), i(1), t("`"), i(0) }),
  s(
    {
      trig = "codeblock",
      name = "Fenced Code Block",
      dscr = "Creates a fenced code block with a dynamic choice for the language.",
    },
    fmt(
      [[
    ```{}
    {}
    ```]],
      {
        c(1, {
          t("python"),
          t("sql"),
          t("javascript"),
          t("typescript"),
          t("r"),
          t("markdown"),
          t("lua"),
        }),
        i(0),
      }
    )
  ),
  s({
    trig = "hr",
    name = "Horizontal Rule",
    dscr = "Inserts a horizontal rule (`---`).",
  }, t("---"), t("\n")),

  -- ------------------------- Lists ------------------------ --
  s(
    {
      trig = "ul",
      name = "Unordered List",
      dscr = "Creates a 3-item unordered list.",
    },
    fmt(
      [[
    - {}
    - {}
    - {}

    {}
    ]],
      {
        i(1),
        i(2),
        i(3),
        i(0),
      }
    )
  ),
  s(
    {
      trig = "ol",
      name = "Ordered List",
      dscr = "Creates a 3-item ordered list.",
    },
    fmt(
      [[
    1. {}
    2. {}
    3. {}

    {}
    ]],
      {
        i(1),
        i(2),
        i(3),
        i(0),
      }
    )
  ),
  s({
    trig = "task",
    name = "Task List",
    dscr = "Creates a task list item with a dynamic choice for completion status.",
  }, { t("- ["), c(1, { t(" "), t("x") }), t("] "), i(2) }),

  -- ------------------------ Tables ------------------------ --
  s(
    {
      trig = "tbl(%d)(%d)",
      regTrig = true,
      name = "Table (dynamic)",
      dscr = "Dynamically creates a Markdown table of size RxC (e.g., tbl23 for 2x3).",
    },
    d(1, function(args)
      local rows = tonumber(args[1][1])
      local cols = tonumber(args[1][2])
      return generate_table(rows, cols)
    end)
  ),

  -- HTML Sub/Superscript
  s({
    trig = "sub",
    name = "Subscript (HTML)",
    dscr = "Creates an HTML subscript using `<sub>` tags.",
  }, { t("<sub>"), i(0), t("</sub>") }),
  s({
    trig = "sup",
    name = "Superscript (HTML)",
    dscr = "Creates an HTML superscript using `<sup>` tags.",
  }, { t("<sup>"), i(0), t("</sup>") }),

  -- ----------------------- Callouts ----------------------- --
  s(
    {
      trig = ">(note|tip|important|warning|caution|imp)",
      regTrig = true,
      name = "Callout (dynamic)",
      dscr = "Creates a callout based on the keyword (e.g., `>note`, `>tip`, `>w`).",
    },
    d(1, function(args)
      local key = args[1][1]
      local callout_map = {
        note = "NOTE",
        tip = "TIP",
        important = "IMPORTANT",
        imp = "IMPORTANT",
        warning = "WARNING",
        caution = "CAUTION",
      }
      local callout_type = callout_map[key]
      if callout_type then
        return s(nil, { t(string.format("[!%s]\n> ", callout_type)), i(0) })
      end
      return s(nil, {})
    end)
  ),
}
