return {
  'mfussenegger/nvim-jdtls',
  lazy = false,
  config = function()
    require('corr3ia.java-setup').register_commands()
  end,
}
