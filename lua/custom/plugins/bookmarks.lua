return {
  'tomasky/bookmarks.nvim',
  -- after = "telescope.nvim",
  event = 'VimEnter',
  config = function()
    require('bookmarks').setup {
      on_attach = function(_)
        local bm = require 'bookmarks'
        local map = vim.keymap.set
        map('n', '<leader>mm', bm.bookmark_toggle, { desc = 'Add or remove bookmark at current line' }) -- add or remove bookmark at current line
        map('n', '<leader>mi', bm.bookmark_ann, { desc = 'Add or edit mark annotation at current line' }) -- add or edit mark annotation at current line
        map('n', '<leader>mc', bm.bookmark_clean, { desc = 'Clean all marks in local buffer' }) -- clean all marks in local buffer
        map('n', '<leader>mn', bm.bookmark_next, { desc = 'Jump to next mark in local buffer' }) -- jump to next mark in local buffer
        map('n', '<leader>mp', bm.bookmark_prev, { desc = 'Jump to previous mark in local buffer' }) -- jump to previous mark in local buffer
        map('n', '<leader>ml', bm.bookmark_list, { desc = 'Show marked file list in quickfix window' }) -- show marked file list in quickfix window
        map('n', '<leader>mx', bm.bookmark_clear_all, { desc = 'Remove all bookmarks' }) -- removes all bookmarks
      end,
    }
  end,
}
