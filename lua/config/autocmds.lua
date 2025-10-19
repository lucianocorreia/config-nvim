-- 🤖 Configuração de Autocommands
-- Este arquivo contém todos os autocommands e eventos automáticos

-- ✨ Highlight no Yank (cópia)
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('corr3ia-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- 📏 Auto-redimensionar janelas quando o Neovim é redimensionado
vim.api.nvim_create_autocmd('VimResized', {
  desc = 'Auto-resize windows when Neovim is resized',
  group = vim.api.nvim_create_augroup('corr3ia-auto-resize', { clear = true }),
  callback = function()
    vim.cmd('wincmd =')
  end,
})

-- 🧹 Remover trailing spaces automaticamente ao salvar
vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Remove trailing whitespace on save',
  group = vim.api.nvim_create_augroup('corr3ia-trim-whitespace', { clear = true }),
  callback = function()
    -- Salvar posição do cursor
    local save_cursor = vim.fn.getpos('.')
    -- Remover trailing spaces
    vim.cmd([[%s/\s\+$//e]])
    -- Restaurar posição do cursor
    vim.fn.setpos('.', save_cursor)
  end,
})

-- 🎯 Entrar automaticamente no modo Insert ao abrir terminal
vim.api.nvim_create_autocmd('TermOpen', {
  desc = 'Enter insert mode when opening terminal',
  group = vim.api.nvim_create_augroup('corr3ia-terminal-insert', { clear = true }),
  callback = function()
    vim.cmd('startinsert')
  end,
})

-- 📁 Abrir no último local editado
vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Go to last position when opening buffer',
  group = vim.api.nvim_create_augroup('corr3ia-last-position', { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
      vim.cmd('normal! zz')
    end
  end,
})
