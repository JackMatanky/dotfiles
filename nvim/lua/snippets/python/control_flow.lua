-- ----------------------------------------------------------------------------
-- Filename: ~/dotfiles/nvim/lua/snippets/python/control_flow.lua
-- Description: Contains snippets for control flow statements like if, for,
--              while, and match/case.
-- ----------------------------------------------------------------------------

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s(
    {
      trig = "if",
      name = "if",
      dscr = "if statement",
    },
    fmt(
      [[
if {}:
    {}
]],
      {
        i(1, "condition"),
        i(0, "pass"),
      }
    )
  ),

  s(
    {
      trig = "elif",
      name = "elif",
      dscr = "elif statement",
    },
    fmt(
      [[
elif {}:
    {}
]],
      {
        i(1, "condition"),
        i(0, "pass"),
      }
    )
  ),

  s(
    {
      trig = "else",
      name = "else",
      dscr = "else statement",
    },
    fmt(
      [[
else:
    {}
]],
      {
        i(0, "pass"),
      }
    )
  ),

  s(
    {
      trig = "ifelse",
      name = "if/else",
      dscr = "if statement with else",
    },
    fmt(
      [[
if {}:
    {}
else:
    {}
]],
      {
        i(1, "condition"),
        i(2, "action"),
        i(0),
      }
    )
  ),

  s({
    trig = "for",
    name = "for loop (dynamic)",
    dscr = "Creates a for loop, with a choice for a standard iterable or range().",
  }, {
    t("for "),
    i(1, "item"),
    t(" in "),
    c(2, {
      i(3, "iterable"),
      s(nil, { t("range("), i(4, "10"), t(")") }),
    }),
    t(":\n    "),
    i(0, "pass"),
  }),

  -- Corrected: Replaced one complex dynamic snippet with two simple, explicit snippets.
  s(
    {
      trig = "while",
      name = "while loop",
      dscr = "Creates a standard while loop.",
    },
    fmt(
      [[
while {}:
    {}
]],
      {
        i(1, "condition"),
        i(0, "pass"),
      }
    )
  ),

  s(
    {
      trig = "whilet",
      name = "while True loop (do-while)",
      dscr = "Creates a `while True:` loop for a do-while pattern.",
    },
    fmt(
      [[
while True:
    {}
    if not ({}):
        break
{}
]],
      {
        i(1, "action"),
        i(2, "exit_condition"),
        i(0),
      }
    )
  ),

  s(
    {
      trig = "match",
      name = "match/case",
      dscr = "match/case statements",
    },
    fmt(
      [[
match {}:
    case {}:
        {}
]],
      {
        i(1, "subject"),
        i(2, "pattern"),
        i(0, "pass"),
      }
    )
  ),

  s(
    {
      trig = "case",
      name = "case",
      dscr = "case block",
    },
    fmt(
      [[
case {}:
    {}
]],
      {
        i(1, "pattern"),
        i(0, "pass"),
      }
    )
  ),

  s(
    {
      trig = "casew",
      name = "case wildcard",
      dscr = "case wildcard block if other cases fail",
    },
    fmt(
      [[
case _:
    {}
]],
      {
        i(0, "pass"),
      }
    )
  ),
}
