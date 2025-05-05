return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      -- sections = {lualine_c = {"filename", {getWords}}, lualine_x = {{getGuiFont}, 'filetype'}},
      options = {
        icons_enabled = true,
        theme = 'catppuccin',
        -- theme = 'everforest',
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
              added = { fg = '#a6e3a1' },
              modified = { fg = '#f9e2af' },
              removed = { fg = '#f38ba8' },
            },
            symbols = { added = '⊕ ', modified = '⊙ ', removed = '⊖ ' }, -- Changes the symbols used by the diff.
          },
          {
            'filename',
            file_status = true, -- Displays file status (readonly status, modified status)
            newfile_status = true, -- Display new file status (new file means no write after created)
            path = 0, -- 0: Just the filename
            -- 1: Relative path
            -- 2: Absolute path
            -- 3: Absolute path, with tilde as the home directory
            -- 4: Filename and parent dir, with tilde as the home directory
            shorting_target = 40, -- Shortens path to leave 40 spaces in the window
            -- for other components. (terrible name, any suggestions?)
            symbols = {
              modified = '[+]', -- Text to show when the file is modified.
              readonly = '[-]', -- Text to show when the file is non-modifiable or readonly.
              unnamed = '[No Name]', -- Text to show for unnamed buffers.
              newfile = '[New]', -- Text to show for newly created file before first write
            },
          },
          'searchcount',
          'selectioncount',
        },
        lualine_x = {
          {
            function()
              return vim.api.nvim_get_current_buf()
            end,
            color = { fg = '#f9e2af' },
          },
          {
            function()
              return require('noice').api.status.command.get()
            end,
            cond = function()
              return package.loaded['noice'] and require('noice').api.status.command.has()
            end,
            color = { fg = '#cba6f7' },
          },
          'encoding',
          {
            'filetype',
            icon_only = true,
          },
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
      -- extensions = { 'nvim-tree', 'lazy' },
    }
  end,
}
