return {
  { --indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {
      -- indent = { char = "┊", highlight = "LineNr" },
      indent = { char = '│', highlight = { 'LineNr' } },
      scope = { enabled = false },
    },
  },
}
