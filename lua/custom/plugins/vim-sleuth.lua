-- 🔧 vim-sleuth: Detecta automaticamente tabstop e shiftwidth
-- Detecta automaticamente as configurações de indentação baseado no arquivo atual

return {
  'tpope/vim-sleuth',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    -- Configurar para não sobrescrever configurações específicas de filetype
    vim.g.sleuth_automatic = 1
    
    -- Permitir que autocmds de filetype tenham precedência
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('sleuth-override', { clear = true }),
      pattern = 'cs',
      callback = function()
        -- Para C#, manter nossas configurações explícitas
        vim.b.sleuth_found = 1 -- Evita que o sleuth altere as configurações
      end,
    })
  end,
}
