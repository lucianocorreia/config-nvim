-- ⚡ Configuração Principal do Neovim
-- Este é o arquivo de entrada principal que carrega todos os módulos organizados

-- 📁 Carregar configurações básicas
require('config.options')  -- Opções e configurações do vim
require('config.keymaps')  -- Mapeamentos de teclas
require('config.autocmds') -- Autocommands e eventos
require('config.commands') -- Comandos customizados

-- 🎨 Desabilitar semantic tokens do Roslyn (evita flickering)
require('corr3ia.disable-semantic-tokens')

-- � Bootstrap do Lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { import = 'custom.plugins' },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- 🔧 Carregar configuração do LSP (após plugins)
require('config.lsp')
-- require('config.copilot-lsp') -- Copilot LSP para NES - DESABILITADO (NES não funcionou)
