-- Phpactor PHP Language Server configuration
-- Configurado APENAS para inlay hints (Intelephense fornece o resto)
return {
  cmd = { vim.fn.expand('~/.config/composer/vendor/bin/phpactor'), 'language-server' },
  filetypes = { 'php' },
  root_markers = { 'composer.json', '.git' },
  
  on_attach = function(client, bufnr)
    -- Desabilitar TODAS as capabilities exceto inlay hints
    -- Intelephense já fornece tudo isso
    client.server_capabilities.completionProvider = false
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.signatureHelpProvider = false
    client.server_capabilities.definitionProvider = false
    client.server_capabilities.typeDefinitionProvider = false
    client.server_capabilities.implementationProvider = false
    client.server_capabilities.referencesProvider = false
    client.server_capabilities.documentHighlightProvider = false
    client.server_capabilities.documentSymbolProvider = false
    client.server_capabilities.workspaceSymbolProvider = false
    client.server_capabilities.codeActionProvider = false
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    client.server_capabilities.renameProvider = false
    client.server_capabilities.codeLensProvider = false
    
    -- Desabilitar mensagens de progresso (indexação)
    client.server_capabilities.window = {
      workDoneProgress = false,
    }
    
    -- Manter APENAS inlay hints
    -- client.server_capabilities.inlayHintProvider = true (já vem habilitado)
  end,
  
  -- Suprimir handlers de progresso e notificações
  handlers = {
    ['$/progress'] = function() end,
    ['window/showMessage'] = function() end,
    ['window/logMessage'] = function() end,
  },
}
