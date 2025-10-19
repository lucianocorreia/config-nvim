-- Teste básico do CopilotChat
-- Use :lua require('corr3ia.copilot-test').test_basic() para testar

local M = {}

function M.test_basic()
  -- Configuração mínima para teste
  local chat = require('CopilotChat')
  
  chat.setup({
    -- Configuração absolutamente mínima
    debug = false,
  })
  
  print("✅ CopilotChat configurado com setup mínimo")
  
  -- Teste de abertura
  chat.toggle()
  print("✅ Chat aberto - teste digitar uma pergunta e pressionar Enter")
end

function M.reset_and_test()
  -- Reset completo
  vim.cmd('CopilotChatReset')
  
  -- Aguardar um pouco
  vim.defer_fn(function()
    local chat = require('CopilotChat')
    chat.toggle()
    print("✅ Chat resetado e reaberto")
  end, 1000)
end

return M
