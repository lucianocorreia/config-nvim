return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'AndreM222/copilot-lualine',
  },
  config = function()
    local function codecompanion_adapter_name()
      local chat = require('codecompanion').buf_get_chat(vim.api.nvim_get_current_buf())
      if not chat then
        return nil
      end
      return ' ' .. chat.adapter.formatted_name
    end

    local function codecompanion_current_model_name()
      local chat = require('codecompanion').buf_get_chat(vim.api.nvim_get_current_buf())
      if not chat then
        return nil
      end
      return chat.settings.model
    end

    require('lualine').setup {
      -- sections = {lualine_c = {"filename", {getWords}}, lualine_x = {{getGuiFont}, 'filetype'}},
      options = {
        icons_enabled = true,
        theme = 'everforest',
        -- theme = 'ayu',
        -- theme = 'vague',
        -- theme = 'rose-pine',
        -- theme = 'catppuccin',
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
            color = { fg = '#e69875' },
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
      extensions = {
        {
          filetypes = { 'codecompanion' },
          sections = {
            lualine_a = { 'mode' },
            lualine_b = {
              codecompanion_adapter_name,
            },
            lualine_c = {
              codecompanion_current_model_name,
            },
            lualine_x = {},
            lualine_y = {
              'progress',
            },
            lualine_z = {
              'location',
            },
          },
          inactive_sections = {
            lualine_a = {},
            lualine_b = {
              codecompanion_adapter_name,
            },
            lualine_c = {},
            lualine_x = {},
            lualine_y = {
              'progress',
            },
            lualine_z = {},
          },
        },
      },
    }
  end,
}
