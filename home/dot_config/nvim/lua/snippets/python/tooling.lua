-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/python/tooling.lua
-- Description: Contains snippets for development tooling, like linter
--              directives and REPL cell markers.
-- ----------------------------------------------------------------------------

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- ------------------ LINTER & FORMATTER ------------------ --
  s({
    trig = "pyignore",
    name = "Pyright Ignore Rule Comment",
    dscr = "Insert a comment to ignore a specific Pyright diagnostic on the current line.",
  }, {
    t("# pyright: ignore["),
    c(1, {
      t("reportAny"),
      t("reportExplicitAny"),
      t("reportUnnecessaryComparison"),
      t("reportUnreachable"),
      t("reportUnknownArgumentType"),
      t("reportUnknownParameterType"),
      t("reportUnusedImport"),
      t("reportUnusedParameter"),
    }),
    t("]"),
    i(0),
  }),

  s({
    trig = "ruffignore",
    name = "Ruff Ignore Rule Comment",
    dscr = "Insert a comment to ignore a specific Ruff diagnostic on the current line.",
  }, {
    t("# noqa: "),
    c(1, {
      t("E501"), -- Line too long
      t("F401"), -- Module imported but unused
      t("F403"), -- Star import used
      t("F405"), -- Name may be undefined
      t("F841"), -- Local variable assigned but never used
    }),
    i(0),
  }),

  -- --------------------- JUPYTER CELLS -------------------- --
  -- This single snippet handles both code and markdown cells.
  s(
    {
      trig = "jpy",
      name = "py:percent Cell",
      dscr = "Add new py:percent code or markdown cell for interactive REPLs.",
    },
    fmt(
      [[
    # %%{}
    {}
    ]],
      {
        c(1, { t(""), t(" [markdown]") }),
        i(0),
      }
    )
  ),
}
