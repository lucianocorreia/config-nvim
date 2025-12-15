-- return {
--   { --indentation guides even on blank lines
--     'lukas-reineke/indent-blankline.nvim',
--     -- Enable `lukas-reineke/indent-blankline.nvim`
--     -- See `:help ibl`
--     main = 'ibl',
--     opts = {
--       -- indent = { char = '│', highlight = { 'LineNr' } },
--       indent = { char = '│', highlight = { 'IndentLine' } },
--       scope = { enabled = false },
--     },
--     config = function()
--       -- vim.api.nvim_set_hl(0, 'IndentLine', { fg = '#5c6a72', nocombine = true })
--       vim.api.nvim_set_hl(0, 'IndentLine', { fg = '#886a72', nocombine = true })
--     end,
--   },
-- }
return {
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
      -- Define o highlight - very subtle for Everforest theme
      vim.api.nvim_set_hl(0, 'IndentLine', { fg = '#3a4449', nocombine = true })

      -- Configura o plugin manualmente
      require('ibl').setup {
        indent = {
          char = '│',
          highlight = { 'IndentLine' },
        },
        scope = { enabled = false },
      }
    end,
  },
}
