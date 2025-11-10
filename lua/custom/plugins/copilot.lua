-- 🚀 GitHub Copilot - Versão moderna e mais rápida
return {
  'zbirenbaum/copilot.lua',
  -- dependencies = {
  --   {
  --     'copilotlsp-nvim/copilot-lsp',
  --     init = function()
  --       vim.g.copilot_nes_debounce = 500
  --     end,
  --   },
  -- },
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
          position = 'bottom', -- | top | left | right
          ratio = 0.4,
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true, -- Sugestões automáticas (como no VS Code)
        hide_during_completion = false,
        debounce = 75, -- Delay em ms (VS Code usa ~75ms)
        keymap = {
          accept = false, -- Desabilita mapeamento padrão do Tab
          accept_word = '<C-Right>',
          accept_line = '<C-Down>',
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-e>',
        },
      },
      -- NES (Next Edit Suggestion) - Ainda em desenvolvimento
      -- nes = {
      --   enabled = true,
      --   keymap = {
      --     accept_and_goto = '<C-j>',
      --     accept = '<C-l>',
      --     dismiss = '<C-h>',
      --   },
      -- },
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
      copilot_node_command = 'node', -- Node.js version must be > 18.x
      server_opts_overrides = {},
    }

    -- Mapeamento inteligente do Tab: aceita sugestão se houver, senão insere tab normal
    vim.keymap.set('i', '<Tab>', function()
      if require('copilot.suggestion').is_visible() then
        require('copilot.suggestion').accept()
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, false, true), 'n', false)
      end
    end, { desc = 'Aceita sugestão do Copilot ou Tab normal' })
  end,
}
