-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/python/comprehensions.lua
-- Description: Contains snippets for list, dictionary, set, and generator
--              comprehensions.
-- ----------------------------------------------------------------------------

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s({
    trig = "lc",
    name = "List Comprehension",
    dscr = "List comprehension with optional condition.",
  }, {
    t("["),
    i(1, "expr"),
    t(" for "),
    i(2, "item"),
    t(" in "),
    i(3, "iterable"),
    c(4, { t(""), t(" if ") }),
    d(5, function(args)
      if #args[1] > 0 then
        return s(nil, { i(1, "condition") })
      else
        return s(nil, {})
      end
    end, { 4 }),
    t("]"),
    i(0),
  }),

  s(
    {
      trig = "lcie",
      name = "List comprehension if else",
      dscr = "List comprehension with conditional if-else.",
    },
    fmt("[{} if {} else {} for {} in {}]{}", {
      i(1, "expr1"),
      i(2, "condition"),
      i(3, "expr2"),
      i(4, "item"),
      i(5, "iterable"),
      i(0),
    })
  ),

  s({
    trig = "dc",
    name = "Dictionary Comprehension",
    dscr = "Dictionary comprehension with optional condition.",
  }, {
    t("{"),
    i(1, "key"),
    t(": "),
    i(2, "value"),
    t(" for "),
    i(3, "k"),
    t(", "),
    i(4, "v"),
    t(" in "),
    i(5, "iterable"),
    c(6, { t(""), t(" if ") }),
    d(7, function(args)
      if #args[1] > 0 then
        return s(nil, { i(1, "condition") })
      else
        return s(nil, {})
      end
    end, { 6 }),
    t("}"),
    i(0),
  }),

  s({
    trig = "sc",
    name = "Set Comprehension",
    dscr = "Set comprehension with optional condition.",
  }, {
    t("{"),
    i(1, "item"),
    t(" for "),
    i(2, "item"),
    t(" in "),
    i(3, "iterable"),
    c(4, { t(""), t(" if ") }),
    d(5, function(args)
      if #args[1] > 0 then
        return s(nil, { i(1, "condition") })
      else
        return s(nil, {})
      end
    end, { 4 }),
    t("}"),
    i(0),
  }),

  s({
    trig = "gc",
    name = "Generator Comprehension",
    dscr = "Generator comprehension with optional condition.",
  }, {
    t("("),
    i(1, "item"),
    t(" for "),
    i(2, "item"),
    t(" in "),
    i(3, "iterable"),
    c(4, { t(""), t(" if ") }),
    d(5, function(args)
      if #args[1] > 0 then
        return s(nil, { i(1, "condition") })
      else
        return s(nil, {})
      end
    end, { 4 }),
    t(")"),
    i(0),
  }),
}
