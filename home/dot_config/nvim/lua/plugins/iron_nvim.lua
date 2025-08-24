-- --------------------------------------------------------------------
--  Filename: ~/.config/nvim/lua/plugins/iron_nvim.lua
--  iron.nvim Docs: https://github.com/Vigemus/iron.nvim
-- --------------------------------------------------------------------

return {
  {
    "Vigemus/iron.nvim",
    ft = { "python" },
    config = function()
      local iron = require("iron.core")
      local view = require("iron.view")
      local common = require("iron.fts.common")

      iron.setup({
        config = {
          scratch_repl = true,
          ignore_blank_lines = true,
          repl_open_cmd = view.split.vertical.botright(80),
          repl_definition = {
            python = {
              command = { "ipython" },
              format = common.bracketed_paste_python,
              block_dividers = { "# %%", "#%%" },
            },
          },
          repl_filetype = function(bufnr, ft)
            return ft
          end,
        },
        keymaps = {
          send_motion = "<leader>rc",
          visual_send = "<leader>rc",
          send_file = "<leader>rf",
          send_line = "<leader>rl",
          send_until_cursor = "<leader>ru",
          send_mark = "<leader>rm",
          mark_motion = "<leader>mc",
          mark_visual = "<leader>mc",
          remove_mark = "<leader>md",
          cr = "<leader>r<CR>",
          interrupt = "<leader>rs",
          exit = "<leader>rq",
          clear = "<leader>cl",
        },
        highlight = {
          italic = true,
        },
      })
    end,
  },
}
