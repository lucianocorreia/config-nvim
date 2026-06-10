local codelens_group = vim.api.nvim_create_augroup('corr3ia-roslyn-codelens', { clear = false })

local function get_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok, blink = pcall(require, 'blink.cmp')
  if ok and type(blink.get_lsp_capabilities) == 'function' then
    capabilities = blink.get_lsp_capabilities()
  end

  capabilities.textDocument = capabilities.textDocument or {}
  capabilities.textDocument.diagnostic = vim.tbl_deep_extend('force', capabilities.textDocument.diagnostic or {}, {
    dynamicRegistration = true,
  })

  return capabilities
end

local function longest_common_prefix_length(left, right)
  local max_len = math.min(#left, #right)
  local i = 0

  while i < max_len and left:sub(i + 1, i + 1) == right:sub(i + 1, i + 1) do
    i = i + 1
  end

  return i
end

local function choose_closest_target(targets)
  local current_path = vim.api.nvim_buf_get_name(0)
  if current_path == '' then
    return targets[1]
  end

  local csproj = vim.fs.find(function(name)
    return name:match('%.csproj$') ~= nil
  end, { upward = true, path = current_path })[1]

  if csproj then
    local csproj_dir = vim.fs.dirname(csproj)
    local csproj_name = vim.fs.basename(csproj):gsub('%.csproj$', '')

    for _, target in ipairs(targets) do
      if vim.fs.dirname(target) == csproj_dir then
        return target
      end
    end

    for _, target in ipairs(targets) do
      if vim.fs.basename(target):gsub('%.slnx?$', ''):gsub('%.slnf$', '') == csproj_name then
        return target
      end
    end
  end

  table.sort(targets, function(left, right)
    local left_score = longest_common_prefix_length(current_path, left)
    local right_score = longest_common_prefix_length(current_path, right)

    if left_score == right_score then
      return #left > #right
    end

    return left_score > right_score
  end)

  return targets[1]
end

return {
  'seblyng/roslyn.nvim',
  lazy = false,
  opts = {
    filewatching = 'auto',
    broad_search = true,
    choose_target = choose_closest_target,
    silent = true,
  },
  config = function(_, opts)
    require('roslyn').setup(opts)

    vim.lsp.config('roslyn', {
      cmd = { 'roslyn-language-server', '--stdio' },
      cmd_env = {
        Configuration = vim.env.Configuration or 'Debug',
        TMPDIR = vim.env.TMPDIR and vim.fn.resolve(vim.env.TMPDIR) or nil,
      },
      filetypes = { 'cs' },
      capabilities = get_capabilities(),
      settings = {
        ['csharp|background_analysis'] = {
          dotnet_analyzer_diagnostics_scope = 'fullSolution',
          dotnet_compiler_diagnostics_scope = 'fullSolution',
        },
        ['csharp|completion'] = {
          dotnet_show_name_completion_suggestions = true,
          dotnet_show_completion_items_from_unimported_namespaces = true,
          dotnet_provide_regex_completions = true,
        },
        ['csharp|code_lens'] = {
          dotnet_enable_references_code_lens = true,
          dotnet_enable_tests_code_lens = true,
        },
        ['csharp|formatting'] = {
          dotnet_organize_imports_on_format = true,
        },
        ['csharp|inlay_hints'] = {
          csharp_enable_inlay_hints_for_implicit_object_creation = true,
          csharp_enable_inlay_hints_for_implicit_variable_types = true,
          csharp_enable_inlay_hints_for_lambda_parameter_types = true,
          csharp_enable_inlay_hints_for_types = true,
          dotnet_enable_inlay_hints_for_indexer_parameters = true,
          dotnet_enable_inlay_hints_for_literal_parameters = true,
          dotnet_enable_inlay_hints_for_object_creation_parameters = true,
          dotnet_enable_inlay_hints_for_other_parameters = true,
          dotnet_enable_inlay_hints_for_parameters = true,
          dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
          dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
          dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
        },
        ['csharp|symbol_search'] = {
          dotnet_search_reference_assemblies = true,
        },
      },
      on_attach = function(client, bufnr)
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, bufnr) then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end

        if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens, bufnr) then
          vim.lsp.codelens.enable(true, { bufnr = bufnr })

          vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
            group = codelens_group,
            buffer = bufnr,
            callback = function()
              vim.lsp.codelens.enable(true, { bufnr = bufnr })
            end,
            desc = 'Refresh Roslyn code lens',
          })
        end
      end,
    })
  end,
}
