return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'AndreM222/copilot-lualine',
  },
  config = function()
    require('lualine').setup {
      -- sections = {lualine_c = {"filename", {getWords}}, lualine_x = {{getGuiFont}, 'filetype'}},
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = {
          {
            'diff',
            colored = true, -- Displays a colored diff status if set to true
            diff_color = {
              added = { fg = '#a6da95' },
              modified = { fg = '#eed49f' },
              removed = { fg = '#ed8796' },
            },
            symbols = { added = '⊕ ', modified = '⊙ ', removed = '⊖ ' }, -- Changes the symbols used by the diff.
          },
          {
            'filetype',
            icon_only = true,
            padding = { left = 1, right = 0 },
          },
          {
            'filename',
            file_status = true,
            newfile_status = true,
            path = 0,
            shorting_target = 40,
            symbols = {
              modified = '[+]',
              readonly = '[-]',
              unnamed = '[No Name]',
              newfile = '[New]',
            },
          },
          'searchcount',
          'selectioncount',
        },
        lualine_x = {
          'copilot',
          {
            function()
              return vim.api.nvim_get_current_buf()
            end,
          },
          'encoding',
          -- {
          --   'filetype',
          --   icon_only = true,
          -- },
        },
        lualine_y = {
          {
            'diagnostics',
            sources = { 'nvim_diagnostic', 'nvim_lsp' },
            sections = { 'error', 'warn', 'info', 'hint' },
            diagnostics_color = {
              -- Same values as the general color option can be used here.
              error = 'DiagnosticError', -- Changes diagnostics' error color.
              warn = 'DiagnosticWarn', -- Changes diagnostics' warn color.
              info = 'DiagnosticInfo', -- Changes diagnostics' info color.
              hint = 'DiagnosticHint', -- Changes diagnostics' hint color.
            },
            symbols = { error = ' ', warn = ' ', hint = ' ', info = ' ' },
            colored = true, -- Displays diagnostics status in color if set to true.
            update_in_insert = false, -- Update diagnostics in insert mode.
            always_visible = false, -- Show diagnostics even if there are none.
          },
        },
        lualine_z = { 'progress', 'location' },
      },
    }
  end,
}
