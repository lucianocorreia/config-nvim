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
  -- {
  --   'neanias/everforest-nvim',
  --   name = 'everforest-nvim',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.o.background = 'dark'
  --
  --     require('everforest').setup {
  --       background = 'hard',
  --       transparent_background_level = 0,
  --       italics = true,
  --       disable_italic_comments = false,
  --       sign_column_background = 'none',
  --       ui_contrast = 'low',
  --       float_style = 'bright',
  --       inlay_hints_background = 'dimmed',
  --       on_highlights = function(hl, palette)
  --         hl.CursorLine = { bg = palette.bg1 }
  --         hl.FloatBorder = { fg = palette.grey1, bg = palette.bg0 }
  --         hl.NormalFloat = { bg = palette.bg0 }
  --         hl.Visual = { bg = palette.bg_visual }
  --         hl.WinSeparator = { fg = palette.grey1, bg = palette.bg0 }
  --       end,
  --     }
  --
  --     vim.cmd.colorscheme 'everforest'
  --   end,
  -- },
  {
    'AlexvZyl/nordic.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('nordic').setup {
        -- This callback can be used to override the colors used in the base palette.
        on_palette = function(palette) end,
        -- This callback can be used to override the colors used in the extended palette.
        after_palette = function(palette) end,
        -- This callback can be used to override highlights before they are applied.
        on_highlight = function(highlights, palette) end,
        -- Enable bold keywords.
        bold_keywords = false,
        -- Enable italic comments.
        italic_comments = true,
        -- Enable editor background transparency.
        transparent = {
          -- Enable transparent background.
          bg = false,
          -- Enable transparent background for floating windows.
          float = false,
        },
        -- Enable brighter float border.
        bright_border = false,
        -- Reduce the overall amount of blue in the theme (diverges from base Nord).
        reduced_blue = true,
        -- Swap the dark background with the normal one.
        swap_backgrounds = false,
        -- Cursorline options.
        cursorline = {
          -- Bold font in cursorline.
          bold = false,
          -- Bold cursorline number.
          bold_number = true,
          -- Available styles: 'dark', 'light'.
          theme = 'dark',
          -- Blending the cursorline bg with the buffer bg.
          blend = 0.85,
        },
        -- Visual selection options.
        visual = {
          -- Bold font in visual selection.
          bold = false,
          -- Bold visual selection number.
          bold_number = true,
          -- Available styles: 'dark', 'light'.
          theme = 'dark',
          -- Blending the visual selection bg with the buffer bg.
          blend = 0.85,
        },
        noice = {
          -- Available styles: `classic`, `flat`.
          style = 'classic',
        },
        telescope = {
          -- Available styles: `classic`, `flat`.
          style = 'flat',
        },
        leap = {
          -- Dims the backdrop when using leap.
          dim_backdrop = false,
        },
        ts_context = {
          -- Enables dark background for treesitter-context window
          dark_background = true,
        },
      }
      require('nordic').load()
    end,
  },
}
