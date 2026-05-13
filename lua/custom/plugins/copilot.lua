-- 🚀 GitHub Copilot - Inline suggestions (separado do NES)
return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup {
      panel = {
        enabled = true,
        auto_refresh = true,
        keymap = {
          jump_prev = '[[',
          jump_next = ']]',
          accept = '<CR>',
          refresh = 'gr',
          open = '<M-CR>',
        },
        layout = {
          position = 'bottom',
          ratio = 0.4,
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = false,
        debounce = 75,
        keymap = {
          accept = false, -- Desabilita para usar custom Tab
          accept_word = '<M-w>',
          accept_line = '<M-l>',
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-e>',
        },
      },
      filetypes = {
        yaml = true,
        markdown = true,
        help = false,
        gitcommit = true,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ['.'] = false,
      },
      copilot_node_command = 'node',
      server_opts_overrides = {},
    }
  end,
}
