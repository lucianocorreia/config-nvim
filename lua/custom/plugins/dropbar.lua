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

    local dropbar_api = require 'dropbar.api'
    vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
  end,
}
