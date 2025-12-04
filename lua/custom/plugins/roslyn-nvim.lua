-- Roslyn C# Language Server
return {
  'seblyng/roslyn.nvim',
  ft = { 'cs' },
  opts = {
    filewatching = 'auto',
    broad_search = true,
    on_attach = function(client, bufnr)
      -- Desabilitar notificações de progresso padrão do Roslyn
      -- O fidget vai pegar automaticamente via window/logMessage
      client.server_capabilities.window = client.server_capabilities.window or {}
      
      -- Silenciar mensagens de inicialização específicas do Roslyn
      local original_notify = client.notify
      client.notify = function(method, params)
        -- Filtrar mensagens de inicialização
        if method == 'window/logMessage' then
          local message = params.message or ''
          -- Ignorar mensagens de "Project initialized" e similares
          if message:match('initialized') or message:match('ready') or message:match('started') then
            -- Não fazer nada, silenciar essas mensagens
            return
          end
        end
        -- Para outras mensagens, chamar o notify original
        return original_notify(method, params)
      end
    end,
  },
}
