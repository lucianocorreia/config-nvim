return {
  'stevearc/quicker.nvim',
  event = 'VeryLazy',
  ---@module "quicker"
  ---@type quicker.SetupOptions
  opts = {
    keys = {
      {
        '>',
        function()
          require('quicker').expand { before = 2, after = 2, add_to_existing = true }
        end,
        desc = 'Expandir contexto do quickfix',
      },
      {
        '<',
        function()
          require('quicker').collapse()
        end,
        desc = 'Colapsar contexto do quickfix',
      },
    },
  },
  config = function(_, opts)
    require('quicker').setup(opts)

    -- Keymaps para abrir/fechar quickfix e loclist
    vim.keymap.set('n', '<leader>ql', function()
      require('quicker').toggle()
    end, {
      desc = 'Toggle quickfix',
    })

    -- vim.keymap.set('n', '<leader>l', function()
    --   require('quicker').toggle { loclist = true }
    -- end, {
    --   desc = 'Toggle loclist',
    -- })
  end,
}
