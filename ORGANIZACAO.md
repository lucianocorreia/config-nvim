# 📁 Estrutura Modular da Configuração do Neovim

## 🗂️ Arquivos Organizados

### 📋 `init.lua` (Principal)
- **Função**: Arquivo de entrada principal
- **Responsabilidade**: Carregar todos os módulos organizados + bootstrap do Lazy.nvim
- **Tamanho**: ~25 linhas (era 374!)
- **Plugins**: Removidos `vim-sleuth` e `fidget.nvim` (movidos para custom/plugins)

### ⚙️ `lua/config/options.lua`
- **Função**: Configurações do vim/neovim
- **Conteúdo**: 
  - Leader keys
  - Interface settings
  - Mouse e clipboard
  - Search options
  - Windows e scrolling

### ⌨️ `lua/config/keymaps.lua`
- **Função**: Todos os mapeamentos de teclas
- **Conteúdo**:
  - Escape e limpeza
  - Navegação entre janelas
  - Movimento e scroll
  - Clipboard operations
  - PHP/Laravel helpers
  - TODO commands

### 🤖 `lua/config/autocmds.lua`
- **Função**: Autocommands e eventos automáticos
- **Conteúdo**:
  - Highlight no yank
  - Auto-resize windows
  - Remove trailing spaces
  - Terminal auto-insert
  - Restore last position

### 🔧 `lua/config/lsp.lua`
- **Função**: Configuração completa do LSP nativo 0.11
- **Conteúdo**:
  - Diagnostic config
  - UI customization
  - Attach function com keymaps
  - Document highlighting
  - Inlay hints
  - Server activation
- **🔧 Correção**: Suporte a Telescope opcional (fallback para funções nativas do LSP)

### 🎯 `lua/config/commands.lua`
- **Função**: Comandos definidos pelo usuário
- **Conteúdo**:
  - LSP debug commands (`:LspStatus`, `:LspClients`, etc.)
  - Diagnostic commands (`:DiagnosticInfo`, `:DiagnosticToggle`)
  - Utility commands (`:TrimWhitespace`, `:ReloadConfig`)
  - Info commands (`:ConfigInfo`)
  - PHP/Laravel helpers (`:PhpArtisan`, `:Composer`)

## 🧹 Limpeza Realizada

### ❌ **Arquivos Removidos (não utilizados):**
```
lua/corr3ia/
├── health.lua        # ❌ Removido (não estava sendo usado)
├── .DS_Store         # ❌ Removido (arquivo do sistema)
└── plugins/          # ❌ Pasta inteira removida
    ├── autopairs.lua
    ├── debug.lua
    ├── gitsigns.lua
    ├── indent_line.lua
    ├── lint.lua
    └── neo-tree.lua
```

### ✅ **Arquivos Mantidos (em uso):**
```
lua/corr3ia/
├── laravel.lua       # ✅ Usado em keymaps (Laravel commands)
└── todo.lua          # ✅ Usado em keymaps (TODO commands)
```

### 🔌 **Plugins Reorganizados:**
```
Movidos de init.lua para custom/plugins/:
├── vim-sleuth.lua    # 🔧 Auto-detect indentation
└── fidget.lua        # 📊 LSP progress indicator (já existia)
```

## 🎯 Benefícios da Reorganização

### ✅ **Antes (Monolítico)**
- 1 arquivo gigante (374 linhas)
- Mistura de responsabilidades
- Difícil manutenção
- Difícil navegação

### 🚀 **Depois (Modular)**
- 6 arquivos organizados
- Responsabilidade única
- Fácil manutenção
- Navegação clara
- Documentação integrada

## 🔄 Como Usar

### 📝 **Para editar configurações:**
```lua
-- Editar opções do vim
nvim lua/config/options.lua

-- Editar keymaps
nvim lua/config/keymaps.lua

-- Editar LSP
nvim lua/config/lsp.lua
```

### 🆘 **Comandos úteis:**
```vim
:LspStatus          " Status dos clientes LSP
:DiagnosticInfo     " Informações sobre diagnósticos do buffer
:DiagnosticToggle   " Ativar/desativar virtual text
:ConfigInfo         " Informações da configuração
:ReloadConfig       " Recarregar configuração
:checkhealth        " Verificar saúde da configuração
```

### ⌨️ **Keymaps de Diagnósticos:**
```vim
<leader>e    " Mostrar erro em float window
[d           " Ir para diagnóstico anterior
]d           " Ir para próximo diagnóstico
<leader>q    " Abrir quickfix list com diagnósticos
```

## 📦 Backup
- `init_backup.lua`: Backup da configuração original
- Pode ser removido após confirmar que tudo funciona
