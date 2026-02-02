-- Roslyn C# Language Server
return {
  'seblyng/roslyn.nvim',
  ft = { 'cs' },
  opts = {
    filewatching = "auto",
    broad_search = true,
    
    -- Escolher automaticamente a solução da subpasta quando houver múltiplas
    choose_target = function(targets)
      -- Se houver KlingoNFSe/KlingoNFSe.sln, escolher essa
      return vim.iter(targets):find(function(target)
        if target:match("KlingoNFSe/KlingoNFSe%.sln$") then
          return target
        end
      end) or targets[1] -- Fallback para primeira opção
    end,
    
    config = {
      capabilities = require('blink.cmp').get_lsp_capabilities(),
      
      settings = {
        ['csharp|completion'] = {
          dotnet_show_completion_items_from_unimported_namespaces = true,
          dotnet_show_name_completion_suggestions = true,
          dotnet_provide_regex_completions = true,
        },
        ['csharp|inlay_hints'] = {
          csharp_enable_inlay_hints_for_implicit_object_creation = true,
          csharp_enable_inlay_hints_for_implicit_variable_types = true,
          dotnet_enable_inlay_hints_for_parameters = true,
        },
      },
      
      on_attach = function(client, bufnr)
        -- Mostrar qual target foi escolhido
        if vim.g.roslyn_nvim_selected_solution then
          vim.notify('✅ Roslyn: ' .. vim.fn.fnamemodify(vim.g.roslyn_nvim_selected_solution, ':t'), vim.log.levels.INFO)
        end
      end,
    },
  },
}
