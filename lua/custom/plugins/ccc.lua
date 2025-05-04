return {
  'uga-rosa/ccc.nvim',
  config = function()
    require('ccc').setup {
      highlighter = {
        auto_enable = true,
        lsp = true,
        lsp_rename = true,
        lsp_formatting = true,
      },
      formats = {
        css = { 'hex', 'rgb', 'hsl' },
        scss = { 'hex', 'rgb', 'hsl' },
        sass = { 'hex', 'rgb', 'hsl' },
        less = { 'hex', 'rgb', 'hsl' },
        stylus = { 'hex', 'rgb', 'hsl' },
      },
    }

    local keymap = vim.keymap

    keymap.set('n', '<leader>cco', '<Cmd>CccPick<CR>', { desc = 'Ccc [O]pen', silent = true })
    keymap.set('n', '<leader>ccc', '<Cmd>CccHighlighterToggle<CR>', { desc = 'Ccc [C]olor [C]olumn', silent = true })
    keymap.set('n', '<leader>ccv', '<Cmd>CccConvert<CR>', { desc = 'Ccc [C]onvert', silent = true })
  end,
}
