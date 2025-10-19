return {
  'github/copilot.vim',
  event = 'InsertEnter',
  config = function()
    -- Configurações básicas do Copilot
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_tab_fallback = ""
    
    -- Keymaps para aceitar sugestões
    vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
    vim.api.nvim_set_keymap("i", "<C-K>", 'copilot#Next()', { silent = true, expr = true })
    vim.api.nvim_set_keymap("i", "<C-L>", 'copilot#Previous()', { silent = true, expr = true })
  end,
}
