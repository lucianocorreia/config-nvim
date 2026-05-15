return {
  -- catppuccin/nvim (macchiato)
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        flavour = 'mocha',
        no_underline = true,
        styles = {
          comments = { 'italic' },
          conditionals = {},
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        lsp_styles = {
          virtual_text = {
            errors = {},
            hints = {},
            warnings = {},
            information = {},
            ok = {},
          },
          underlines = {
            errors = {},
            hints = {},
            warnings = {},
            information = {},
            ok = {},
          },
          inlay_hints = {
            background = true,
          },
        },
      }

      vim.cmd.colorscheme 'catppuccin-mocha'

      -- GDScript/LSP pode aplicar estilos semanticos apos o colorscheme.
      -- Mantemos tudo sem italico/sublinhado (exceto comentarios).
    --   local function disable_gdscript_semantic_styles()
    --     local groups = {
    --       '@variable.builtin.gdscript',
    --       '@variable.gdscript',
    --       '@property.gdscript',
    --       '@string.special.symbol.gdscript',
    --       '@punctuation.special.gdscript',
    --       '@lsp.type.variable.gdscript',
    --       '@lsp.mod.defaultLibrary.gdscript',
    --       '@lsp.typemod.variable.defaultLibrary.gdscript',
    --     }

    --     for _, group in ipairs(groups) do
    --       vim.api.nvim_set_hl(0, group, { italic = false, underline = false, undercurl = false })
    --     end
    --   end

    --   vim.api.nvim_create_autocmd({ 'ColorScheme', 'FileType', 'LspAttach' }, {
    --     group = vim.api.nvim_create_augroup('GDScriptNoItalicUnderline', { clear = true }),
    --     callback = function(args)
    --       if args.event == 'ColorScheme' or vim.bo[args.buf].filetype == 'gdscript' then
    --         disable_gdscript_semantic_styles()
    --       end
    --     end,
    --   })

      -- Customizacoes de GDScript (desativadas):
      -- local function apply_gdscript_highlights()
      --   local c = require('catppuccin.palettes').get_palette 'mocha'
      --   vim.api.nvim_set_hl(0, '@function.method.call', { fg = c.teal, bold = false })
      --   vim.api.nvim_set_hl(0, 'TSMethodCall', { fg = c.teal, bold = false })
      --   vim.api.nvim_set_hl(0, 'TSMethod', { fg = c.teal, bold = false })
      --   vim.api.nvim_set_hl(0, '@lsp.type.method', { fg = c.teal, bold = false })
      --   vim.api.nvim_set_hl(0, '@type', { fg = c.yellow, bold = false })
      --   vim.api.nvim_set_hl(0, 'TSType', { fg = c.yellow, bold = false })
      --   vim.api.nvim_set_hl(0, '@lsp.type.type', { fg = c.yellow, bold = false })
      -- end
      --
      -- vim.api.nvim_create_autocmd({ 'ColorScheme', 'FileType' }, {
      --   group = vim.api.nvim_create_augroup('GDScriptSemanticColors', { clear = true }),
      --   callback = function(args)
      --     if
      --       args.event == 'ColorScheme'
      --       or vim.bo[args.buf].filetype == 'gdscript'
      --       or vim.bo[args.buf].filetype == 'gd'
      --       or vim.bo[args.buf].filetype == 'gdscript3'
      --     then
      --       apply_gdscript_highlights()
      --     end
      --   end,
      -- })
    end,
  },
}
