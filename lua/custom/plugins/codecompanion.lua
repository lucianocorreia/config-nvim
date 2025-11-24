return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'folke/snacks.nvim',
    { 'MeanderingProgrammer/render-markdown.nvim', ft = { 'markdown', 'codecompanion' } },
  },
  config = function()
    require('codecompanion').setup {
      display = {
        action_palette = {
          provider = 'snacks',
        },
        chat = {
          window = {
            layout = 'vertical', -- float|vertical|horizontal|buffer
            border = 'single',
            height = 0.8,
            width = 0.45,
            relative = 'editor',
            opts = {
              breakindent = true,
              cursorcolumn = false,
              cursorline = false,
              foldcolumn = '0',
              linebreak = true,
              list = false,
              signcolumn = 'no',
              spell = false,
              wrap = true,
            },
          },
        },
      },
      strategies = {
        chat = {
          adapter = 'copilot',
        },
        inline = {
          adapter = 'copilot',
        },
      },
    }
  end,
  keys = {
    { '<leader>zc', '<cmd>CodeCompanionChat Toggle<cr>', mode = { 'n', 'v' }, desc = 'CodeCompanion: Chat Toggle' },
    { '<leader>zh', '<cmd>CodeCompanionChat<cr>', mode = { 'n', 'v' }, desc = 'CodeCompanion: Chat com contexto' },
    { '<leader>za', '<cmd>CodeCompanionActions<cr>', mode = { 'n', 'v' }, desc = 'CodeCompanion: Actions' },
    { '<leader>zi', '<cmd>CodeCompanion<cr>', mode = { 'n', 'v' }, desc = 'CodeCompanion: Inline prompt' },
    { '<leader>zv', '<cmd>CodeCompanionChat Add<cr>', mode = 'v', desc = 'CodeCompanion: Add selection to chat' },
  },
}
