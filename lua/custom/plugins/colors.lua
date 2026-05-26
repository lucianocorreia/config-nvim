return {
  -- Tema anterior mantido como referencia:
  -- {
  --   'catppuccin/nvim',
  --   name = 'catppuccin',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require('catppuccin').setup {
  --       flavour = 'mocha',
  --       no_underline = true,
  --       no_bold = false,
  --       transparent_background = false,
  --       styles = {
  --         comments = { 'italic' },
  --         conditionals = {},
  --         loops = {},
  --         functions = {},
  --         keywords = {},
  --         strings = {},
  --         variables = {},
  --         numbers = {},
  --         booleans = {},
  --         properties = {},
  --         types = {},
  --         operators = {},
  --       },
  --       lsp_styles = {
  --         virtual_text = {
  --           errors = {},
  --           hints = {},
  --           warnings = {},
  --           information = {},
  --           ok = {},
  --         },
  --         underlines = {
  --           errors = {},
  --           hints = {},
  --           warnings = {},
  --           information = {},
  --           ok = {},
  --         },
  --         inlay_hints = {
  --           background = true,
  --         },
  --       },
  --     }
  --
  --     vim.cmd.colorscheme 'catppuccin-mocha'
  --   end,
  -- },
  {
    'neanias/everforest-nvim',
    name = 'everforest-nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.background = 'dark'

      require('everforest').setup {
        background = 'hard',
        transparent_background_level = 0,
        italics = true,
        disable_italic_comments = false,
        sign_column_background = 'none',
        ui_contrast = 'low',
        float_style = 'bright',
        inlay_hints_background = 'dimmed',
        on_highlights = function(hl, palette)
          hl.CursorLine = { bg = palette.bg1 }
          hl.FloatBorder = { fg = palette.grey1, bg = palette.bg0 }
          hl.NormalFloat = { bg = palette.bg0 }
          hl.Visual = { bg = palette.bg_visual }
          hl.WinSeparator = { fg = palette.grey1, bg = palette.bg0 }
        end,
      }

      vim.cmd.colorscheme 'everforest'
    end,
  },
}
