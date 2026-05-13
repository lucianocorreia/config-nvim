-- ⌨️ Configuração de Keymaps
-- Este arquivo contém todos os mapeamentos de teclas

local function map(mode, lhs, rhs, desc, opts)
  vim.keymap.set(mode, lhs, rhs, vim.tbl_extend('force', { desc = desc }, opts or {}))
end

local core = {
  { 'n', '<Esc>', '<cmd>nohlsearch<CR>', 'Clear search highlight' },
  { 'i', 'jj', '<ESC>', 'Exit insert mode with jj' },
  { 't', '<Esc><Esc>', '<C-\\><C-n>', 'Exit terminal mode' },
  { 'n', '<C-d>', '<C-d>zz', 'Move [D]own' },
  { 'n', '<C-u>', '<C-u>zz', 'Move [U]p' },
  { 'n', 'n', 'nzzzv', 'Next search result (centered)' },
  { 'n', 'N', 'Nzzzv', 'Previous search result (centered)' },
  { 'n', 'G', 'Gzz', 'Go to end of file (centered)' },
  { 'v', 'J', ":m '>+1<CR>gv=gv", 'Move selection down' },
  { 'v', 'K', ":m '<-2<CR>gv=gv", 'Move selection up' },
  { 'v', '<', '<gv', 'Indent left (keep selection)', { silent = true } },
  { 'v', '>', '>gv', 'Indent right (keep selection)', { silent = true } },
  { 'n', '<leader>rp', ':%s/\\<<C-r><C-w>\\>//gI<Left><Left><Left>', 'Replace word under cursor' },
  { 'v', '<C-f>', ':fold<CR>', 'Create fold', { silent = true } },
  { 'n', '<C-f>', '<Cmd>foldopen<CR>', 'Open fold', { silent = true } },
  { 'n', '<leader>zr', '<cmd>edit!<cr>', 'Reload arquivo atual' },
  { 'n', '<leader>Q', '<cmd>qa!<cr>', 'Quit Neovim forcefully' },
}

local diagnostics = {
  { 'n', '<leader>qq', vim.diagnostic.setloclist, 'Open diagnostic [Q]uickfix list' },
  { 'n', '<leader>qw', vim.lsp.buf.workspace_diagnostics, 'Open [W]orkspace diagnostics' },
  { 'n', 'gl', vim.diagnostic.open_float, 'Show diagnostic in float window' },
  { 'n', '[d', vim.diagnostic.goto_prev, 'Go to previous diagnostic' },
  { 'n', ']d', vim.diagnostic.goto_next, 'Go to next diagnostic' },
}

local windows = {
  { 'n', '<leader>vs', '<Cmd>vsplit<CR>', 'Vertical [S]plit window' },
  { 'n', '<leader>hs', '<Cmd>split<CR>', 'Horizontal [S]plit window' },
  { 'n', '<C-h>', '<C-w><C-h>', 'Move focus to the left window' },
  { 'n', '<C-l>', '<C-w><C-l>', 'Move focus to the right window' },
  { 'n', '<C-j>', '<C-w><C-j>', 'Move focus to the lower window' },
  { 'n', '<C-k>', '<C-w><C-k>', 'Move focus to the upper window' },
  { 'n', '<C-L>', '<C-W><C-L>', 'Move to the [L]eft window' },
  { 'n', '<C-H>', '<C-W><C-H>', 'Move to the [H]ight window' },
  { 'n', '<C-K>', '<C-W><C-K>', 'Move to the [K]ight window' },
  { 'n', '<C-J>', '<C-W><C-J>', 'Move to the [J]ight window' },
  { 'n', 'H', '2<C-W>>', 'Resize window horizontally +' },
  { 'n', 'L', '2<C-W><', 'Resize window horizontally -' },
}

local buffers = {
  { 'n', '<leader>bn', '<Cmd>bn<CR>', '[B]uffer [N]ext' },
  { 'n', '<leader>bp', '<Cmd>bp<CR>', '[B]uffer [P]revious' },
}

local editing = {
  { 'n', '<leader>P', '"*p', 'Paste from system clipboard' },
  { 'n', '<leader>p', 'viwP', 'Paste over word', { silent = true } },
  { 'n', '<leader>y', 'viwy', 'Copy word to clipboard' },
  { { 'n', 'v' }, '<leader>d', '"_d', '[D]elete without yanking' },
  {
    'n',
    '<leader>w',
    function()
      vim.cmd 'write'
      vim.notify('Saved ' .. vim.fn.expand '%:t', vim.log.levels.INFO)
    end,
    '[W]rite/Save file',
  },
}

local funcs = require 'funcs'
local laravel = require 'corr3ia.laravel'
local bookmarks = require 'corr3ia.bookmarks'

local custom = {
  { 'n', '<leader>lj', funcs.log_variable_json, 'Log PHP variable with json_encode', { noremap = true } },
  { 'n', '<leader>ll', funcs.log_variable, 'Log PHP variable', { noremap = true } },
  { 'n', '<leader>ld', funcs.insert_data_get, "Insert data_get($, '')" },
  { 'n', '<leader>lc', laravel.clear_cache, 'Laravel: config:cache' },
  { 'n', '<leader>lo', laravel.optimize_clear, 'Laravel: optimize:clear' },
  { 'n', '<leader>lt', laravel.tinker, 'Laravel: tinker' },
  { 'n', '<leader>lm', laravel.create_migration_klingo, 'Laravel: Criar migration klingo' },
  { 'n', '<leader>mm', bookmarks.toggle, 'Bookmark: toggle linha' },
  { 'n', '<leader>mn', bookmarks.next, 'Bookmark: próximo' },
  { 'n', '<leader>mp', bookmarks.prev, 'Bookmark: anterior' },
  { 'n', '<leader>ml', bookmarks.list_qf, 'Bookmark: listar (quickfix)' },
  { 'n', '<leader>mc', bookmarks.clear_buffer, 'Bookmark: limpar buffer' },
}

for _, group in ipairs({ core, diagnostics, windows, buffers, editing, custom }) do
  for _, item in ipairs(group) do
    map(item[1], item[2], item[3], item[4], item[5])
  end
end

require('config.plugin-keymaps').setup(map)
