-- Fidget: LSP status updates
return {
  'j-hui/fidget.nvim',
  config = function()
    require('fidget').setup {
      progress = {
        display = {
          done_icon = '✓',
        },
      },
      notification = {
        window = {
          winblend = 0,
          relative = 'editor',
        },
        configs = {
          default = {
            name = '',
          },
        },
      },
    }
  end,
}
