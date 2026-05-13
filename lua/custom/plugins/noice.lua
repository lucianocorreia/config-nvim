return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
  opts = {
    cmdline = {
      enabled = true,
      view = 'cmdline_popup',
      format = {
        cmdline = { pattern = '^:', icon = '', lang = 'vim' },
        search_down = { kind = 'search', pattern = '^/', icon = ' ', lang = 'regex', view = 'cmdline_popup' },
        search_up = { kind = 'search', pattern = '^%?', icon = ' ', lang = 'regex', view = 'cmdline_popup' },
      },
    },
    lsp = {
      progress = { enabled = false },
      hover = { enabled = true },
      signature = { enabled = true },
      message = { enabled = true },
      documentation = {
        view = 'hover',
        opts = {
          border = 'rounded',
        },
      },
    },
    presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = true,
    },
    routes = {
      {
        filter = {
          event = 'notify',
          find = 'No information available',
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = 'msg_show',
          find = 'written',
        },
        opts = { skip = true },
      },
    },
  },
  config = function(_, opts)
    local ok_notify, notify = pcall(require, 'notify')
    if ok_notify then
      notify.setup({
        stages = 'fade',
        timeout = 2500,
        render = 'compact',
      })
      vim.notify = notify
    end

    require('noice').setup(opts)
  end,
}
