-- --------------------------------------------------------------------
--  Filename: ~/dotfiles/nvim/init.lua
--  Description: Main bootstrap and environment-specific config
-- --------------------------------------------------------------------

if vim.g.vscode then
  require("config.lazy")

  -- Mode-aware cursor highlighting via VSCodeNotify (optional)
  vim.api.nvim_exec(
    [[
    function! SetCursorLineNrColorInsert(mode)
      if a:mode == "i"
        call VSCodeNotify('nvim-theme.insert')
      elseif a:mode == "r"
        call VSCodeNotify('nvim-theme.replace')
      endif
    endfunction

    augroup CursorLineNrColorSwap
      autocmd!
      autocmd ModeChanged *:[vV\x16]* call VSCodeNotify('nvim-theme.visual')
      autocmd ModeChanged *:[R]* call VSCodeNotify('nvim-theme.replace')
      autocmd InsertEnter * call SetCursorLineNrColorInsert(v:insertmode)
      autocmd InsertLeave * call VSCodeNotify('nvim-theme.normal')
      autocmd CursorHold * call VSCodeNotify('nvim-theme.normal')
    augroup END
    ]],
    false
  )

else
  require("config.lazy")
end
