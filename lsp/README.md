# LSP Configuration - Neovim 0.11 Native

Esta configuração utiliza o **LSP nativo** do Neovim 0.11, seguindo a documentação oficial.

## Estrutura

```
lsp/                    # Pasta na raiz do config (não dentro de custom/)
├── lua_ls.lua         # Lua Language Server
├── intelephense.lua   # PHP Language Server (Intelephense)
├── vls.lua            # Vue Language Server
├── ts_ls.lua          # TypeScript/JavaScript Language Server
├── html.lua           # HTML Language Server
├── cssls.lua          # CSS Language Server
└── jsonls.lua         # JSON Language Server
```

## Como funciona

1. **Configuração de servers**: Cada arquivo em `lsp/` define a configuração de um language server
2. **Ativação**: No `init.lua`, usamos `vim.lsp.enable()` para ativar os servers
3. **Auto-detecção**: O Neovim carrega automaticamente as configurações da pasta `lsp/`

## Formato dos arquivos LSP

Cada arquivo retorna uma tabela com:
```lua
return {
  cmd = { 'command-to-start-server' },
  filetypes = { 'filetype1', 'filetype2' },
  root_markers = { 'marker-files' },
  settings = {
    -- server-specific settings
  },
}
```

## Language Servers configurados

- **Lua**: `lua_ls` - Para desenvolvimento Lua/Neovim
- **PHP**: `intelephense` - Para desenvolvimento PHP (Laravel, WordPress, etc.)
- **Vue**: `vls` - Para aplicações Vue.js
- **TypeScript/JavaScript**: `ts_ls` - Para desenvolvimento web
- **HTML**: `html` - Para marcação HTML
- **CSS**: `cssls` - Para estilos CSS/SCSS/LESS
- **JSON**: `jsonls` - Para arquivos JSON

## Instalação dos Language Servers

```bash
# Lua
brew install lua-language-server

# PHP Intelephense
npm install -g intelephense

# Vue
npm install -g vls

# TypeScript
npm install -g typescript-language-server typescript

# Web servers (HTML, CSS, JSON)
npm install -g vscode-langservers-extracted
```

## Funcionalidades

- ✅ **Diagnósticos** com ícones e virtual text
- ✅ **Document highlights** 
- ✅ **Inlay hints** com toggle (`<leader>th`)
- ✅ **Rename** (`grn`)
- ✅ **Code actions** (`gra`)
- ✅ **Keymaps padrão** do Neovim 0.11 (gra, gri, grn, grr, grt, gO)
- ✅ **Integração com blink.cmp**

## Adicionando novos servers

1. Crie um arquivo `lsp/nome_do_server.lua`
2. Defina a configuração seguindo o formato padrão
3. Adicione o nome no array do `vim.lsp.enable()` no `init.lua`

Exemplo:
```lua
-- lsp/gopls.lua
return {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod' },
  root_markers = { 'go.mod', '.git' },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
}
```

## Verificação

Use `:checkhealth vim.lsp` para verificar se os language servers estão funcionando corretamente.
