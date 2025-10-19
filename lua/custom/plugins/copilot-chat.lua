return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'github/copilot.vim' }, -- or zbirenbaum/copilot.lua
      { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    opts = {
      -- 🤖 Configurações principais do Copilot Chat
      debug = false, -- Enable debug logging
      proxy = nil, -- [protocol://]host[:port] Use this proxy
      allow_insecure = false, -- Allow insecure server connections

      -- 💬 Sistema e comportamento (configuração mínima)
      system_prompt = 'Você é um assistente de programação útil e preciso.',
      temperature = 0.1,

      -- 📋 Headers simples
      question_header = '## User ',
      answer_header = '## Copilot ',
      error_header = '## Error ',

      -- 🎯 Auto-incluir contexto do buffer atual
      show_folds = true, -- Shows folds in chat buffer
      show_help = true, -- Shows help message as virtual lines when waiting for user input
      auto_follow_cursor = true, -- Auto-follow cursor in chat buffer
      auto_insert_mode = false, -- Automatically enter insert mode when opening chat window for ease of use
      clear_chat_on_new_prompt = false, -- Clears chat buffer when new prompt is set
      highlight_selection = true, -- Highlight selection in the source buffer when in the chat window

      -- 🪟 Configuração da janela
      context = nil, -- Default context to use, 'buffers', 'buffer' or none (can be specified manually in prompt via @).
      history_path = vim.fn.stdpath('data') .. '/copilotchat_history', -- Default path to stored history
      callback = nil, -- Callback to use when ask response is received

      -- Chat window layout
      chat = {
        welcome_message = 'Olá! Sou o Copilot. Como posso ajudar você hoje?', -- Welcome message to display when starting a new chat
        loading_text = 'Pensando...', -- Loading text to display while generating a response
        question_sign = '', -- Sign to use for user questions
        answer_sign = 'ﮧ', -- Sign to use for AI answers
        border = 'rounded', -- Border style to use, 'single', 'double', 'rounded', 'solid', 'shadow'
        max_width = 120, -- Maximum width of chat window
        max_height = 25, -- Maximum height of chat window
        zindex = 1, -- Z-index of chat window
        margin_top = vim.o.cmdheight + 1, -- Top margin of chat window
        margin_bottom = vim.o.cmdheight + 1, -- Bottom margin of chat window
      },

      -- Code window layout  
      window = {
        layout = 'vertical', -- 'vertical', 'horizontal', 'float', 'replace'
        width = 50, -- Width of the window, only applies to floating windows
        height = 50, -- Height of the window, only applies to floating windows
        relative = 'editor', -- 'editor', 'win', 'cursor', 'mouse'
        border = 'rounded', -- Border style to use, 'single', 'double', 'rounded', 'solid', 'shadow'
        row = nil, -- Row position of the window, default is centered
        col = nil, -- Column position of the window, default is centered
        title = 'Copilot Chat', -- Title of the window
        footer = nil, -- Footer of the window
        zindex = 1, -- Z-index of the window
      },

      -- 🎨 Mapeamentos personalizados (configuração mínima)
      mappings = {
        complete = {
          insert = '<Tab>',
        },
        close = {
          normal = 'q',
        },
        reset = {
          normal = '<C-r>',
        },
        submit_prompt = {
          normal = '<CR>',
        },
      },
    },
    config = function(_, opts)
      local chat = require('CopilotChat')
      local select = require('CopilotChat.select')
      
      -- Setup com delay para garantir que está pronto
      vim.defer_fn(function()
        chat.setup(opts)
      end, 100)

      -- 🧹 Função para limpar IDs dos headers automaticamente
      local function clean_chat_buffer()
        local buffers = vim.api.nvim_list_bufs()
        for _, buf in ipairs(buffers) do
          local name = vim.api.nvim_buf_get_name(buf)
          if name:match('copilot%-chat') or name:match('CopilotChat') then
            -- Verificar se o buffer é válido e modificável
            if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, 'modifiable') then
              local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
              local cleaned_lines = {}
              local changed = false
              
              for _, line in ipairs(lines) do
                -- Remove IDs dos headers (padrão UUID)
                local cleaned = line:gsub('# User %([%w%-]+%) %-%-%-', '# User')
                cleaned = cleaned:gsub('# Copilot %([%w%-]+%) %-%-%-', '# Copilot')
                if cleaned ~= line then
                  changed = true
                end
                table.insert(cleaned_lines, cleaned)
              end
              
              -- Só modifica se realmente houver mudanças
              if changed then
                pcall(vim.api.nvim_buf_set_lines, buf, 0, -1, false, cleaned_lines)
              end
            end
          end
        end
      end

      -- Comando manual para limpar o chat
      vim.api.nvim_create_user_command('CopilotChatClean', clean_chat_buffer, {
        desc = 'Limpar IDs do buffer do CopilotChat'
      })

      -- 🎯 Função helper para incluir buffer atual automaticamente
      local function chat_with_current_buffer(prompt_type)
        return function()
          local input = vim.fn.input(prompt_type .. ': ')
          if input ~= '' then
            -- Automaticamente incluir o buffer atual no contexto
            chat.ask(input, { selection = select.buffer })
          end
        end
      end

      -- 🎯 Função para chat com seleção visual
      local function chat_with_selection(prompt_type)
        return function()
          local input = vim.fn.input(prompt_type .. ': ')
          if input ~= '' then
            chat.ask(input, { selection = select.visual })
          end
        end
      end

      -- Sobrescrever keymaps para incluir contexto automático
      vim.keymap.set('n', '<leader>zc', function()
        chat.toggle({ selection = select.buffer })
      end, { desc = 'Copilot Chat (com buffer atual)' })

      vim.keymap.set('n', '<leader>zq', chat_with_current_buffer('Pergunta'), 
        { desc = 'Copilot Quick Chat (com buffer)' })

      vim.keymap.set('v', '<leader>zc', function()
        chat.toggle({ selection = select.visual })
      end, { desc = 'Copilot Chat (com seleção)' })

      vim.keymap.set('v', '<leader>zq', chat_with_selection('Pergunta'), 
        { desc = 'Copilot Quick Chat (com seleção)' })
    end,
    keys = {
      -- 💬 Chat básico (já configurado no config)
      { '<leader>zc', desc = 'Copilot Chat Toggle' },
      { '<leader>zq', desc = 'Copilot Quick Question', mode = { 'n', 'v' } },
      
      -- 🔍 Comandos específicos com contexto automático
      { '<leader>ze', '<cmd>CopilotChatExplain<cr>', mode = 'v', desc = 'Copilot: Explicar código selecionado' },
      { '<leader>zr', '<cmd>CopilotChatReview<cr>', mode = 'v', desc = 'Copilot: Revisar código selecionado' },
      { '<leader>zf', '<cmd>CopilotChatFix<cr>', mode = 'v', desc = 'Copilot: Corrigir código selecionado' },
      { '<leader>zo', '<cmd>CopilotChatOptimize<cr>', mode = 'v', desc = 'Copilot: Otimizar código selecionado' },
      { '<leader>zd', '<cmd>CopilotChatDocs<cr>', mode = 'v', desc = 'Copilot: Gerar documentação' },
      { '<leader>zt', '<cmd>CopilotChatTests<cr>', mode = 'v', desc = 'Copilot: Gerar testes' },
      
      -- 📝 Comandos para arquivo inteiro
      { '<leader>zeb', '<cmd>CopilotChatExplain<cr>', mode = 'n', desc = 'Copilot: Explicar buffer inteiro' },
      { '<leader>zrb', '<cmd>CopilotChatReview<cr>', mode = 'n', desc = 'Copilot: Revisar buffer inteiro' },
      { '<leader>zfb', '<cmd>CopilotChatFix<cr>', mode = 'n', desc = 'Copilot: Corrigir buffer inteiro' },
      
      --  Controle do chat
      { '<leader>zx', '<cmd>CopilotChatReset<cr>', mode = 'n', desc = 'Copilot: Limpar chat' },
      { '<leader>zv', '<cmd>CopilotChatToggle<cr>', mode = 'n', desc = 'Copilot: Toggle janela' },
      { '<leader>zl', '<cmd>CopilotChatClean<cr>', mode = 'n', desc = 'Copilot: Limpar IDs do chat' },
    },
  },
}
