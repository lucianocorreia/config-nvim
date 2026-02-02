-- Desabilitar semantic tokens do Roslyn ANTES de carregar
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('DisableRoslynSemanticTokens', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == 'roslyn' then
      -- Desabilitar semantic tokens imediatamente
      client.server_capabilities.semanticTokensProvider = nil
      
      -- Forçar refresh do highlighting com Treesitter
      vim.schedule(function()
        if vim.treesitter.highlighter.active[args.buf] then
          vim.treesitter.highlighter.active[args.buf]:destroy()
        end
        vim.treesitter.start(args.buf)
      end)
    end
  end,
})
