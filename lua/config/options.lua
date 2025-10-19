-- ⚙️ Configurações do Neovim
-- Este arquivo contém todas as configurações básicas do editor

-- Leaders
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Nerd Font
vim.g.have_nerd_font = true

-- 📊 Interface
vim.opt.number = true              -- Números de linha
vim.opt.relativenumber = true      -- Números relativos
vim.opt.termguicolors = true       -- Cores true color
vim.opt.showmode = false           -- Não mostrar modo (já temos na statusline)
vim.opt.wrap = false               -- Não quebrar linhas
vim.opt.cursorline = true          -- Destacar linha atual
vim.opt.signcolumn = 'yes'         -- Sempre mostrar coluna de sinais
vim.opt.list = false               -- Não mostrar caracteres invisíveis

-- 🖱️ Mouse e Interação
vim.opt.mouse = 'a'                -- Habilitar mouse

-- 📋 Clipboard
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus' -- Usar clipboard do sistema
end)

-- 📑 Indentação e Tabs
vim.opt.tabstop = 4        -- Largura do tab visual
vim.opt.softtabstop = 4    -- Largura do tab ao editar
vim.opt.shiftwidth = 4     -- Largura da indentação
vim.opt.expandtab = true   -- Converter tabs em espaços
vim.opt.autoindent = true  -- Auto indentação
vim.opt.smartindent = true -- Indentação inteligente

-- 🔤 Texto e Edição
vim.opt.breakindent = true         -- Manter indentação em quebras
vim.opt.undofile = true            -- Arquivo de undo persistente
vim.opt.confirm = true             -- Confirmar antes de sair sem salvar

-- 🔍 Busca
vim.opt.ignorecase = true          -- Ignorar case na busca
vim.opt.smartcase = true           -- Case sensitive se contém maiúscula
vim.opt.inccommand = 'split'       -- Preview de substituições

-- ⏱️ Timing
vim.opt.updatetime = 250           -- Tempo para salvar swap file
vim.opt.timeoutlen = 300           -- Tempo para combos de teclas

-- 🪟 Janelas
vim.opt.splitright = true         -- Split vertical à direita
vim.opt.splitbelow = true          -- Split horizontal abaixo
vim.o.winborder = 'rounded'        -- Bordas arredondadas

-- 📜 Scroll
vim.opt.scrolloff = 15             -- Linhas de contexto ao fazer scroll
