-- Utilitário para debug do Copilot Chat
-- Use :lua require('corr3ia.copilot-debug').check_copilot() para verificar status

local M = {}

function M.check_copilot()
  -- Verificar se o Copilot Chat está carregado
  local copilot_chat_ok, copilot_chat = pcall(require, 'CopilotChat')
  if not copilot_chat_ok then
    print("❌ CopilotChat não está carregado")
    return false
  end
  
  print("✅ CopilotChat carregado com sucesso")
  
  -- Verificar se o Copilot base está funcionando
  local copilot_ok = vim.fn.exists(':Copilot') > 0
  if not copilot_ok then
    print("❌ Copilot base não está disponível")
    return false
  end
  
  print("✅ Copilot base disponível")
  
  -- Verificar autenticação
  local auth_status = vim.fn['copilot#Enabled']()
  if auth_status == 0 then
    print("⚠️  Copilot não está autenticado ou habilitado")
    print("Execute :Copilot auth para fazer login")
    return false
  end
  
  print("✅ Copilot autenticado")
  
  return true
end

function M.test_models()
  local models = {
    'gpt-4o',
    'gpt-4o-mini', 
    'gpt-4-turbo',
    'gpt-4',
    'gpt-3.5-turbo'
  }
  
  print("🧪 Testando modelos disponíveis...")
  
  for _, model in ipairs(models) do
    local copilot_chat = require('CopilotChat')
    
    -- Tentar uma pergunta simples com cada modelo
    local success = pcall(function()
      copilot_chat.ask("Diga apenas 'ok'", {
        model = model,
        callback = function(response)
          if response and response ~= "" then
            print("✅ " .. model .. " funcionando")
          else
            print("❌ " .. model .. " sem resposta")
          end
        end
      })
    end)
    
    if not success then
      print("❌ " .. model .. " erro ao testar")
    end
  end
end

function M.fix_copilot()
  print("🔧 Aplicando correções do Copilot...")
  
  -- Restart do Copilot
  vim.cmd('Copilot disable')
  vim.wait(1000) -- Aguarda 1 segundo
  vim.cmd('Copilot enable')
  
  print("✅ Copilot reiniciado")
  
  -- Reload do CopilotChat se disponível (sem especificar modelo)
  local copilot_chat_ok, copilot_chat = pcall(require, 'CopilotChat')
  if copilot_chat_ok then
    copilot_chat.setup({
      system_prompt = 'Você é um assistente de programação útil e preciso.',
      temperature = 0.1,
    })
    print("✅ CopilotChat reconfigurado sem modelo específico")
  end
end

return M
