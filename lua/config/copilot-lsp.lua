-- 🤖 Configuração do Copilot LSP para Next Edit Suggestions (NES)
-- IMPORTANTE: Este LSP é SEPARADO do copilot.lua (inline suggestions)
-- copilot.lua = inline completions | Copilot LSP = NES (refatorações grandes)

local copilot_server = vim.fn.stdpath('data') .. '/lazy/copilot.lua/copilot/js/language-server.js'

if vim.fn.filereadable(copilot_server) == 0 then
  vim.notify('Copilot Language Server não encontrado', vim.log.levels.WARN)
  return
end

-- NÃO usar autocmd para attach, deixar o sidekick gerenciar
-- Apenas configurar o LSP
vim.lsp.config('copilot', {
  cmd = { 'node', copilot_server, '--stdio' },
  filetypes = { '*' },
  root_markers = { '.git' },
  settings = {},
  init_options = {
    editorInfo = {
      name = 'Neovim',
      version = vim.version().major .. '.' .. vim.version().minor .. '.' .. vim.version().patch,
    },
    editorPluginInfo = {
      name = 'sidekick.nvim',
      version = '1.0.0',
    },
  },
})

-- Habilitar o LSP
vim.lsp.enable('copilot')

