return {
  -- sainnhe/everforest (original, hard mode)
  {
    'sainnhe/everforest',
    lazy = false,
    priority = 1000,
    config = function()
      local function apply_gdscript_highlights()
        -- Distinguish methods from types for GDScript (closer to VS Code/Zed).
        local method_fg = '#7FBBB3'
        local type_fg = '#DBBC7F'

        vim.api.nvim_set_hl(0, '@function.method.call', { fg = method_fg, bold = false })
        vim.api.nvim_set_hl(0, 'TSMethodCall', { fg = method_fg, bold = false })
        vim.api.nvim_set_hl(0, 'TSMethod', { fg = method_fg, bold = false })
        vim.api.nvim_set_hl(0, '@lsp.type.method', { fg = method_fg, bold = false })

        vim.api.nvim_set_hl(0, '@type', { fg = type_fg, bold = false })
        vim.api.nvim_set_hl(0, 'TSType', { fg = type_fg, bold = false })
        vim.api.nvim_set_hl(0, '@lsp.type.type', { fg = type_fg, bold = false })
      end

      vim.g.everforest_background = 'hard'
      vim.g.everforest_enable_italic = 0
      vim.g.everforest_disable_italic_comment = 1
      vim.g.everforest_sign_column_background = 'none'
      vim.g.everforest_ui_contrast = 'low'
      vim.g.everforest_show_eob = 0
      vim.g.everforest_better_performance = 1

      vim.cmd.colorscheme 'everforest'

      apply_gdscript_highlights()

      vim.api.nvim_create_autocmd({ 'ColorScheme', 'FileType' }, {
        group = vim.api.nvim_create_augroup('GDScriptSemanticColors', { clear = true }),
        callback = function(args)
          if args.event == 'ColorScheme' or vim.bo[args.buf].filetype == 'gdscript' or vim.bo[args.buf].filetype == 'gd' or vim.bo[args.buf].filetype == 'gdscript3' then
            apply_gdscript_highlights()
          end
        end,
      })
    end,
  },

  -- neanias/everforest-nvim (comentado para teste com sainnhe/everforest)
  -- {
  --   'neanias/everforest-nvim',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require('everforest').setup {
  --       background = 'medium',
  --       transparent_background_level = 0,
  --       italics = false,
  --       disable_italic_comments = true,
  --       sign_column_background = 'none',
  --       ui_contrast = 'low',
  --       show_eob = false,
  --       colours_override = function(palette)
  --         palette.red = '#E67E80'
  --       end,
  --     }
  --
  --     vim.cmd.colorscheme 'everforest'
  --   end,
  -- },
}
