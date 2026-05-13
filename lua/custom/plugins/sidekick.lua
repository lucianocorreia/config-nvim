-- 🤖 Sidekick.nvim - AI CLI Integration
-- NES (Next Edit Suggestions) desabilitado - não funcionou neste setup
return {
  'folke/sidekick.nvim',
  lazy = true,
  dependencies = {
    'folke/snacks.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    -- ❌ NES DESABILITADO - não funcionou apesar do LSP conectado
    -- Para reativar no futuro: mude enabled = true e descomente keybinds
    nes = {
      enabled = false,
      -- auto_trigger = true,
      -- debounce = 1500,
    },
    -- ✅ AI CLI Integration - FUNCIONANDO
    cli = {
      enabled = true,
      mux = {
        enabled = false, -- sem tmux/zellij instalado
      },
      -- 🤖 Ferramentas AI configuradas
      tools = {
        -- Gemini via aichat (GRATUITO!)
        gemini = {
          cmd = { 'aichat', '--model', 'gemini:gemini-2.0-flash' },
          keys = {
            submit = { '<C-s>', function(t) t:send('\n') end },
          },
        },
        -- Gemini Pro (modelo mais potente, ainda gratuito)
        ['gemini-pro'] = {
          cmd = { 'aichat', '--model', 'gemini:gemini-2.5-pro' },
          keys = {
            submit = { '<C-s>', function(t) t:send('\n') end },
          },
        },
      },
      prompts = {
        refactor = 'Por favor, refatore {this} para ser mais limpo e manutenível',
        security = 'Analise {file} procurando vulnerabilidades de segurança',
        tests = 'Crie testes unitários para {this}',
        explain = 'Explique o que {this} faz de forma simples',
        optimize = 'Otimize a performance de {this}',
        fix = 'Corrija os erros/bugs em {this}',
        docs = 'Gere documentação para {this}',
      },
    },
  },
}
