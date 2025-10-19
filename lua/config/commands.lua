-- 🎯 Comandos Customizados
-- Este arquivo contém todos os comandos definidos pelo usuário

-- 🔍 LSP Debug Commands
vim.api.nvim_create_user_command('LspStatus', function()
  local clients = vim.lsp.get_clients()
  if #clients == 0 then
    print('❌ Nenhum cliente LSP ativo')
    return
  end
  
  print('📡 LSP Status:')
  for _, client in ipairs(clients) do
    local status = client.is_stopped() and '❌ Parado' or '✅ Ativo'
    print('  • ' .. client.name .. ': ' .. status)
  end
end, { desc = 'Mostrar status dos clientes LSP' })

vim.api.nvim_create_user_command('LspClients', function()
  local clients = vim.lsp.get_clients()
  if #clients == 0 then
    print('❌ Nenhum cliente LSP ativo')
    return
  end
  
  print('👥 Clientes LSP ativos:')
  for _, client in ipairs(clients) do
    print('  • ID: ' .. client.id .. ', Nome: ' .. client.name)
    if client.config and client.config.cmd then
      print('    Comando: ' .. table.concat(client.config.cmd, ' '))
    end
    if client.config and client.config.root_dir then
      print('    Root: ' .. client.config.root_dir)
    end
  end
end, { desc = 'Listar clientes LSP detalhadamente' })

vim.api.nvim_create_user_command('LspRestart', function()
  vim.cmd('LspStop')
  vim.defer_fn(function()
    vim.cmd('LspStart')
  end, 500)
  print('🔄 Reiniciando LSP...')
end, { desc = 'Reiniciar todos os clientes LSP' })

vim.api.nvim_create_user_command('LspConfigs', function()
  local lsp_dir = vim.fn.stdpath('config') .. '/lsp'
  local files = vim.fn.glob(lsp_dir .. '/*.lua', false, true)
  
  if #files == 0 then
    print('❌ Nenhuma configuração LSP encontrada em: ' .. lsp_dir)
    return
  end
  
  print('📋 Configurações LSP disponíveis:')
  for _, file in ipairs(files) do
    local server_name = vim.fn.fnamemodify(file, ':t:r')
    local exists = vim.fn.filereadable(file) == 1
    local status = exists and '✅' or '❌'
    print('  ' .. status .. ' ' .. server_name .. '.lua')
  end
end, { desc = 'Listar configurações LSP disponíveis' })

-- 🧹 Utility Commands
vim.api.nvim_create_user_command('TrimWhitespace', function()
  local save_cursor = vim.fn.getpos('.')
  vim.cmd([[%s/\s\+$//e]])
  vim.fn.setpos('.', save_cursor)
  print('✨ Trailing whitespace removido!')
end, { desc = 'Remover espaços em branco no final das linhas' })

vim.api.nvim_create_user_command('ReloadConfig', function()
  for name, _ in pairs(package.loaded) do
    if name:match('^config%.') or name:match('^custom%.') or name:match('^corr3ia%.') then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)
  print('🔄 Configuração recarregada!')
end, { desc = 'Recarregar configuração do Neovim' })

-- 📊 Info Commands
vim.api.nvim_create_user_command('ConfigInfo', function()
  local config_path = vim.fn.stdpath('config')
  local data_path = vim.fn.stdpath('data')
  local cache_path = vim.fn.stdpath('cache')
  
  print('📂 Caminhos da configuração:')
  print('  Config: ' .. config_path)
  print('  Data: ' .. data_path)
  print('  Cache: ' .. cache_path)
  print('')
  print('🐧 Sistema:')
  print('  Neovim: ' .. vim.version().major .. '.' .. vim.version().minor .. '.' .. vim.version().patch)
  print('  OS: ' .. vim.loop.os_uname().sysname)
end, { desc = 'Informações da configuração' })

-- 🩺 Diagnostic Commands
vim.api.nvim_create_user_command('DiagnosticInfo', function()
  local diagnostics = vim.diagnostic.get(0) -- 0 = current buffer
  if #diagnostics == 0 then
    print('✅ Nenhum diagnóstico no buffer atual')
    return
  end
  
  print('🩺 Diagnósticos no buffer atual:')
  print('================================')
  
  local counts = { ERROR = 0, WARN = 0, INFO = 0, HINT = 0 }
  local severity_names = {
    [vim.diagnostic.severity.ERROR] = 'ERROR',
    [vim.diagnostic.severity.WARN] = 'WARN',
    [vim.diagnostic.severity.INFO] = 'INFO',
    [vim.diagnostic.severity.HINT] = 'HINT',
  }
  
  for _, diag in ipairs(diagnostics) do
    local severity = severity_names[diag.severity] or 'UNKNOWN'
    counts[severity] = counts[severity] + 1
    print(string.format('• Linha %d: [%s] %s', diag.lnum + 1, severity, diag.message))
  end
  
  print('')
  print('📊 Resumo:')
  for severity, count in pairs(counts) do
    if count > 0 then
      print(string.format('  %s: %d', severity, count))
    end
  end
end, { desc = 'Informações sobre diagnósticos' })

vim.api.nvim_create_user_command('DiagnosticToggle', function()
  local current_config = vim.diagnostic.config()
  local new_virtual_text = not current_config.virtual_text.enabled
  
  vim.diagnostic.config({
    virtual_text = { enabled = new_virtual_text }
  })
  
  local status = new_virtual_text and 'ativado' or 'desativado'
  print('🩺 Virtual text ' .. status)
end, { desc = 'Toggle virtual text dos diagnósticos' })

-- 🔧 PHP/Laravel Helper Commands
vim.api.nvim_create_user_command('PhpArtisan', function(opts)
  local cmd = 'php artisan ' .. opts.args
  vim.cmd('split | terminal ' .. cmd)
end, { 
  nargs = '*', 
  desc = 'Executar comando php artisan',
  complete = function()
    -- Sugestões básicas de comandos artisan
    return {
      'make:controller',
      'make:model',
      'make:migration',
      'migrate',
      'migrate:rollback',
      'tinker',
      'config:cache',
      'optimize:clear',
      'queue:work',
      'serve'
    }
  end
})

vim.api.nvim_create_user_command('Composer', function(opts)
  local cmd = 'composer ' .. opts.args
  vim.cmd('split | terminal ' .. cmd)
end, { 
  nargs = '*', 
  desc = 'Executar comando composer',
  complete = function()
    return {
      'install',
      'update',
      'require',
      'dump-autoload',
      'show',
      'outdated'
    }
  end
})
