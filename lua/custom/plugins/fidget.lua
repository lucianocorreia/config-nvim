-- Fidget: LSP progress + notificações discretas no rodapé
return {
  'j-hui/fidget.nvim',
  opts = {
    progress = {
      display = {
        done_icon = '✓',
      },
    },
    notification = {
      window = {
        winblend = 0,
        border = 'none',
        align = 'bottom',
        relative = 'editor',
      },
      configs = {
        default = {
          name = '',
        },
      },
    },
  },
}
