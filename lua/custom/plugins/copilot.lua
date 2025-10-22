-- 🚀 GitHub Copilot - Autocompletação IA
return {
  'github/copilot.vim',
  event = 'InsertEnter',
  config = function()
    -- ⚙️ Configurações básicas
    vim.g.copilot_no_tab_map = true         -- Desabilitar Tab padrão (vamos mapear manualmente)
    vim.g.copilot_assume_mapped = true      -- Assumir mapeamentos customizados
    vim.g.copilot_tab_fallback = ""         -- Fallback vazio para Tab
    
    -- 🎨 Configurações visuais
    vim.g.copilot_filetypes = {
      ["*"] = true,                         -- Habilitar para todos os tipos
      gitcommit = true,                     -- Habilitar em commits
      markdown = true,                      -- Habilitar em markdown
      yaml = true,                          -- Habilitar em YAML
    }
    
    -- ⌨️ Keymaps personalizados para navegação
    -- Tab para aceitar sugestão do Copilot
    vim.keymap.set('i', '<Tab>', function()
      local copilot_suggestion = vim.fn['copilot#Accept']('')
      if copilot_suggestion ~= '' then
        return copilot_suggestion
      else
        return vim.api.nvim_replace_termcodes('<Tab>', true, true, true)
      end
    end, { 
      expr = true,
      replace_keycodes = false,
      desc = '✅ Aceitar sugestão Copilot ou Tab normal',
      silent = true 
    })
    
    vim.keymap.set('i', '<C-J>', '<Plug>(copilot-accept)', { 
      desc = '✅ Aceitar sugestão Copilot',
      silent = true 
    })
    
    vim.keymap.set('i', '<C-K>', '<Plug>(copilot-next)', { 
      desc = '⏭️ Próxima sugestão',
      silent = true 
    })
    
    vim.keymap.set('i', '<C-L>', '<Plug>(copilot-previous)', { 
      desc = '⏮️ Sugestão anterior',
      silent = true 
    })
    
    vim.keymap.set('i', '<C-Right>', '<Plug>(copilot-accept-word)', { 
      desc = '📝 Aceitar palavra',
      silent = true 
    })
    
    -- 🔄 Toggle do Copilot
    vim.keymap.set('n', '<leader>cp', '<cmd>Copilot panel<cr>', {
      desc = '📊 Abrir painel Copilot',
      silent = true
    })
    
    vim.keymap.set('n', '<leader>cs', '<cmd>Copilot status<cr>', {
      desc = '📊 Status do Copilot',
      silent = true
    })
    
    -- 🚫 Desabilitar/habilitar Copilot
    vim.keymap.set('n', '<leader>cd', '<cmd>Copilot disable<cr>', {
      desc = '🚫 Desabilitar Copilot',
      silent = true
    })
    
    vim.keymap.set('n', '<leader>ce', '<cmd>Copilot enable<cr>', {
      desc = '✅ Habilitar Copilot',
      silent = true
    })
  end,
}
