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
  end,
}
