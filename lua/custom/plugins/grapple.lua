return {
  'cbochs/grapple.nvim',
  dependencies = {
    { 'nvim-tree/nvim-web-devicons', lazy = true },
  },
  event = { 'BufReadPost', 'BufNewFile' },
  cmd = 'Grapple',
  opts = {
    scope = 'git',
  },
  keys = {
    { '<leader>ha', '<cmd>Grapple toggle<cr>',      desc = 'Grapple: toggle tag' },
    { '<leader>hq', '<cmd>Grapple toggle_tags<cr>', desc = 'Grapple: toggle tags menu' },
    { '<leader>1',  '<cmd>Grapple select index=1<cr>', desc = 'Grapple: select tag 1' },
    { '<leader>2',  '<cmd>Grapple select index=2<cr>', desc = 'Grapple: select tag 2' },
    { '<leader>3',  '<cmd>Grapple select index=3<cr>', desc = 'Grapple: select tag 3' },
    { '<leader>4',  '<cmd>Grapple select index=4<cr>', desc = 'Grapple: select tag 4' },
    { '<leader>5',  '<cmd>Grapple select index=5<cr>', desc = 'Grapple: select tag 5' },
  },
}
