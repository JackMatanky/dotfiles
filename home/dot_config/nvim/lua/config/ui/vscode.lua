-- ----------------------------------------------------------------------------
--  Filename: ~/.config/nvim/lua/config/ui/vscode.lua
--  Description: VSCode-specific theme notifications for UI mode states
--  Source: https://github.com/cStralpt/lazycodium-starter-template/blob/main/init.lua
-- ----------------------------------------------------------------------------

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
