-- ⚡ Configuração Principal do Neovim
-- Este é o arquivo de entrada principal que carrega todos os módulos organizados

-- 📁 Carregar configurações básicas
require('config.options')  -- Opções e configurações do vim
require('config.ui')       -- UI nativa do Neovim 0.12
require('config.keymaps')  -- Mapeamentos de teclas
require('config.autocmds') -- Autocommands e eventos
require('config.commands') -- Comandos customizados

-- 🎨 Desabilitar semantic tokens do Roslyn (evita flickering)
require('corr3ia.disable-semantic-tokens')

-- 📦 Gerenciamento nativo de plugins (Neovim 0.12)
require('config.pack').setup()

-- 🔧 Carregar configuração do LSP (após plugins)
require('config.lsp')
-- require('config.copilot-lsp') -- Copilot LSP para NES - DESABILITADO (NES não funcionou)
