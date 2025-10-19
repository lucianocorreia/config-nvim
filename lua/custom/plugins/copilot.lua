return {
  'github/copilot.vim',
  event = 'InsertEnter',
  config = function()
    -- Habilitar Tab para aceitar sugestões
    vim.g.copilot_no_tab_map = false
    vim.g.copilot_assume_mapped = false
    
    -- Keymaps alternativos para navegação
    vim.keymap.set('i', '<C-J>', '<Plug>(copilot-accept)', { desc = 'Aceitar sugestão Copilot' })
    vim.keymap.set('i', '<C-K>', '<Plug>(copilot-next)', { desc = 'Próxima sugestão' })
    vim.keymap.set('i', '<C-L>', '<Plug>(copilot-previous)', { desc = 'Sugestão anterior' })
    vim.keymap.set('i', '<C-Right>', '<Plug>(copilot-accept-word)', { desc = 'Aceitar palavra' })
  end,
}
