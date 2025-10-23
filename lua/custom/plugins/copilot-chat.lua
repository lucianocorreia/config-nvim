-- 🤖 Copilot Chat - Configuração limpa e otimizada
return {
  'CopilotC-Nvim/CopilotChat.nvim',
  dependencies = {
    { 'github/copilot.vim' },
    { 'nvim-lua/plenary.nvim', branch = 'master' },
  },
  build = 'make tiktoken',
  opts = {
    -- 🔧 Configurações principais
    debug = false,
    proxy = nil,
    allow_insecure = false,
    
    -- ✨ Autocomplete no chat
    chat_autocomplete = true,
    
    -- 💬 Sistema de mensagens
    system_prompt = 'Você é um assistente de programação útil e preciso. Responda sempre em português brasileiro.',
    temperature = 0.1,
    
    -- 📋 Headers personalizados
    question_header = '## 🧑‍💻 Usuário ',
    answer_header = '## 🤖 Copilot ',
    error_header = '## ❌ Erro ',
    
    -- 🎯 Comportamento da interface
    show_folds = true,
    show_help = true,
    auto_follow_cursor = true,
    auto_insert_mode = true,
    clear_chat_on_new_prompt = false,
    highlight_selection = true,
    
    -- 💾 Histórico
    history_path = vim.fn.stdpath('data') .. '/copilotchat_history',
    
    -- 🎨 Configuração visual da janela de chat
    chat = {
      welcome_message = '👋 Olá! Sou o Copilot. Como posso ajudar você hoje?',
      loading_text = '🤔 Pensando...',
      question_sign = '🧑‍💻',
      answer_sign = '🤖',
      border = 'rounded',
      max_width = 120,
      max_height = 25,
      zindex = 1,
      margin_top = vim.o.cmdheight + 1,
      margin_bottom = vim.o.cmdheight + 1,
    },
    
    -- 🪟 Layout da janela
    window = {
      layout = 'vertical',  -- 'vertical', 'horizontal', 'float'
      width = 0.4,         -- 40% da tela para layout vertical
      height = 0.8,        -- 80% da tela para layout float
      relative = 'editor',
      border = 'rounded',
      row = nil,
      col = nil,
      title = '🤖 Copilot Chat',
      footer = nil,
      zindex = 1,
    },
    
    -- ⌨️ Mapeamentos dentro do chat
    mappings = {
      complete = {
        detail = 'Use @<plugin> to tag workspace, /<command> for prompts, $<model> to change model, #<resource> to use resource',
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
        insert = '<C-CR>'
      },
    },
  },
  
  config = function(_, opts)
    local chat = require('CopilotChat')
    
    -- Inicializar o chat
    chat.setup(opts)
    
    -- 🧹 Função para limpar IDs dos headers
    local function clean_chat_buffer()
      local buffers = vim.api.nvim_list_bufs()
      for _, buf in ipairs(buffers) do
        local name = vim.api.nvim_buf_get_name(buf)
        if name:match('copilot%-chat') or name:match('CopilotChat') then
          if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, 'modifiable') then
            local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
            local cleaned_lines = {}
            local changed = false
            
            for _, line in ipairs(lines) do
              -- Remove IDs UUID dos headers
              local cleaned = line:gsub('## 🧑‍💻 Usuário %([%w%-]+%) %-%-%-', '## 🧑‍💻 Usuário')
              cleaned = cleaned:gsub('## 🤖 Copilot %([%w%-]+%) %-%-%-', '## 🤖 Copilot')
              -- Fallback para headers padrão sem emoji
              cleaned = cleaned:gsub('## User %([%w%-]+%) %-%-%-', '## 🧑‍💻 Usuário')
              cleaned = cleaned:gsub('## Copilot %([%w%-]+%) %-%-%-', '## 🤖 Copilot')
              
              if cleaned ~= line then
                changed = true
              end
              table.insert(cleaned_lines, cleaned)
            end
            
            if changed then
              pcall(vim.api.nvim_buf_set_lines, buf, 0, -1, false, cleaned_lines)
            end
          end
        end
      end
    end
    
    -- 📝 Comandos personalizados
    vim.api.nvim_create_user_command('CopilotChatClean', clean_chat_buffer, {
      desc = 'Limpar IDs dos headers do Copilot Chat'
    })
    
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
    vim.api.nvim_create_autocmd({'FileType', 'BufEnter'}, {
      pattern = 'copilot-chat',
      callback = function(event)
        local buf = event.buf
        -- Configurar buffer para não fechar automaticamente
        vim.api.nvim_buf_set_option(buf, 'buflisted', true)
        vim.api.nvim_buf_set_option(buf, 'bufhidden', 'hide')
        
        -- Keymap local para fechar com 'q'
        vim.keymap.set('n', 'q', '<cmd>close<cr>', { 
          buffer = buf, 
          desc = 'Fechar Copilot Chat',
          silent = true 
        })
        
        -- Tab e Ctrl+J: remapear para usar a mesma função global
        -- Isso garante que funcione igual aos outros buffers
        vim.keymap.set('i', '<Tab>', function()
          local copilot_keys = vim.fn['copilot#Accept']("")
          if copilot_keys ~= '' then
            vim.api.nvim_feedkeys(copilot_keys, 'n', true)
          else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, false, true), 'n', false)
          end
        end, {
          buffer = buf,
          desc = 'Aceitar sugestão Copilot',
          silent = true,
        })
        
        vim.keymap.set('i', '<C-J>', function()
          local copilot_keys = vim.fn['copilot#Accept']("")
          if copilot_keys ~= '' then
            vim.api.nvim_feedkeys(copilot_keys, 'n', true)
          end
        end, {
          buffer = buf,
          desc = 'Aceitar sugestão Copilot',
          silent = true,
        })
      end,
    })
    

  end,
  
  -- 🚀 Keymaps lazy-loaded
  keys = {
    -- 🤖 Toggle e Chat Principal
    { '<leader>zh', '<cmd>CopilotChatToggle<cr>', mode = 'n', desc = 'Copilot Chat Toggle' },
    { '<leader>zh', '<cmd>CopilotChatToggle<cr>', mode = 'v', desc = 'Copilot Chat (com seleção)' },
    
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
    
    -- 🔍 Comandos específicos para seleção
    { '<leader>ze', '<cmd>CopilotChatExplain<cr>', mode = 'v', desc = 'Explicar código selecionado' },
    { '<leader>zr', '<cmd>CopilotChatReview<cr>', mode = 'v', desc = 'Revisar código selecionado' },
    { '<leader>zf', '<cmd>CopilotChatFix<cr>', mode = 'v', desc = 'Corrigir código selecionado' },
    { '<leader>zo', '<cmd>CopilotChatOptimize<cr>', mode = 'v', desc = 'Otimizar código selecionado' },
    { '<leader>zd', '<cmd>CopilotChatDocs<cr>', mode = 'v', desc = 'Gerar documentação' },
    { '<leader>zt', '<cmd>CopilotChatTests<cr>', mode = 'v', desc = 'Gerar testes' },
    
    -- 📝 Comandos para arquivo inteiro
    { '<leader>zeb', '<cmd>CopilotChatExplain<cr>', mode = 'n', desc = 'Explicar arquivo inteiro' },
    { '<leader>zrb', '<cmd>CopilotChatReview<cr>', mode = 'n', desc = 'Revisar arquivo inteiro' },
    { '<leader>zfb', '<cmd>CopilotChatFix<cr>', mode = 'n', desc = 'Corrigir arquivo inteiro' },
    
    -- 🎛️ Controle do chat
    { '<leader>zx', '<cmd>CopilotChatReset<cr>', mode = 'n', desc = 'Limpar chat' },
    { '<leader>zl', '<cmd>CopilotChatClean<cr>', mode = 'n', desc = 'Limpar IDs do chat' },
    { '<leader>zT', '<cmd>CopilotChatTest<cr>', mode = 'n', desc = 'Testar Copilot Chat' },
  },
}
