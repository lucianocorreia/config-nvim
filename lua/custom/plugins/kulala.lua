return {
  'mistweaverco/kulala.nvim',
  ft = 'http',
  config = function()
    require('kulala').setup({
      default_view = 'body',
      default_env = 'dev',
      debug = false,
      contenttypes = {
        ['application/json'] = {
          ft = 'json',
          formatter = { 'jq', '.' },
        },
        ['application/xml'] = {
          ft = 'xml',
          formatter = { 'xmllint', '--format', '-' },
        },
        ['text/html'] = {
          ft = 'html',
          formatter = { 'xmllint', '--format', '--html', '-' },
        },
      },
    })

    -- Keymaps para kulala (usando <leader>h de HTTP)
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'http',
      callback = function()
        local opts = { buffer = true, silent = true }
        vim.keymap.set('n', '<leader>hr', require('kulala').run, vim.tbl_extend('force', opts, { desc = '[H]TTP [R]un request' }))
        vim.keymap.set('n', '<leader>hi', require('kulala').inspect, vim.tbl_extend('force', opts, { desc = '[H]TTP [I]nspect' }))
        vim.keymap.set('n', '<leader>ht', require('kulala').toggle_view, vim.tbl_extend('force', opts, { desc = '[H]TTP [T]oggle view' }))
        vim.keymap.set('n', '<leader>hp', require('kulala').jump_prev, vim.tbl_extend('force', opts, { desc = '[H]TTP [P]revious' }))
        vim.keymap.set('n', '<leader>hn', require('kulala').jump_next, vim.tbl_extend('force', opts, { desc = '[H]TTP [N]ext' }))
        vim.keymap.set('n', '<leader>hc', require('kulala').copy, vim.tbl_extend('force', opts, { desc = '[H]TTP [C]opy as cURL' }))
      end,
    })
  end,
}
