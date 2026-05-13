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
  end,
}
