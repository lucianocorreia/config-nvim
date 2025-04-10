return {
  'kdheepak/lazygit.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    -- keymap.set('n', '<leader>lg', '<Cmd>LazyGit<CR>', { desc = 'Lazy [G]it' })
  end,
}
