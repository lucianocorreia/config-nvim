return {
  'kdheepak/lazygit.nvim',
  config = function()
    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set('n', '<leader>lg', '<Cmd>LazyGit<CR>', { desc = 'Lazy [G]it' })
  end,
}
