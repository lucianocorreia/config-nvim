return {
  'ThePrimeagen/harpoon',
  config = function()
    local silent = { silent = true }
    local keymap = vim.keymap

    local harpoon_ui = require 'harpoon.ui'

    require('harpoon').setup { excluded_filetypes = { 'NvimTree' } }

    local function harpoon_nav_file(file_index)
      return function()
        harpoon_ui.nav_file(file_index)
      end
    end

    keymap.set('n', '<leader>ha', require('harpoon.mark').add_file, silent)
    keymap.set('n', '<leader>hq', harpoon_ui.toggle_quick_menu, silent)

    keymap.set('n', '<leader>1', harpoon_nav_file(1), silent)
    keymap.set('n', '<leader>2', harpoon_nav_file(2), silent)
    keymap.set('n', '<leader>3', harpoon_nav_file(3), silent)
    keymap.set('n', '<leader>4', harpoon_nav_file(4), silent)
    keymap.set('n', '<leader>5', harpoon_nav_file(5), silent)
    keymap.set('n', '<leader>6', harpoon_nav_file(6), silent)
    keymap.set('n', '<leader>7', harpoon_nav_file(7), silent)
    keymap.set('n', '<leader>8', harpoon_nav_file(8), silent)
    keymap.set('n', '<leader>9', harpoon_nav_file(9), silent)
    keymap.set('n', '<leader>0', harpoon_nav_file(10), silent)
  end,
}
