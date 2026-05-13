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
  end,
}
