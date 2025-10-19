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
-- vim.api.nvim_create_autocmd('BufWritePre', {
--   desc = 'Remove trailing whitespace on save',
--   group = vim.api.nvim_create_augroup('corr3ia-trim-whitespace', { clear = true }),
--   callback = function()
--     -- Salvar posição do cursor
--     local save_cursor = vim.fn.getpos('.')
--     -- Remover trailing spaces
--     vim.cmd([[%s/\s\+$//e]])
--     -- Restaurar posição do cursor
--     vim.fn.setpos('.', save_cursor)
--   end,
-- })

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

-- 🐘 PHP: Configurações específicas e highlight do $
vim.api.nvim_create_autocmd('FileType', {
  desc = 'PHP specific configurations and $ highlighting',
  group = vim.api.nvim_create_augroup('corr3ia-php-config', { clear = true }),
  pattern = 'php',
  callback = function()
    -- Garantir que o highlight do $ seja aplicado
    vim.schedule(function()
      -- Obter a cor das keywords (como public, static)
      local keyword_color = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID('Keyword')), 'fg#')

      -- Se não conseguir pegar a cor do Keyword, usar purple do Everforest
      if keyword_color == '' or keyword_color == -1 then
        keyword_color = '#d699b6' -- Purple do Everforest
      end

      -- Aplicar highlight específico para PHP
      vim.api.nvim_set_hl(0, 'phpVarSelector', {
        fg = keyword_color,
        bold = false
      })

      -- Para treesitter
      vim.api.nvim_set_hl(0, '@variable.builtin.php', {
        fg = keyword_color,
        bold = false
      })

      -- Para syntax highlighting tradicional
      vim.api.nvim_set_hl(0, 'phpIdentifier', {
        fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID('Normal')), 'fg#') or '#d3c6aa'
      })

      print('🐘 PHP highlights aplicados - $ agora tem cor de keyword!')
    end)
  end,
})

-- ⚙️ C#: Configurações específicas para indentação
vim.api.nvim_create_autocmd('FileType', {
  desc = 'C# specific tab and indentation settings',
  group = vim.api.nvim_create_augroup('corr3ia-csharp-config', { clear = true }),
  pattern = 'cs',
  callback = function()
    -- Configurações específicas para C#
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
    vim.opt_local.autoindent = true
    vim.opt_local.smartindent = true
    
    -- Garantir que o C# use 4 espaços consistentemente
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = true
  end,
})
