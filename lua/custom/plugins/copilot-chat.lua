-- 🤖 Copilot Chat - Configuração limpa e otimizada com Edits
return {
  'CopilotC-Nvim/CopilotChat.nvim',
  enabled = true,
  dependencies = {
    { 'zbirenbaum/copilot.lua' },
    { 'nvim-lua/plenary.nvim', branch = 'master' },
  },
  build = 'make tiktoken',
  opts = {
    -- 🔧 Configurações principais
    debug = false,
    
    -- 💬 Sistema de mensagens
    system_prompt = 'Você é um assistente de programação útil e preciso. Responda sempre em português brasileiro.',
    temperature = 0.1,
    
    -- 📋 Headers personalizados
    headers = {
      user = '## 🧑‍💻 Usuário',
      assistant = '## 🤖 Copilot',
      tool = '## 🔧 Tool',
    },
    
    -- 💾 Histórico
    history_path = vim.fn.stdpath('data') .. '/copilotchat_history',
    
    -- 🪟 Layout da janela
    window = {
      layout = 'vertical',  -- 'vertical', 'horizontal', 'float'
      width = 0.4,          -- 40% da tela para layout vertical
      height = 0.8,         -- 80% da tela para layout float
      border = 'rounded',
      title = '🤖 Copilot Chat',
      zindex = 100,
    },
    
    -- 🎯 Comportamento da interface
    auto_insert_mode = false,  -- Não entrar automaticamente em insert mode
    auto_follow_cursor = false, -- Não seguir o cursor automaticamente
    show_help = true,
    
    -- ⌨️ Mapeamentos dentro do chat
    mappings = {
      complete = {
        insert = '<Tab>',
      },
      close = {
        normal = 'q',
        insert = '<C-c>'
      },
      reset = {
        normal = '<C-l>',
        insert = '<C-l>'
      },
      submit_prompt = {
        normal = '<CR>',
        insert = '<C-s>'
      },
    },
  },
  
  config = function(_, opts)
    local chat = require('CopilotChat')
    
    -- Inicializar o chat
    chat.setup(opts)
    
    -- 📝 Comandos personalizados
    vim.api.nvim_create_user_command('CopilotChatTest', function()
      local chat_loaded, chat_module = pcall(require, 'CopilotChat')
      if chat_loaded then
        print('✅ CopilotChat carregado com sucesso')
        local success, err = pcall(function()
          chat_module.toggle()
        end)
        if success then
          print('✅ CopilotChat funcionando corretamente')
        else
          print('❌ Erro ao executar toggle: ' .. tostring(err))
        end
      else
        print('❌ CopilotChat não carregado: ' .. tostring(chat_module))
      end
    end, { desc = 'Testar se o Copilot Chat está funcionando' })
    
    -- 🔧 Configurar buffer do chat quando aberto
    vim.api.nvim_create_autocmd('BufEnter', {
      pattern = 'copilot-*',
      callback = function(ev)
        vim.opt_local.relativenumber = false
        vim.opt_local.number = false
        vim.opt_local.wrap = true
        
        -- Ir para o final do buffer após resposta
        vim.defer_fn(function()
          if vim.api.nvim_buf_is_valid(ev.buf) then
            local line_count = vim.api.nvim_buf_line_count(ev.buf)
            pcall(vim.api.nvim_win_set_cursor, 0, {line_count, 0})
          end
        end, 100)
      end,
    })
    
    -- 🔧 Após receber resposta, ir para o final
    vim.api.nvim_create_autocmd('User', {
      pattern = 'CopilotChatResponse',
      callback = function()
        -- Encontrar janela do copilot chat
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local bufname = vim.api.nvim_buf_get_name(buf)
          if bufname:match('copilot%-') then
            vim.api.nvim_set_current_win(win)
            local line_count = vim.api.nvim_buf_line_count(buf)
            vim.api.nvim_win_set_cursor(win, {line_count, 0})
            vim.cmd('normal! zb') -- Scroll para mostrar o final
            break
          end
        end
      end,
    })

  end,
  
  -- 🚀 Keymaps lazy-loaded
  keys = {
    -- 🤖 Toggle e Chat Principal
    { '<leader>zh', '<cmd>CopilotChatToggle<cr>', mode = 'n', desc = 'Copilot Chat Toggle' },
    { '<leader>zh', '<cmd>CopilotChatToggle<cr>', mode = 'v', desc = 'Copilot Chat (com seleção)' },

    -- ✏️ Inserir código na linha atual (visual: modificar seleção | normal: inserir após cursor)
    -- Dica: no chat use <C-y> para aplicar diff (visual) ou gy+p para colar (insert)
    { '<leader>zi', function()
        local input = vim.fn.input('Copilot (inserir): ')
        if input ~= '' then
          require('CopilotChat').ask(input, {
            selection = require('CopilotChat.select').line,
          })
        end
      end, mode = 'n', desc = 'Copilot: inserir código na linha atual' },
    { '<leader>zi', function()
        local input = vim.fn.input('Copilot (modificar seleção): ')
        if input ~= '' then
          require('CopilotChat').ask(input, {
            selection = require('CopilotChat.select').visual,
          })
        end
      end, mode = 'v', desc = 'Copilot: modificar seleção' },
    
    -- 💬 Chat rápido com input
    { '<leader>zq', function()
        local input = vim.fn.input('Pergunta para o Copilot: ')
        if input ~= '' then
          vim.cmd('CopilotChat ' .. input)
        end
      end, mode = 'n', desc = 'Copilot Chat Rápido' },
    
    { '<leader>zq', function()
        local input = vim.fn.input('Pergunta sobre seleção: ')
        if input ~= '' then
          vim.cmd('CopilotChat ' .. input)
        end
      end, mode = 'v', desc = 'Copilot Chat Rápido (seleção)' },
    
    -- 🔍 Comandos específicos (funcionam em normal e visual mode)
    { '<leader>ze', '<cmd>CopilotChatExplain<cr>', mode = { 'n', 'v' }, desc = 'Explicar código' },
    { '<leader>zr', '<cmd>CopilotChatReview<cr>', mode = { 'n', 'v' }, desc = 'Revisar código' },
    { '<leader>zf', '<cmd>CopilotChatFix<cr>', mode = { 'n', 'v' }, desc = 'Corrigir código' },
    { '<leader>zo', '<cmd>CopilotChatOptimize<cr>', mode = { 'n', 'v' }, desc = 'Otimizar código' },
    { '<leader>zd', '<cmd>CopilotChatDocs<cr>', mode = { 'n', 'v' }, desc = 'Gerar documentação' },
    { '<leader>zt', '<cmd>CopilotChatTests<cr>', mode = { 'n', 'v' }, desc = 'Gerar testes' },
    
    -- 🎛️ Controle do chat
    { '<leader>zx', '<cmd>CopilotChatReset<cr>', mode = 'n', desc = 'Limpar chat' },
    { '<leader>zT', '<cmd>CopilotChatTest<cr>', mode = 'n', desc = 'Testar Copilot Chat' },
    { '<leader>zm', '<cmd>CopilotChatModels<cr>', mode = 'n', desc = 'Selecionar modelo' },
    { '<leader>zp', '<cmd>CopilotChatPrompts<cr>', mode = 'n', desc = 'Ver prompts disponíveis' },
  },
}
