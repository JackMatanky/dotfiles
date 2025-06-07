-- --------------------------------------------------------------------
--  Filename: ~/dotfiles/nvim/lua/plugins/molten_nvim.lua
--  molten.nvim Docs: https://github.com/benlubas/molten-nvim
-- --------------------------------------------------------------------

return {
  {
    "benlubas/molten-nvim",
    version = "*",
    build = ":UpdateRemotePlugins",
    dependencies = { "3rd/image.nvim" },
    ft = { "python" },

    -- >>> Global Options <<<
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = false
      vim.g.molten_virt_text_output = false
      vim.g.molten_virt_lines_off_by_default = true
    end,

    -- >>> Plugin Configuration <<<
    config = function()
      local keymap = vim.keymap.set

      -- >>> Kernel Control <<<
      keymap(
        "n",
        "<leader>mi",
        ":MoltenInit python3<CR>",
        { desc = "Molten: Init Python Kernel" }
      )
      keymap(
        "n",
        "<leader>mr",
        ":MoltenRestart<CR>",
        { desc = "Molten: Restart Kernel" }
      )

      -- >>> Code Evaluation <<<
      keymap(
        "n",
        "<leader>ml",
        ":MoltenEvaluateLine<CR>",
        { desc = "Molten: Eval Line" }
      )
      keymap(
        "v",
        "<leader>me",
        ":<C-u>MoltenEvaluateVisual<CR>",
        { desc = "Molten: Eval Selection" }
      )
      keymap(
        "n",
        "<leader>mc",
        ":MoltenEvaluateCellMarker<CR>",
        { desc = "Molten: Eval #%% Cell" }
      )

      -- >>> Output Handling <<<
      keymap(
        "n",
        "<leader>mo",
        ":MoltenEnterOutput<CR>",
        { desc = "Molten: Focus Output" }
      )

      -- >>> Custom Cell Evaluation Command <<<
      vim.api.nvim_create_user_command("MoltenEvaluateCellMarker", function()
        local start = vim.fn.search("# %%", "bnW")
        local finish = vim.fn.search("# %%", "nW")

        if start == 0 then
          start = 1
        end
        if finish == 0 then
          finish = vim.fn.line("$") + 1
        end

        vim.cmd(
          string.format("%d,%dMoltenEvaluateRange", start + 1, finish - 1)
        )
      end, {})

      -- >>> Safe Auto-Init on Python FileType <<<
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function()
          vim.schedule(function()
            if vim.fn.exists(":MoltenInit") == 2 then
              vim.cmd("MoltenInit python3")
            end
          end)
        end,
      })
    end,
  },
}
