-- Fidget: LSP status updates
return {
  'j-hui/fidget.nvim',
  opts = {
    -- Configuration for fidget
    -- Notification window settings
    notification = {
      window = {
        normal_hl = 'Comment',
        winblend = 100,
        border = 'none',
        zindex = 45,
        max_width = 0,
        max_height = 0,
        x_padding = 1,
        y_padding = 0,
        align = 'bottom',
        relative = 'win',
      },
      view = {
        stack_upwards = true,
        icon_separator = ' ',
        group_separator = '---',
        group_separator_hl = 'Comment',
      },
    },
  },
}
