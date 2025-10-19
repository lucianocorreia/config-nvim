-- C# Language Server - Comandos auxiliares para Roslyn
return {
  vim.api.nvim_create_user_command('RoslynInstall', function()
    vim.cmd('MasonInstall roslyn')
  end, { desc = 'Install Roslyn via Mason' }),

  vim.api.nvim_create_user_command('RoslynStatus', function()
    local mason_registry_ok, mason_registry = pcall(require, 'mason-registry')
    if mason_registry_ok and mason_registry.is_installed('roslyn') then
      print("✅ Roslyn installed")
    else
      print("❌ Roslyn not installed - run :RoslynInstall")
    end
    
    local clients = vim.lsp.get_clients()
    local roslyn_active = false
    for _, client in ipairs(clients) do
      if client.name == 'roslyn' then
        roslyn_active = true
        print("✅ Roslyn LSP active (ID: " .. client.id .. ")")
      end
    end
    
    if not roslyn_active then
      print("⚠️  Roslyn LSP not active")
    end
  end, { desc = 'Check Roslyn status' }),

  
}
