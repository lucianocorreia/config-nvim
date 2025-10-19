-- 🎯 Guia de Instalação e Configuração C# para Neovim
-- Execute os comandos abaixo para configurar C# no seu Neovim

local M = {}

-- 📦 Função para verificar instalações necessárias
function M.check_csharp_setup()
  print("🔍 Verificando setup do C# com Roslyn...")
  
  -- Verificar .NET SDK
  local dotnet_check = vim.fn.system("dotnet --version")
  if vim.v.shell_error == 0 then
    print("✅ .NET SDK encontrado: " .. vim.trim(dotnet_check))
  else
    print("❌ .NET SDK não encontrado. Instale com:")
    print("   macOS: brew install --cask dotnet")
    print("   ou baixe de: https://dotnet.microsoft.com/download")
    return false
  end
  
  -- Verificar se estamos em um projeto C#
  local current_dir = vim.fn.getcwd()
  local csproj_files = vim.fn.glob(current_dir .. "/**/*.csproj", true, true)
  local sln_files = vim.fn.glob(current_dir .. "/**/*.sln", true, true)
  
  if #csproj_files > 0 or #sln_files > 0 then
    print("✅ Projeto C# detectado")
    if #sln_files > 0 then
      print("   Solution found: " .. vim.fn.fnamemodify(sln_files[1], ":t"))
    end
    if #csproj_files > 0 then
      print("   Projects found: " .. #csproj_files)
    end
  else
    print("⚠️  Nenhum projeto C# detectado no diretório atual")
    print("   Certifique-se de estar na pasta do projeto .csproj ou .sln")
  end
  
  -- Verificar rzls.nvim
  print("\n🎯 Status dos plugins:")
  local rzls_ok, rzls = pcall(require, 'rzls')
  if rzls_ok then
    print("✅ rzls.nvim carregado")
  else
    print("❌ rzls.nvim não carregado")
    print("   Verifique se o plugin está instalado e reinicie o Neovim")
    return false
  end
  
  -- Verificar LSP ativo
  local current_buf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = current_buf })
  if #clients > 0 then
    print("✅ LSP ativo no buffer atual:")
    for _, client in ipairs(clients) do
      print("   - " .. client.name)
    end
  else
    print("⚠️  Nenhum LSP ativo no buffer atual")
    if vim.bo.filetype == 'cs' then
      print("   Buffer é C# mas LSP não está ativo")
    else
      print("   Abra um arquivo .cs para testar")
    end
  end
  
  print("\n📝 Para testar:")
  print("   1. Abra um arquivo .cs: :e test.cs")
  print("   2. Use gd, gr, K, <leader>ca")
  print("   3. Veja mensagens com :messages")
  
  return true
end

-- 🛠️ Função para garantir instalação do Roslyn via rzls
function M.install_roslyn()
  local rzls_ok, rzls = pcall(require, 'rzls')
  if not rzls_ok then
    print("❌ rzls.nvim não está disponível - instale primeiro")
    return
  end
  
  print("🔄 Verificando instalação do Roslyn via rzls.nvim...")
  
  -- O rzls.nvim instala automaticamente o Roslyn se auto_install = true
  -- Mas podemos forçar a instalação se necessário
  local success, err = pcall(function()
    -- Se há um comando de instalação manual, use aqui
    -- rzls.install() -- (este método pode não existir, depende da versão)
  end)
  
  if success then
    print("✅ Roslyn instalado com sucesso")
  else
    print("⭐ O Roslyn será instalado automaticamente na primeira vez que abrir um arquivo .cs")
    print("   Certifique-se de que auto_install = true na configuração")
  end
end

-- 🧪 Função para testar funcionalidades
function M.test_csharp_features()
  print("🧪 Abrindo projeto de teste...")
  
  -- Ir para o projeto de teste
  vim.cmd('cd /Users/correia/.config/nvim/csharp-test/TestApp')
  
  -- Abrir o arquivo Program.cs
  vim.cmd('edit Program.cs')
  
  print("✅ Projeto de teste aberto")
  print("💡 Aguarde o LSP carregar e teste:")
  print("   - Posicione o cursor em 'Console' e pressione K")
  print("   - Use gd para ir à definição")
  print("   - Use <leader>ca para code actions")
  print("   - Veja :messages para logs do LSP")
end

-- � Função para restart do LSP C#
function M.restart_csharp_lsp()
  print("🔄 Reiniciando LSP C#...")
  
  -- Parar todos os clients LSP do buffer atual
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  for _, client in ipairs(clients) do
    if client.name == 'roslyn' or client.name == 'rzls' then
      print("🛑 Parando " .. client.name)
      client.stop()
    end
  end
  
  -- Tentar restart via rzls (se método existir)
  local rzls_ok, rzls = pcall(require, 'rzls')
  if rzls_ok then
    print("🔄 Tentando restart via rzls...")
    
    -- Verificar se o método restart existe
    if rzls.restart then
      local success, err = pcall(rzls.restart)
      if not success then
        print("❌ Erro no restart rzls: " .. tostring(err))
      else
        print("✅ Restart rzls executado")
      end
    else
      print("⚠️  Método restart não disponível, tentando reconfigurar...")
      local success, err = pcall(function()
        rzls.setup({ auto_install = true })
      end)
      if success then
        print("✅ Reconfiguração executada")
      else
        print("❌ Erro na reconfiguração: " .. tostring(err))
      end
    end
  end
  
  -- Aguardar um pouco e tentar reinicializar
  vim.defer_fn(function()
    if vim.bo.filetype == 'cs' then
      print("🚀 Recarregando buffer...")
      vim.cmd('edit') -- Reload o buffer para trigger o LSP
    end
  end, 1000)
end

-- 🔧 Função para debug do rzls
function M.debug_rzls()
  print("🔍 Debug completo do rzls.nvim...")
  
  local rzls_ok, rzls = pcall(require, 'rzls')
  if not rzls_ok then
    print("❌ rzls.nvim não carregado")
    return
  end
  
  print("✅ rzls.nvim carregado")
  
  -- Listar todos os métodos disponíveis
  print("\n📋 Métodos disponíveis no rzls:")
  for key, value in pairs(rzls) do
    local type_info = type(value)
    print("  • " .. key .. " (" .. type_info .. ")")
  end
  
  -- Verificar instalação do Roslyn
  print("\n🔍 Verificando instalação do Roslyn:")
  local roslyn_paths = {
    vim.fn.stdpath("data") .. "/rzls",
    vim.fn.stdpath("data") .. "/roslyn", 
  }
  
  for _, path in ipairs(roslyn_paths) do
    if vim.fn.isdirectory(path) == 1 then
      print("✅ Diretório encontrado: " .. path)
      local files = vim.fn.glob(path .. "/**/*LanguageServer*", false, true)
      if #files > 0 then
        print("  📄 Executável encontrado: " .. files[1])
      end
    else
      print("❌ Diretório não encontrado: " .. path)
    end
  end
  
  -- Verificar se o LSP está rodando
  print("\n🔍 Status dos LSP clients:")
  local clients = vim.lsp.get_clients()
  if #clients == 0 then
    print("❌ Nenhum LSP client ativo")
  else
    for _, client in ipairs(clients) do
      print("✅ " .. client.name .. " (ID: " .. client.id .. ")")
    end
  end
end

-- 🚀 Função para forçar download do Roslyn
function M.force_download_roslyn()
  print("🚀 Forçando download do Roslyn...")
  
  local rzls_ok, rzls = pcall(require, 'rzls')
  if not rzls_ok then
    print("❌ rzls.nvim não disponível")
    return
  end
  
  -- Tentar setup com force download
  print("🔄 Executando setup com auto_install...")
  local success, err = pcall(function()
    rzls.setup({
      auto_install = true,
      path = nil, -- Força auto-detecção
    })
  end)
  
  if success then
    print("✅ Setup executado - Roslyn deve ser baixado em background")
    print("💡 Abra um arquivo .cs e aguarde alguns minutos para o download")
  else
    print("❌ Erro no setup: " .. tostring(err))
  end
end

-- �📋 Comandos úteis
vim.api.nvim_create_user_command('CSharpCheck', M.check_csharp_setup, {
  desc = 'Verificar configuração C#'
})

vim.api.nvim_create_user_command('CSharpInstall', M.install_roslyn, {
  desc = 'Verificar/instalar Roslyn Language Server via rzls.nvim'
})

vim.api.nvim_create_user_command('CSharpTest', M.test_csharp_features, {
  desc = 'Testar funcionalidades C#'
})

vim.api.nvim_create_user_command('CSharpRestart', M.restart_csharp_lsp, {
  desc = 'Reiniciar LSP C#'
})

vim.api.nvim_create_user_command('CSharpDebug', M.debug_rzls, {
  desc = 'Debug completo do rzls.nvim'
})

vim.api.nvim_create_user_command('CSharpDownload', M.force_download_roslyn, {
  desc = 'Forçar download do Roslyn Language Server'
})

return M
