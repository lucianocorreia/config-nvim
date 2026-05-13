-- 🤖 Configuração de Autocommands
-- Este arquivo contém todos os autocommands e eventos automáticos

-- 💬 Desabilitar continuação automática de comentários
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Disable automatic comment continuation',
  group = vim.api.nvim_create_augroup('corr3ia-no-auto-comment', { clear = true }),
  pattern = '*',
  callback = function()
    vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })
  end,
})

-- 🔇 Filtrar notificações específicas do Roslyn
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'cs',
  group = vim.api.nvim_create_augroup('corr3ia-roslyn-silent', { clear = true }),
  callback = function()
    local original_notify = vim.notify
    vim.notify = function(msg, level, opts)
      if type(msg) == 'string' and msg:match('Multiple potential target files') then
        return
      end
      return original_notify(msg, level, opts)
    end
  end,
})

-- ✨ Highlight no Yank (cópia)
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('corr3ia-highlight-yank', { clear = true }),
  callback = function()
    -- Define custom yank highlight
    vim.api.nvim_set_hl(0, 'YankHighlight', {
      bg = '#a7c080',  -- Everforest green
      fg = '#2d353b',  -- Everforest background for contrast
    })
    
    vim.highlight.on_yank({
      higroup = 'YankHighlight',
      timeout = 200,
    })
  end,
})

-- 📏 Auto-redimensionar janelas quando o Neovim é redimensionado
vim.api.nvim_create_autocmd('VimResized', {
  desc = 'Auto-resize windows when Neovim is resized',
  group = vim.api.nvim_create_augroup('corr3ia-auto-resize', { clear = true }),
  callback = function()
    vim.cmd 'wincmd ='
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
    vim.cmd 'startinsert'
  end,
})

vim.api.nvim_create_autocmd('TermOpen', {
  desc = 'Forçar cores mais escuras no terminal',
  group = vim.api.nvim_create_augroup('corr3ia-terminal-colors', { clear = true }),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = 'no'

    vim.cmd 'highlight! TermCursor guifg=#2D353B guibg=#A7C080'
    vim.cmd 'highlight! TermCursorNC guifg=#2D353B guibg=#859289'

    vim.b.terminal_color_0 = '#2D353B'
    vim.b.terminal_color_1 = '#E67E80'
    vim.b.terminal_color_2 = '#A7C080'
    vim.b.terminal_color_3 = '#DBBC7F'
    vim.b.terminal_color_4 = '#7FBBB3'
    vim.b.terminal_color_5 = '#D699B6'
    vim.b.terminal_color_6 = '#83C092'
    vim.b.terminal_color_7 = '#FFFFFF'
    vim.b.terminal_color_8 = '#D3C6AA'
    vim.b.terminal_color_9 = '#E67E80'
    vim.b.terminal_color_10 = '#A7C080'
    vim.b.terminal_color_11 = '#DBBC7F'
    vim.b.terminal_color_12 = '#7FBBB3'
    vim.b.terminal_color_13 = '#D699B6'
    vim.b.terminal_color_14 = '#83C092'
    vim.b.terminal_color_15 = '#FFFFFF'
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
      vim.cmd 'normal! zz'
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
      local keyword_color = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID 'Keyword'), 'fg#')

      -- Se não conseguir pegar a cor do Keyword, usar purple do Everforest
      if keyword_color == '' or keyword_color == -1 then
        keyword_color = '#d699b6' -- Purple do Everforest
      end

      -- Aplicar highlight específico para PHP
      vim.api.nvim_set_hl(0, 'phpVarSelector', {
        fg = keyword_color,
        bold = false,
      })

      -- Para treesitter
      vim.api.nvim_set_hl(0, '@variable.builtin.php', {
        fg = keyword_color,
        bold = false,
      })

      -- Para syntax highlighting tradicional
      vim.api.nvim_set_hl(0, 'phpIdentifier', {
        fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID 'Normal'), 'fg#') or '#d3c6aa',
      })
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

    -- Remover itálicos de elementos específicos do C#
    vim.schedule(function()
      -- Treesitter highlights para C#
      vim.api.nvim_set_hl(0, '@type.cs', { fg = '#7fbbb3', italic = false })
      vim.api.nvim_set_hl(0, '@type.builtin.cs', { fg = '#7fbbb3', italic = false })
      vim.api.nvim_set_hl(0, '@namespace.cs', { fg = '#dbbc7f', italic = false })
      vim.api.nvim_set_hl(0, '@property.cs', { fg = '#d3c6aa', italic = false })
      vim.api.nvim_set_hl(0, '@method.cs', { fg = '#a7c080', italic = false })
      vim.api.nvim_set_hl(0, '@keyword.cs', { fg = '#d699b6', italic = false })
      vim.api.nvim_set_hl(0, '@attribute.cs', { fg = '#e69875', italic = false })

      -- Syntax highlighting tradicional
      vim.api.nvim_set_hl(0, 'csType', { fg = '#7fbbb3', italic = false })
      vim.api.nvim_set_hl(0, 'csClass', { fg = '#7fbbb3', italic = false })
      vim.api.nvim_set_hl(0, 'csClassType', { fg = '#7fbbb3', italic = false })
      vim.api.nvim_set_hl(0, 'csStorage', { fg = '#d699b6', italic = false })
    end)
  end,
})

-- 🎮 GDScript: Configurações específicas para Godot
vim.api.nvim_create_autocmd('FileType', {
  desc = 'GDScript specific tab settings (uses real tabs like Godot)',
  group = vim.api.nvim_create_augroup('corr3ia-gdscript-config', { clear = true }),
  pattern = 'gdscript',
  callback = function()
    -- Godot usa tabs reais (não espaços)
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = false -- Usar tabs reais
    vim.opt_local.autoindent = true
    vim.opt_local.smartindent = true
    
    -- Mostrar caracteres de tab
    vim.opt_local.list = true
    vim.opt_local.listchars = { tab = '→ ', trail = '·', nbsp = '␣' }
  end,
})
