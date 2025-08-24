-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/python/context_managers.lua
-- Description: Contains snippets for context managers, including `with` and
--              `async with` statements.
-- ----------------------------------------------------------------------------

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s(
    {
      trig = "with",
      name = "With Statement",
      dscr = "'with' statement",
    },
    fmt(
      [[
  with {} as {}:
      {}
  ]],
      {
        i(1, "expr"),
        i(2, "var"),
        i(0, "pass"),
      }
    )
  ),

  s({
    trig = "withf",
    name = "With Statement for File",
    dscr = "'with' statement for reading/writing files",
  }, {
    t("with open("),
    i(1, "filename"),
    t(', "'),
    c(2, { t("r"), t("w"), t("a"), t("r+"), t("rb"), t("wb") }),
    t('") as '),
    i(3, "f"),
    t({ ":", "    " }),
    i(0, "pass"),
  }),

  s(
    {
      trig = "withsq",
      name = "With Statement for SQLite",
      dscr = "'with' statement for SQLite database connection",
    },
    fmt(
      [[
  import sqlite3

  with sqlite3.connect({}) as {}:
      {}
  ]],
      {
        i(1, "database"),
        i(2, "conn"),
        i(0, "pass"),
      }
    )
  ),

  s(
    {
      trig = "witha",
      name = "With Statement Async",
      dscr = "'async with' statement",
    },
    fmt(
      [[
  async with {} as {}:
      {}
  ]],
      {
        i(1, "expr"),
        i(2, "var"),
        i(0, "pass"),
      }
    )
  ),
}
