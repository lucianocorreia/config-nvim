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
          cmd = { 'aichat', '--model', 'gemini:gemini-1.5-flash' },
          keys = {
            submit = { '<C-s>', function(t) t:send('\n') end },
          },
        },
        -- Gemini Pro (modelo mais potente, ainda gratuito)
        ['gemini-pro'] = {
          cmd = { 'aichat', '--model', 'gemini:gemini-1.5-pro' },
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
  keys = {
    -- ❌ NES DESABILITADO - descomente para reativar
    -- {
    --   '<leader>an',
    --   function()
    --     vim.notify('🔍 Buscando Next Edit Suggestions...', vim.log.levels.INFO)
    --     vim.cmd('Sidekick nes update')
    --     vim.defer_fn(function()
    --       local ok, result = pcall(function()
    --         local sidekick = require('sidekick')
    --         return sidekick
    --       end)
    --       if ok then
    --         vim.notify('✅ Comando executado! Verifique o código por diffs/highlights', vim.log.levels.INFO)
    --       else
    --         vim.notify('⚠️  Comando executado, mas status indisponível', vim.log.levels.WARN)
    --       end
    --     end, 1500)
    --   end,
    --   desc = 'Sidekick: Buscar Next Edit Suggestions',
    --   mode = { 'n' },
    -- },
    -- 
    -- -- Ctrl+y para NES (navegação e aplicação)
    -- {
    --   '<C-y>',
    --   function()
    --     if require('sidekick').nes_jump_or_apply() then
    --       return
    --     end
    --     return '<C-y>'
    --   end,
    --   expr = true,
    --   desc = 'Sidekick: Navegar/Aplicar NES',
    --   mode = 'i',
    -- },
    
    -- ✅ AI CLI Terminal - FUNCIONANDO
    {
      '<leader>aa',
      function()
        require('sidekick.cli').toggle()
      end,
      desc = 'Sidekick: Toggle CLI',
      mode = { 'n', 't', 'i', 'x' },
    },
    {
      '<leader>as',
      function()
        require('sidekick.cli').select { filter = { installed = true } }
      end,
      desc = 'Sidekick: Select CLI Tool',
    },
    {
      '<leader>ad',
      function()
        require('sidekick.cli').close()
      end,
      desc = 'Sidekick: Detach CLI Session',
    },
    
    -- Enviar contexto para AI
    {
      '<leader>at',
      function()
        require('sidekick.cli').send { msg = '{this}' }
      end,
      mode = { 'x', 'n' },
      desc = 'Sidekick: Send This',
    },
    {
      '<leader>af',
      function()
        require('sidekick.cli').send { msg = '{file}' }
      end,
      desc = 'Sidekick: Send File',
    },
    {
      '<leader>av',
      function()
        require('sidekick.cli').send { msg = '{selection}' }
      end,
      mode = { 'x' },
      desc = 'Sidekick: Send Visual Selection',
    },
    
    -- Prompts
    {
      '<leader>ap',
      function()
        require('sidekick.cli').prompt()
      end,
      mode = { 'n', 'x' },
      desc = 'Sidekick: Select Prompt',
    },
    
    -- Atalho direto para Gemini
    {
      '<leader>ag',
      function()
        require('sidekick.cli').toggle({ name = 'gemini', focus = true })
      end,
      desc = 'Sidekick: Gemini (Flash)',
    },
  },
}
