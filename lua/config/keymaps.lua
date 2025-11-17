-- ⌨️ Configuração de Keymaps
-- Este arquivo contém todos os mapeamentos de teclas

-- 🚫 Escape e Limpeza
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
vim.keymap.set('i', 'jj', '<ESC>', { desc = 'Exit insert mode with jj' })

-- 🏥 Diagnósticos
vim.keymap.set('n', '<leader>qq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = 'Show diagnostic in float window' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })

-- 💻 Terminal
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- 🪟 Navegação entre janelas
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Navegação alternativa (duplicada, pode remover se preferir)
vim.keymap.set('n', '<C-L>', '<C-W><C-L>', { desc = 'Move to the [L]eft window' })
vim.keymap.set('n', '<C-H>', '<C-W><C-H>', { desc = 'Move to the [H]ight window' })
vim.keymap.set('n', '<C-K>', '<C-W><C-K>', { desc = 'Move to the [K]ight window' })
vim.keymap.set('n', '<C-J>', '<C-W><C-J>', { desc = 'Move to the [J]ight window' })

-- 🏃 Movimento de scroll centralizado
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Move [D]own' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Move [U]p' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result (centered)' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous search result (centered)' })

-- 📤 Movimento de linhas (Visual mode)
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- ⬅️➡️ Indentação (Visual mode)
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left (keep selection)', silent = true })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right (keep selection)', silent = true })

-- 📏 Redimensionar janelas
vim.keymap.set('n', 'H', '2<C-W>>', { desc = 'Resize window horizontally +' })
vim.keymap.set('n', 'L', '2<C-W><', { desc = 'Resize window horizontally -' })

-- 📋 Clipboard e Cópia
vim.keymap.set('n', '<leader>P', '"*p', { desc = 'Paste from system clipboard' })
vim.keymap.set('n', '<leader>p', 'viwP', { desc = 'Paste over word', silent = true })
vim.keymap.set('n', '<leader>y', 'viwy', { desc = 'Copy word to clipboard' })

-- 🔄 Substituição
vim.keymap.set('n', '<leader>rp', ':%s/\\<<C-r><C-w>\\>//gI<Left><Left><Left>', { desc = 'Replace word under cursor' })

-- 💾 Salvar arquivo
vim.keymap.set('n', '<leader>ww', function()
  vim.cmd 'write'
  require('fidget').notify('✓ saved', vim.log.levels.INFO, { annote = vim.fn.expand '%:t', key = 'save' })
end, { desc = '[W]rite/Save file' })

-- 📁 Folding
vim.keymap.set('v', '<C-f>', ':fold<CR>', { desc = 'Create fold', silent = true })
vim.keymap.set('n', '<C-f>', '<Cmd>foldopen<CR>', { desc = 'Open fold', silent = true })

-- 📄 Buffers
vim.keymap.set('n', '<leader>bn', '<Cmd>bn<CR>', { desc = '[B]uffer [N]ext' })
vim.keymap.set('n', '<leader>bp', '<Cmd>bp<CR>', { desc = '[B]uffer [P]revious' })

-- 🔧 Custom Functions (PHP/Laravel helpers)
vim.keymap.set('n', '<leader>lj', require('funcs').log_variable_json, { desc = 'Log PHP variable with json_encode', noremap = true })
vim.keymap.set('n', '<leader>ll', require('funcs').log_variable, { desc = 'Log PHP variable', noremap = true })
vim.keymap.set('n', '<leader>ld', require('funcs').insert_data_get, { desc = "Insert data_get($, '')" })

-- 🚀 Laravel Commands
vim.keymap.set('n', '<leader>lc', function()
  require('corr3ia.laravel').clear_cache()
end, { desc = 'Laravel: config:cache' })

vim.keymap.set('n', '<leader>lo', function()
  require('corr3ia.laravel').optimize_clear()
end, { desc = 'Laravel: optimize:clear' })

vim.keymap.set('n', '<leader>lt', function()
  require('corr3ia.laravel').tinker()
end, { desc = 'Laravel: tinker' })

vim.keymap.set('n', '<leader>lm', function()
  require('corr3ia.laravel').create_migration_klingo()
end, { desc = 'Laravel: Criar migration klingo' })

-- ✅ TODO Commands
vim.keymap.set('n', '<leader>td', function()
  require('corr3ia.todo').open()
end, { desc = 'Corr3ia-todo: Abrir TODO list' })

vim.keymap.set('n', '<leader>tt', function()
  require('corr3ia.todo').toggle()
end, { desc = 'Corr3ia-todo: Toggle TODO list' })

vim.keymap.set('n', '<leader>ta', function()
  require('corr3ia.todo').add()
end, { desc = 'Corr3ia-todo: Add TODO' })

vim.keymap.set('n', '<leader>th', function()
  require('corr3ia.todo').header()
end, { desc = 'Corr3ia-todo: Add Section' })

-- 🤖 GitHub Copilot CLI - 3 modos de uso

-- 1️⃣ Abrir Copilot CLI puro (sem contexto)
vim.keymap.set('n', '<leader>zc', function()
  vim.cmd 'vsplit'
  vim.cmd 'terminal copilot'
  vim.cmd 'startinsert'
end, { desc = 'Copilot CLI: Abrir sem contexto' })

-- 2️⃣ Abrir com contexto do arquivo atual
vim.keymap.set('n', '<leader>zh', function()
  local filepath = vim.fn.expand '%:p'
  local filename = vim.fn.expand '%:t'
  local filetype = vim.bo.filetype

  vim.cmd 'vsplit'
  vim.cmd('terminal copilot --add-dir ' .. vim.fn.getcwd())

  if filepath ~= '' then
    vim.defer_fn(function()
      local prompt = string.format('Contexto: arquivo %s (%s)\n\nComo posso ajudar?', filename, filetype)
      vim.fn.chansend(vim.b.terminal_job_id, prompt .. '\n')
    end, 1000)
  end

  vim.cmd 'startinsert'
end, { desc = 'Copilot CLI: Com arquivo atual' })

-- 3️⃣ Abrir com arquivo + linhas selecionadas
vim.keymap.set('x', '<leader>zh', function()
  -- Pegar seleção ANTES de sair do modo visual
  local start_line = vim.fn.line 'v'
  local end_line = vim.fn.line '.'

  -- Garantir que start_line é menor que end_line
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  local filepath = vim.fn.expand '%:p'

  -- Sair do modo visual
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)

  vim.schedule(function()
    vim.cmd 'vsplit'
    vim.cmd('terminal copilot --add-dir ' .. vim.fn.getcwd())

    vim.defer_fn(function()
      local prompt = string.format('Contexto: arquivo %s (linhas %d-%d)\n\nComo posso ajudar?', filepath, start_line, end_line)
      vim.fn.chansend(vim.b.terminal_job_id, prompt .. '\n')
    end, 1000)

    vim.cmd 'startinsert'
  end)
end, { desc = 'Copilot CLI: Com arquivo e linhas selecionadas' })

-- Atalho rápido para reload manual do arquivo
vim.keymap.set('n', '<leader>zr', '<cmd>edit!<cr>', { desc = 'Reload arquivo atual' })

-- 🎨 Melhorar cursor e TODAS as cores do terminal para melhor contraste
vim.api.nvim_create_autocmd('TermOpen', {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = 'no'

    -- Cursor bem visível
    vim.cmd 'highlight! TermCursor guifg=#2D353B guibg=#A7C080'
    vim.cmd 'highlight! TermCursorNC guifg=#2D353B guibg=#859289'

    -- Forçar TODAS as cores ANSI para serem mais escuras/contrastadas
    vim.b.terminal_color_0 = '#2D353B' -- black
    vim.b.terminal_color_1 = '#E67E80' -- red
    vim.b.terminal_color_2 = '#A7C080' -- green
    vim.b.terminal_color_3 = '#DBBC7F' -- yellow
    vim.b.terminal_color_4 = '#7FBBB3' -- blue
    vim.b.terminal_color_5 = '#D699B6' -- magenta
    vim.b.terminal_color_6 = '#83C092' -- cyan
    vim.b.terminal_color_7 = '#FFFFFF' -- white (BRANCO PURO para texto principal)
    vim.b.terminal_color_8 = '#D3C6AA' -- bright black (bege claro ao invés de cinza)
    vim.b.terminal_color_9 = '#E67E80' -- bright red
    vim.b.terminal_color_10 = '#A7C080' -- bright green
    vim.b.terminal_color_11 = '#DBBC7F' -- bright yellow
    vim.b.terminal_color_12 = '#7FBBB3' -- bright blue
    vim.b.terminal_color_13 = '#D699B6' -- bright magenta
    vim.b.terminal_color_14 = '#83C092' -- bright cyan
    vim.b.terminal_color_15 = '#FFFFFF' -- bright white (BRANCO PURO)
  end,
  desc = 'Forçar cores mais escuras no terminal',
})
