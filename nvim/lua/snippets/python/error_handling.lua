-- ----------------------------------------------------------------------------
-- Filename: ~/dotfiles/nvim/lua/snippets/python/error_handling.lua
-- Description: Contains snippets for error handling using try/except blocks.
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
    trig = "except",
    name = "except block",
    dscr = "except block with optional alias.",
  }, {
    t("except "),
    c(
      1,
      {
        t("Exception"),
        t("ValueError"),
        t("TypeError"),
        t("KeyError"),
        t("IndexError"),
      }
    ),
    c(2, { t(""), t(" as ") }),
    d(3, function(args)
      if #args[1] > 0 then
        return s(nil, { i(1, "err") })
      else
        return s(nil, {})
      end
    end, { 2 }),
    t({ ":", "    " }),
    i(0, "pass"),
  }),

  s({
    trig = "try",
    name = "try block (dynamic)",
    dscr = "A dynamic try block with optional else and finally clauses.",
  }, {
    t("try:"),
    t({ "", "    " }),
    i(1, "pass"),
    t({ "", "except " }),
    c(
      2,
      {
        t("Exception"),
        t("ValueError"),
        t("TypeError"),
        t("KeyError"),
        t("IndexError"),
      }
    ),
    t(" as "),
    i(3, "err"),
    t({ ":", "    " }),
    i(4, "pass"),
    c(5, {
      s(nil, { i(0) }),
      fmt("\n\nelse:\n    {}", { i(0, "pass") }),
      fmt("\n\nfinally:\n    {}", { i(0, "pass") }),
      fmt(
        "\n\nelse:\n    {}\n\nfinally:\n    {}",
        { i(1, "pass"), i(0, "pass") }
      ),
    }),
  }),
}
