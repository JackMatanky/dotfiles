-- ----------------------------------------------------------------------------
-- Filename: ~/.config/nvim/lua/snippets/python/functions.lua
-- Description: Contains snippets for defining functions and lambdas.
-- ----------------------------------------------------------------------------

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt

local utils = require("snippets.python.utils")

-- Helper to create a choice node for common Python types.
-- It defaults to the type parsed from the function signature.
local function type_choice(default_type)
  return c(1, {
    t(default_type or "any"),
    t("str"),
    t("int"),
    t("float"),
    t("bool"),
    t("list"),
    t("dict"),
    t("tuple"),
    t("Any"),
  })
end

return {
  s(
    {
      trig = "def",
      name = "Function with Dynamic Docstring",
      dscr = "Function definition that generates a docstring from its arguments.",
    },
    fmt(
      [[
  def {}({}) -> {}:
      """{}
  {}
      Returns:
          {}: {}
      """
      {}
  ]],
      {
        i(1, "function_name"),
        -- Use a neutral, empty placeholder for parameters.
        i(2, "parameters"),
        c(3, { t("None"), t("str"), t("int") }),
        i(4, "One-line summary."),
        d(5, function(args)
          local parsed_args = utils.get_args_from_signature(args[1][1] or "")
          if #parsed_args == 0 then
            return s(nil, {})
          end

          local nodes = { t("\n    Args:\n") }
          for _, arg in ipairs(parsed_args) do
            table.insert(
              nodes,
              -- Use a choice node for the type, defaulting to the parsed type.
              fmt("        {} ({}): {}\n", {
                t(arg.name),
                type_choice(arg.type),
                i(2, "Description."),
              })
            )
          end
          return s(nil, nodes)
        end, { 2 }),
        i(6, "None"),
        i(7, "Description."),
        i(0, "pass"),
      }
    )
  ),

  s(
    {
      trig = "adef",
      name = "async Function with Dynamic Docstring",
      dscr = "Asynchronous function definition that generates a docstring from its arguments.",
    },
    fmt(
      [[
  async def {}({}) -> {}:
      """{}
  {}
      Returns:
          {}: {}
      """
      {}
  ]],
      {
        i(1, "function_name"),
        -- Use a neutral, empty placeholder for parameters.
        i(2, "parameters"),
        c(3, { t("None"), t("str"), t("int") }),
        i(4, "One-line summary."),
        d(5, function(args)
          local parsed_args = utils.get_args_from_signature(args[1][1] or "")
          if #parsed_args == 0 then
            return s(nil, {})
          end

          local nodes = { t("\n    Args:\n") }
          for _, arg in ipairs(parsed_args) do
            table.insert(
              nodes,
              -- Use a choice node for the type, defaulting to the parsed type.
              fmt("        {} ({}): {}\n", {
                t(arg.name),
                type_choice(arg.type),
                i(2, "Description."),
              })
            )
          end
          return s(nil, nodes)
        end, { 2 }),
        i(6, "None"),
        i(7, "Description."),
        i(0, "pass"),
      }
    )
  ),

  s(
    {
      trig = "lam",
      name = "Lambda Function",
      dscr = "Lambda function",
    },
    fmt("lambda {}: {}", {
      i(1, "args"),
      i(2, "expr"),
    })
  ),
}
