-- C# Language Server - Comandos auxiliares para Roslyn
return {
  vim.api.nvim_create_user_command('RoslynRestore', function()
    print("🔄 Executando dotnet restore...")
    
    local cwd = vim.fn.getcwd()
    local sln = vim.fn.glob(cwd .. '/**/*.sln', false, true)[1]
    
    if sln then
      local sln_dir = vim.fn.fnamemodify(sln, ':h')
      local cmd = 'cd ' .. vim.fn.shellescape(sln_dir) .. ' && dotnet restore && dotnet build --no-restore'
      print("📁 Restaurando e compilando: " .. vim.fn.fnamemodify(sln, ':t'))
      print("💡 Isso pode levar alguns minutos...")
      
      vim.fn.jobstart(cmd, {
        on_stdout = function(_, data)
          if data then
            for _, line in ipairs(data) do
              if line ~= '' and not line:match('^%s*$') then
                print(line)
              end
            end
          end
        end,
        on_stderr = function(_, data)
          if data then
            for _, line in ipairs(data) do
              if line ~= '' and not line:match('^%s*$') then
                print(line)
              end
            end
          end
        end,
        on_exit = function(_, code)
          if code == 0 then
            print("✅ Build concluído com sucesso!")
            print("💡 Reiniciando Roslyn...")
            vim.defer_fn(function()
              vim.cmd('Roslyn restart')
              print("🎉 Roslyn reiniciado! Aguarde alguns segundos para análise do projeto.")
            end, 1000)
          else
            print("❌ Erro ao executar build (código: " .. code .. ")")
            print("💡 Verifique os erros acima e tente corrigir antes de usar o LSP")
          end
        end,
      })
    else
      print("❌ Nenhum .sln encontrado")
      print("💡 Execute manualmente:")
      print("   dotnet restore")
      print("   dotnet build")
    end
  end, { desc = 'Executar dotnet restore+build e reiniciar Roslyn' }),
  
  vim.api.nvim_create_user_command('RoslynStatus', function()
    -- Verificar .NET SDK
    local dotnet_version = vim.fn.system('dotnet --version 2>&1'):gsub('\n', '')
    if vim.v.shell_error == 0 then
      print("✅ .NET SDK: " .. dotnet_version)
    else
      print("❌ .NET SDK não instalado")
      return
    end
    
    -- Verificar instalação via Mason
    local mason_path = vim.fn.stdpath('data') .. '/mason/packages/roslyn'
    if vim.fn.isdirectory(mason_path) == 1 then
      print("✅ Roslyn instalado via Mason")
    else
      print("❌ Roslyn não instalado - execute :MasonInstall roslyn")
      return
    end
    
    -- Verificar projeto C#
    local cwd = vim.fn.getcwd()
    local has_csproj = vim.fn.glob(cwd .. '/**/*.csproj', false, true)
    local has_sln = vim.fn.glob(cwd .. '/**/*.sln', false, true)
    
    if #has_sln > 0 then
      print("✅ Projeto C#: " .. vim.fn.fnamemodify(has_sln[1], ':t'))
    elseif #has_csproj > 0 then
      print("✅ Projeto C#: " .. vim.fn.fnamemodify(has_csproj[1], ':t'))
    else
      print("⚠️  Nenhum .csproj ou .sln encontrado em " .. cwd)
      print("   Roslyn requer um projeto C# válido")
    end
    
    -- Verificar LSP ativo
    local clients = vim.lsp.get_clients({ bufnr = 0, name = 'roslyn' })
    if #clients > 0 then
      local client = clients[1]
      print("✅ Roslyn LSP ativo (ID: " .. client.id .. ")")
      
      -- Mostrar capabilities
      local cap = client.server_capabilities
      if cap.completionProvider then print("  ✓ Completions") end
      if cap.hoverProvider then print("  ✓ Hover") end
      if cap.definitionProvider then print("  ✓ Go to Definition") end
      if cap.referencesProvider then print("  ✓ Find References") end
      if cap.documentFormattingProvider then print("  ✓ Formatting") end
      if cap.inlayHintProvider then print("  ✓ Inlay Hints") end
      if cap.codeLensProvider then print("  ✓ Code Lens") end
      
      -- Verificar se o buffer atual está attached
      print("\n📄 Buffer atual:")
      print("  Filetype: " .. vim.bo.filetype)
      print("  URI: " .. vim.uri_from_bufnr(0))
      
      -- Verificar workspace folders
      if client.workspace_folders then
        print("\n📁 Workspace folders:")
        for _, folder in ipairs(client.workspace_folders) do
          print("  - " .. folder.name)
        end
      end
      
      -- Testar comunicação
      print("\n🔍 Testando comunicação LSP...")
      local params = vim.lsp.util.make_position_params()
      client.request('textDocument/hover', params, function(err, result)
        if err then
          print("❌ Erro: " .. vim.inspect(err))
        elseif result then
          print("✅ LSP está respondendo!")
        else
          print("⚠️  LSP retornou vazio (símbolo não reconhecido ou análise incompleta)")
        end
      end, 0)
      
    else
      print("❌ Roslyn LSP não está ativo")
      if vim.bo.filetype == 'cs' then
        print("   Buffer é .cs mas LSP não iniciou")
        print("   Tente: :Roslyn restart")
      else
        print("   Abra um arquivo .cs para iniciar o LSP")
      end
    end
    
    -- Mostrar solução atual se disponível
    if vim.g.roslyn_nvim_selected_solution then
      print("\n📁 Solução: " .. vim.g.roslyn_nvim_selected_solution)
    end
    
    -- Verificar dependências
    print("\n💡 Se o LSP não responder, execute:")
    print("   :RoslynRestore")
  end, { desc = 'Verificar status do Roslyn LSP' }),
  
  -- Comando para testar LSP manualmente
  vim.api.nvim_create_user_command('RoslynTest', function()
    local clients = vim.lsp.get_clients({ bufnr = 0, name = 'roslyn' })
    if #clients == 0 then
      print("❌ Roslyn não está ativo")
      return
    end
    
    local client = clients[1]
    print("🧪 Testando Roslyn LSP...")
    
    -- Pegar posição atual
    local params = vim.lsp.util.make_position_params()
    print("📍 Posição: linha " .. (params.position.line + 1) .. ", coluna " .. params.position.character)
    
    -- Teste 1: Hover
    print("\n1️⃣ Testando hover...")
    client.request('textDocument/hover', params, function(err, result)
      if err then
        print("  ❌ Erro: " .. vim.inspect(err))
      elseif result then
        print("  ✅ Hover OK")
      else
        print("  ⚠️  Nenhum hover disponível nesta posição")
      end
    end, 0)
    
    -- Teste 2: Completion
    print("2️⃣ Testando completion...")
    client.request('textDocument/completion', params, function(err, result)
      if err then
        print("  ❌ Erro: " .. vim.inspect(err))
      elseif result then
        local count = result.items and #result.items or (result.isIncomplete and "parcial" or 0)
        print("  ✅ Completion OK (" .. count .. " itens)")
      else
        print("  ⚠️  Nenhuma completion disponível")
      end
    end, 0)
    
    -- Teste 3: Definition
    print("3️⃣ Testando definition...")
    client.request('textDocument/definition', params, function(err, result)
      if err then
        print("  ❌ Erro: " .. vim.inspect(err))
      elseif result then
        local count = type(result) == 'table' and #result or 1
        print("  ✅ Definition OK (" .. count .. " locais)")
      else
        print("  ⚠️  Nenhuma definition disponível nesta posição")
      end
    end, 0)
    
    print("\n⏱️  Aguarde as respostas (veja com :messages)")
  end, { desc = 'Testar comunicação com Roslyn LSP' }),
}
