return {
  'Bekaboo/dropbar.nvim',
  -- optional, but required for fuzzy finder support
  dependencies = {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
  },
  config = function()
    require('dropbar').setup {
      bar = {
        sources = function(buf, _)
          local sources = require 'dropbar.sources'
          return {
            sources.path,
            sources.lsp,
          }
        end,
      },
    }

    -- Configurar cor do nome do arquivo (mesma cor da lualine)
    vim.api.nvim_set_hl(0, 'DropBarKindFile', { fg = '#e69875', bold = true })
    vim.api.nvim_set_hl(0, 'DropBarIconKindFile', { fg = '#e69875' })

    local dropbar_api = require 'dropbar.api'
    vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
  end,
}
