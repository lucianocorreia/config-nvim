-- Roslyn C# Language Server
return {
  'seblyng/roslyn.nvim',
  ft = { 'cs' },
  opts = {
    filewatching = 'auto',
    silent = true,
  },
  init = function()
    vim.lsp.config('roslyn', {
      settings = {
        ['csharp|inlay_hints'] = {
          csharp_enable_inlay_hints_for_implicit_object_creation = true,
          csharp_enable_inlay_hints_for_implicit_variable_types = true,
          csharp_enable_inlay_hints_for_lambda_parameter_types = true,
          csharp_enable_inlay_hints_for_types = true,
          dotnet_enable_inlay_hints_for_parameters = true,
          dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
          dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
        },
        ['csharp|code_lens'] = {
          dotnet_enable_references_code_lens = true,
          dotnet_enable_tests_code_lens = true,
        },
        ['csharp|completion'] = {
          dotnet_provide_regex_completions = true,
          dotnet_show_completion_items_from_unimported_namespaces = true,
          dotnet_show_name_completion_suggestions = true,
        },
        ['csharp|symbol_search'] = {
          dotnet_search_reference_assemblies = true,
        },
        ['csharp|code_style'] = {
          dotnet_prefer_auto_properties = true,
          dotnet_prefer_inferred_tuple_names = true,
          dotnet_prefer_inferred_anonymous_type_member_names = true,
          dotnet_prefer_compound_assignment = true,
          dotnet_prefer_simplified_interpolation = true,
          dotnet_prefer_conditional_expression_over_assignment = true,
          dotnet_prefer_conditional_expression_over_return = true,
        },
        ['csharp|formatting'] = {
          dotnet_sort_system_directives_first = true,
          dotnet_separate_import_directive_groups = false,
        },
      },
      init_options = {
        -- Inlay Hints
        ['roslyn.inlay_hints.enable_inlay_hints_for_parameters'] = true,
        ['roslyn.inlay_hints.enable_inlay_hints_for_literal_types'] = true,
        ['roslyn.inlay_hints.enable_inlay_hints_for_indexer_parameters'] = true,
        ['roslyn.inlay_hints.enable_inlay_hints_for_object_creation'] = true,
        ['roslyn.inlay_hints.enable_inlay_hints_for_other'] = true,
        ['roslyn.inlay_hints.enable_inlay_hints_for_everything_else'] = true,
        
        -- Completion preferences
        ['roslyn.preferences.include_completed_file_path_in_suggestion'] = false,
        ['roslyn.preferences.add_missing_usings_on_completion'] = true,
        ['roslyn.completion.provide_override_completions'] = true,
        ['roslyn.completion.show_completion_items_from_unimported_namespaces'] = true,
        
        -- Code Actions
        ['roslyn.code_actions.enable_experimental_code_actions'] = true,
        
        -- Diagnostics
        ['roslyn.diagnostics.enable_experimental_diagnostics'] = false,
        ['roslyn.diagnostics.analyzer_diagnostics_scope'] = 'openFiles',
        ['roslyn.diagnostics.compiler_diagnostics_scope'] = 'openFiles',
        
        -- Quick Info
        ['roslyn.quick_info.show_remarks_in_quick_info'] = true,
        
        -- Navigation
        ['roslyn.navigation.navigate_to_decompiled_sources'] = true,
        ['roslyn.navigation.navigate_to_source_link_target'] = true,
      },
    })
  end,
}
