-- Roslyn C# Language Server
return {
  'seblyng/roslyn.nvim',
  ft = { 'cs' },
  opts = {
    filewatching = 'auto',
    broad_search = false,
    lock_target = false,
    silent = true,
    debug = false,
  },
  init = function()
    vim.lsp.config('roslyn', {
      settings = {
        ['csharp|inlay_hints'] = {
          csharp_enable_inlay_hints_for_implicit_object_creation = true,
          csharp_enable_inlay_hints_for_implicit_variable_types = true,
          csharp_enable_inlay_hints_for_lambda_parameter_types = true,
          csharp_enable_inlay_hints_for_types = true,
        },
        ['csharp|code_lens'] = {
          dotnet_enable_references_code_lens = true,
        },
        ['csharp|completion'] = {
          dotnet_provide_regex_completions = true,
          dotnet_show_completion_items_from_unimported_namespaces = true,
        },
        ['csharp|symbol_search'] = {
          dotnet_search_reference_assemblies = true,
        },
      },
      init_options = {
        ['roslyn.inlay_hints.enable_inlay_hints_for_parameters'] = true,
        ['roslyn.inlay_hints.enable_inlay_hints_for_literal_types'] = true,
        ['roslyn.inlay_hints.enable_inlay_hints_for_indexer_parameters'] = true,
        ['roslyn.inlay_hints.enable_inlay_hints_for_object_creation'] = true,
        ['roslyn.inlay_hints.enable_inlay_hints_for_other'] = true,
        ['roslyn.inlay_hints.enable_inlay_hints_for_everything_else'] = true,
        -- Desabilitar warnings específicos
        ['roslyn.preferences.include_completed_file_path_in_suggestion'] = false,
        ['roslyn.preferences.add_missing_usings_on_completion'] = true,
      },
    })
  end,
}
