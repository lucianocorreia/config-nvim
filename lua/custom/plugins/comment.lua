-- Comentários inteligentes com gcc/gc
return {
  'numToStr/Comment.nvim',
  event = 'VeryLazy',
  config = function()
    require('Comment').setup {
      -- Configurações de comentário por filetype
      pre_hook = function(ctx)
        -- Força // para PHP em vez de /* */
        if vim.bo.filetype == 'php' then
          local U = require 'Comment.utils'
          return vim.bo.commentstring == '/*%s*/' and U.get_U() or nil
        end
      end,
    }

    -- Configurar commentstring para PHP usar //
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'php',
      callback = function()
        vim.bo.commentstring = '// %s'
      end,
    })

    -- Configurar commentstring para Blade usar {{-- --}}
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'blade',
      callback = function()
        vim.bo.commentstring = '{{-- %s --}}'
      end,
    })
  end,
}
