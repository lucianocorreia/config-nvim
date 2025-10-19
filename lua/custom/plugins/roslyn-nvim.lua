-- Roslyn C# Language Server
return {
  "seblyng/roslyn.nvim",
  ft = { "cs" },
  opts = {
    filewatching = "auto",
    broad_search = false,
    lock_target = false,
    silent = false,
    debug = false,
  },
  init = function()
    vim.lsp.config("roslyn", {
      settings = {
        ["csharp|inlay_hints"] = {
          csharp_enable_inlay_hints_for_implicit_object_creation = true,
          csharp_enable_inlay_hints_for_implicit_variable_types = true,
          csharp_enable_inlay_hints_for_lambda_parameter_types = true,
          csharp_enable_inlay_hints_for_types = true,
        },
        ["csharp|code_lens"] = {
          dotnet_enable_references_code_lens = true,
        },
      },
    })
  end,
}
