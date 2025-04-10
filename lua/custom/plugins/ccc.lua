return {
  'uga-rosa/ccc.nvim',
  config = function()
    require('ccc').setup()

    local keymap = vim.keymap

    keymap.set('n', '<leader>cco', '<Cmd>CccPick<CR>', { desc = 'Ccc [O]pen', silent = true })
    keymap.set('n', '<leader>ccc', '<Cmd>CccHighlighterToggle<CR>', { desc = 'Ccc [C]olor [C]olumn', silent = true })
    keymap.set('n', '<leader>ccv', '<Cmd>CccConvert<CR>', { desc = 'Ccc [C]onvert', silent = true })
  end,
}
