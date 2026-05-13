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
}
