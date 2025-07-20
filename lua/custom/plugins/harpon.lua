return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local silent = { silent = true }
    local keymap = vim.keymap

    local harpoon = require 'harpoon'
    -- local extensions = require 'harpoon.extensions'

    harpoon:setup()

    -- old harpoon setup
    -- require('harpoon').setup { excluded_filetypes = { 'NvimTree' } }
    -- local harpoon_ui = require 'harpoon.ui'
    -- local function harpoon_nav_file(file_index)
    --   return function()
    --     harpoon_ui.nav_file(file_index)
    --   end
    -- end

    keymap.set('n', '<leader>ha', function()
      harpoon:list():add()
    end, silent)
    keymap.set('n', '<leader>hq', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, silent)

    keymap.set('n', '<leader>1', function()
      harpoon:list():select(1)
    end, silent)

    keymap.set('n', '<leader>2', function()
      harpoon:list():select(2)
    end, silent)

    keymap.set('n', '<leader>3', function()
      harpoon:list():select(3)
    end, silent)

    keymap.set('n', '<leader>4', function()
      harpoon:list():select(4)
    end, silent)

    keymap.set('n', '<leader>5', function()
      harpoon:list():select(5)
    end, silent)
  end,
}
