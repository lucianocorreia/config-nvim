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

-- 🎨 Format Commands
vim.api.nvim_create_user_command('FormatInfo', function()
  -- Verificar conform.nvim
  local conform_ok, conform = pcall(require, 'conform')
  if not conform_ok then
    print('❌ Plugin conform.nvim não encontrado')
    return
  end
  
  local filetype = vim.bo.filetype
  print('🎨 Informações de Formatação:')
  print('============================')
  print('Tipo de arquivo: ' .. filetype)
  
  -- Verificar formatadores disponíveis para o tipo de arquivo
  local formatters = conform.list_formatters(0)
  if #formatters == 0 then
    print('❌ Nenhum formatador configurado para este tipo de arquivo')
  else
    print('✅ Formatadores disponíveis:')
    for _, formatter in ipairs(formatters) do
      local status = formatter.available and '✅' or '❌'
      print('  ' .. status .. ' ' .. formatter.name)
    end
  end
  
  print('')
  print('💡 Comandos úteis:')
  print('  :ConformInfo - Informações detalhadas do conform')
  print('  <leader>cf - Formatar buffer atual')
  print('  (visual) <leader>cf - Formatar seleção')
end, { desc = 'Informações sobre formatação' })

vim.api.nvim_create_user_command('FormatTest', function()
  -- Criar arquivo de teste com diferentes formatos
  local test_files = {
    ['test.json'] = '{"name":"test","value":123,"array":[1,2,3],"nested":{"key":"value"}}',
    ['test.xml'] = '<?xml version="1.0"?><root><item id="1"><name>Test</name><value>123</value></item></root>',
  }
  
  print('🧪 Criando arquivos de teste para formatação...')
  for filename, content in pairs(test_files) do
    local file = io.open(filename, 'w')
    if file then
      file:write(content)
      file:close()
      print('✅ Criado: ' .. filename)
    end
  end
  
  print('')
  print('💡 Para testar:')
  print('1. Abra os arquivos: :e test.json | :e test.xml')
  print('2. Use <leader>cf para formatar')
  print('3. Delete os arquivos quando terminar: :!rm test.json test.xml')
end, { desc = 'Criar arquivos de teste para formatação' })

-- 🎨 PHP Theme Commands
vim.api.nvim_create_user_command('PhpThemeTest', function()
  -- Criar arquivo PHP de teste com variáveis
  local php_content = [[<?php

class ExampleClass {
    public $publicVar = 'public';
    private $privateVar = 'private';
    protected $protectedVar = 'protected';
    
    public static function testMethod($parameter) {
        $localVar = 'local';
        $anotherVar = $parameter;
        
        echo $localVar . $anotherVar;
        
        return $this->publicVar;
    }
    
    private function anotherMethod() {
        $result = $this->privateVar;
        return $result;
    }
}

$instance = new ExampleClass();
$test = $instance->testMethod('test');
$globalVar = 'global';

function globalFunction($param1, $param2) {
    $local1 = $param1;
    $local2 = $param2;
    
    return $local1 . $local2;
}

echo $globalVar;
?>]]
  
  local file = io.open('php_theme_test.php', 'w')
  if file then
    file:write(php_content)
    file:close()
    print('🐘 Arquivo PHP de teste criado: php_theme_test.php')
    print('')
    print('💡 Para testar:')
    print('1. Abra o arquivo: :e php_theme_test.php')
    print('2. Observe as cores do $ (deve ser igual a public/static)')
    print('3. Delete quando terminar: :!rm php_theme_test.php')
  else
    print('❌ Erro ao criar arquivo de teste')
  end
end, { desc = 'Criar arquivo PHP de teste para verificar cores' })

vim.api.nvim_create_user_command('ThemeInfo', function()
  print('🎨 Informações do Tema:')
  print('======================')
  
  -- Verificar tema atual
  local colorscheme = vim.g.colors_name or 'unknown'
  print('Tema atual: ' .. colorscheme)
  
  if vim.bo.filetype == 'php' then
    print('')
    print('🐘 Highlights PHP:')
    
    -- Função para obter informações de highlight
    local function get_hl_info(group)
      local hl = vim.api.nvim_get_hl(0, { name = group })
      if hl and hl.fg then
        return string.format('#%06x', hl.fg)
      end
      return 'N/A'
    end
    
    print('  • Keyword (public/static): ' .. get_hl_info('Keyword'))
    print('  • phpVarSelector ($): ' .. get_hl_info('phpVarSelector'))
    print('  • @variable.builtin.php: ' .. get_hl_info('@variable.builtin.php'))
    print('  • phpIdentifier: ' .. get_hl_info('phpIdentifier'))
  else
    print('')
    print('💡 Abra um arquivo PHP para ver highlights específicos')
    print('Use :PhpThemeTest para criar arquivo de teste')
  end
end, { desc = 'Informações sobre o tema atual' })

-- 🤖 Copilot Chat Commands
vim.api.nvim_create_user_command('CopilotInfo', function()
  print('🤖 Informações do Copilot Chat:')
  print('===============================')
  
  -- Verificar se Copilot está disponível
  local copilot_ok, copilot = pcall(require, 'CopilotChat')
  if not copilot_ok then
    print('❌ CopilotChat não encontrado')
    return
  end
  
  print('✅ CopilotChat disponível')
  
  -- Verificar status do chat
  local chat_open = vim.fn.bufname():match('copilot%-chat') ~= nil
  print('Chat aberto: ' .. (chat_open and '✅ Sim' or '❌ Não'))
  
  print('')
  print('⌨️ Keymaps principais:')
  print('  <leader>zh - Toggle chat (com buffer atual)')
  print('  <leader>zq - Pergunta rápida (com contexto)')
  print('  <leader>ze - Explicar código (visual)')
  print('  <leader>zr - Revisar código (visual)')
  print('  <leader>zf - Corrigir código (visual)')
  print('  <leader>zm - Gerar commit message')
  print('  <leader>zx - Limpar chat')
  
  print('')
  print('💡 Dica: Agora o chat já inclui automaticamente o buffer atual!')
end, { desc = 'Informações sobre Copilot Chat' })

vim.api.nvim_create_user_command('CopilotHelp', function()
  print('🤖 Guia Rápido do Copilot Chat:')
  print('===============================')
  print('')
  print('🎯 CONTEXTO AUTOMÁTICO:')
  print('• <leader>zh - Abre chat COM buffer atual já incluído')
  print('• <leader>zq - Pergunta rápida COM contexto automático')
  print('• Não precisa mais usar #buffer!')
  print('')
  print('📝 COMANDOS POR MODO:')
  print('Normal mode (arquivo inteiro):')
  print('  <leader>zh  - Chat com buffer completo')
  print('  <leader>zeb - Explicar arquivo inteiro')
  print('  <leader>zrb - Revisar arquivo inteiro')
  print('  <leader>zfb - Corrigir arquivo inteiro')
  print('')
  print('Visual mode (seleção):')
  print('  <leader>zh - Chat com código selecionado')
  print('  <leader>ze - Explicar seleção')
  print('  <leader>zr - Revisar seleção')
  print('  <leader>zf - Corrigir seleção')
  print('  <leader>zo - Otimizar seleção')
  print('  <leader>zd - Gerar documentação')
  print('  <leader>zt - Gerar testes')
  print('  <leader>zr - Revisar seleção')
  print('  <leader>zf - Corrigir seleção')
  print('  <leader>zo - Otimizar seleção')
  print('  <leader>zd - Documentar seleção')
  print('  <leader>zt - Gerar testes')
  print('')
  print('🚀 UTILITÁRIOS:')
  print('  <leader>zm - Gerar commit message')
  print('  <leader>zs - Commit para staged files')
  print('  <leader>zx - Limpar chat')
  print('  <leader>zv - Toggle janela')
  print('')
  print('💡 DICAS:')
  print('• O contexto agora é automático!')
  print('• Use visual mode para código específico')
  print('• Use normal mode para arquivo inteiro')
end, { desc = 'Guia completo do Copilot Chat' })
