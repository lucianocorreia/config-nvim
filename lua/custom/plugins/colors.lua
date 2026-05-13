return {
  {
    'neanias/everforest-nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('everforest').setup {
        background = 'medium',
        transparent_background_level = 0,
        italics = false,
        disable_italic_comments = true,
        sign_column_background = 'none',
        ui_contrast = 'low',
        show_eob = false,
        colours_override = function(palette)
          palette.red = '#E67E80'
        --   palette.bg0 = '#1f2326'
        --   palette.bg1 = '#23282b'
        --   palette.bg2 = '#272c2f'
        end,
      }

      vim.cmd.colorscheme 'everforest'
    end,
  },

  -- TokyoNight (desativado; manter para testes rápidos)
  -- {
  --   'folke/tokyonight.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require('tokyonight').setup {
  --       style = 'storm',
  --       transparent = false,
  --       terminal_colors = true,
  --       styles = {
  --         comments = { italic = false },
  --         keywords = { italic = false },
  --         functions = {},
  --         variables = {},
  --         sidebars = 'dark',
  --         floats = 'dark',
  --       },
  --     }
  --
  --     vim.cmd.colorscheme 'tokyonight'
  --   end,
  -- },
}
