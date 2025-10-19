-- 🔧 vim-sleuth: Detecta automaticamente tabstop e shiftwidth
-- Detecta automaticamente as configurações de indentação baseado no arquivo atual

return {
  'tpope/vim-sleuth',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    -- Plugin funciona automaticamente, sem configuração adicional necessária
    -- Detecta automaticamente:
    -- - tabstop (tamanho do tab)
    -- - shiftwidth (tamanho da indentação)
    -- - expandtab (usar espaços ao invés de tabs)
    -- baseado no conteúdo do arquivo
  end,
}
