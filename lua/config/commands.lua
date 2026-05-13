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
      local cmd = client.config.cmd
      if type(cmd) == 'table' then
        print('    Comando: ' .. table.concat(cmd, ' '))
      elseif type(cmd) == 'function' then
        print('    Comando: <função dinâmica>')
      end
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

vim.api.nvim_create_user_command('VuePerfInfo', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local name = vim.api.nvim_buf_get_name(bufnr)
  local ft = vim.bo[bufnr].filetype
  local uv = vim.uv or vim.loop

  local size = 0
  if name ~= '' then
    local ok, stat = pcall(uv.fs_stat, name)
    if ok and stat and stat.size then
      size = stat.size
    end
  end

  print('⚡ Vue Perf Info:')
  print('==============')
  print('Buffer: ' .. (name ~= '' and name or '[No Name]'))
  print('Filetype: ' .. ft)
  print(string.format('Tamanho: %d bytes (%.1f KB)', size, size / 1024))
  print('Debug verbose: ' .. (vim.g.vue_perf_debug and 'ON' or 'OFF') .. ' (toggle: :VuePerfDebugToggle)')

  local ts_active = vim.treesitter.highlighter.active[bufnr] ~= nil
  print('Treesitter ativo: ' .. (ts_active and 'sim' or 'não'))

  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if #clients == 0 then
    print('LSP no buffer: nenhum')
  else
    print('LSP no buffer:')
    for _, client in ipairs(clients) do
      local semantic = client.server_capabilities and client.server_capabilities.semanticTokensProvider ~= nil
      print(string.format('  • %s | semanticTokens: %s', client.name, semantic and 'on' or 'off'))
    end
  end
end, { desc = 'Inspecionar estado de performance para arquivo Vue' })

vim.api.nvim_create_user_command('VuePerfDebugToggle', function()
  vim.g.vue_perf_debug = not vim.g.vue_perf_debug
  print('Vue perf debug: ' .. (vim.g.vue_perf_debug and 'ON' or 'OFF'))
end, { desc = 'Ativar/desativar logs detalhados de performance Vue' })

vim.api.nvim_create_user_command('VueTsInstall', function()
  local ok = pcall(vim.cmd, 'TSInstall vue')
  if ok then
    print('Instalação do parser Vue iniciada. Aguarde concluir no cmdline do Neovim.')
  else
    print('Falha ao iniciar :TSInstall vue. Verifique se nvim-treesitter está carregado.')
  end
end, { desc = 'Instalar parser Treesitter de Vue' })
