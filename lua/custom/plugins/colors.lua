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
    'vague-theme/vague.nvim',
    name = 'vague',
    lazy = false,
    priority = 1000,
    config = function()
      require('vague').setup {
        transparent = false,
        bold = true,
        italic = true,
        on_highlights = function(hl, colors)
          hl.Comment = { fg = colors.comment, italic = true }
          hl.CursorLine = { bg = colors.line }
          hl.FloatBorder = { fg = colors.floatBorder, bg = colors.bg }
          hl.NormalFloat = { bg = colors.bg }
          hl.Visual = { bg = colors.visual }
          hl.WinSeparator = { fg = colors.floatBorder, bg = colors.bg }
        end,
      }

      vim.cmd.colorscheme 'vague'
    end,
  },
}
