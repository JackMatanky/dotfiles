-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/python/control_flow.lua
-- Description: Contains snippets for control flow statements like if, for,
--              while, and match/case.
-- ----------------------------------------------------------------------------

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- if statement
  s(
    { trig = "if", name = "if", dscr = "if statement" },
    fmt(
      [[
if {}:
    {}
]],
      { i(1, "condition"), i(0, "pass") }
    )
  ),

  -- elif statement
  s(
    { trig = "elif", name = "elif", dscr = "elif statement" },
    fmt(
      [[
elif {}:
    {}
]],
      { i(1, "condition"), i(0, "pass") }
    )
  ),

  -- else statement
  s(
    { trig = "else", name = "else", dscr = "else statement" },
    fmt(
      [[
else:
    {}
]],
      { i(0, "pass") }
    )
  ),

  -- if/else block
  s(
    { trig = "ifelse", name = "if/else", dscr = "if statement with else" },
    fmt(
      [[
if {}:
    {}
else:
    {}
]],
      { i(1, "condition"), i(2, "action"), i(0) }
    )
  ),

  -- for loop (dynamic choice)
  s({
    trig = "for",
    name = "for loop (dynamic)",
    dscr = "Creates a for loop, with a choice for a standard iterable or range().",
  }, {
    t("for "),
    i(1, "item"),
    t(" in "),
    c(2, {
      i(1, "iterable"),
      sn(nil, { t("range("), i(1, "10"), t(")") }),
    }),
    t(":\n"),
    fmt(
      [[
    {}
]],
      { i(0, "pass") }
    ),
  }),

  -- while / do-while (dynamic)
  s({
    trig = "while",
    name = "while / do-while (dynamic)",
    dscr = 'Creates a while loop. If condition is "True", becomes a do-while structure.',
  }, {
    t("while "),
    i(1, "condition"),
    t(":\n"),
    d(2, function(args)
      local cond = args[1][1] or ""
      if cond == "True" then
        return fmt(
          [[
    {}
    if not ({}) then
        break
    {}
]],
          { i(1, "action"), i(2, "condition"), i(0) }
        )
      else
        return fmt(
          [[
    {}
]],
          { i(0, "pass") }
        )
      end
    end, { 1 }),
  }),

  -- match/case
  s(
    { trig = "match", name = "match/case", dscr = "match/case statements" },
    fmt(
      [[
match {}:
    case {}:
        {}
]],
      { i(1, "subject"), i(2, "pattern"), i(0, "pass") }
    )
  ),

  -- single case
  s(
    { trig = "case", name = "case", dscr = "case block" },
    fmt(
      [[
case {}:
    {}
]],
      { i(1, "pattern"), i(0, "pass") }
    )
  ),

  -- wildcard case
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
      { i(0, "pass") }
    )
  ),
}
