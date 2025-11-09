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
  vim.cmd('write')
  require('fidget').notify('✓ saved', vim.log.levels.INFO, { annote = vim.fn.expand('%:t'), key = 'save' })
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
