return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  opts = {
    notify = {},
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
      -- Suprime a mensagem nativa de arquivo salvo ("X lines written")
      {
        filter = { event = 'msg_show', kind = '', find = 'written' },
        opts = { skip = true },
      },
      -- Garante que vim.notify não aparece como popup do noice
      {
        filter = { event = 'notify' },
        opts = { skip = true },
      },
    },
  },
  config = function(_, opts)
    require('noice').setup(opts)
  end,
}
