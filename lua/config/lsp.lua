-- 🔧 Configuração do LSP (Neovim 0.11 Native)
-- Este arquivo contém toda a configuração do Language Server Protocol

-- 🔧 Diagnostic Configuration
vim.diagnostic.config({
  update_in_insert = false,

  -- 📝 Virtual Text (inline messages)
  virtual_text = {
    enabled = true, -- Ativar virtual text
    severity = nil, -- Mostrar todos os níveis (nil = todos)
    source = "if_many", -- Mostrar source se houver múltiplos
    format = nil, -- Função customizada de formatação (nil = padrão)
    prefix = "●", -- Prefixo antes da mensagem
    suffix = "", -- Sufixo após a mensagem
    spacing = 4, -- Espaços entre código e virtual text
  },

  -- 📊 Signs (ícones na lateral)
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✘",
      [vim.diagnostic.severity.WARN]  = "▲",
      [vim.diagnostic.severity.HINT]  = "⚑",
      [vim.diagnostic.severity.INFO]  = "»",
    },
  },

  -- 🔍 Underline (sublinhado nos erros)
  underline = true,

  -- 🎯 Severity sort (ordenar por severidade)
  severity_sort = true,

  -- 💬 Float window configuration
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = true,
    header = '',
    prefix = '',
    format = function(diagnostic)
      return string.format("%s (%s)", diagnostic.message, diagnostic.source)
    end,
  },
})

--  LSP UI Customization
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = 'rounded',
  }
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    border = 'rounded',
  }
)

-- 🔍 LSP Attach Function
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('corr3ia-lsp-attach', { clear = true }),
  callback = function(event)
    -- Keymaps locais quando LSP está ativo
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Função helper para usar Telescope se disponível, senão usar funções nativas
    local function safe_telescope_or_builtin(telescope_func, builtin_func)
      local has_telescope, telescope = pcall(require, 'telescope.builtin')
      if has_telescope and telescope[telescope_func] then
        return telescope[telescope_func]
      else
        return builtin_func
      end
    end

    -- 🔍 Navigation and Information
    map('gd', safe_telescope_or_builtin('lsp_definitions', vim.lsp.buf.definition), '[G]oto [D]efinition')
    map('gr', safe_telescope_or_builtin('lsp_references', vim.lsp.buf.references), '[G]oto [R]eferences')
    map('gI', safe_telescope_or_builtin('lsp_implementations', vim.lsp.buf.implementation), '[G]oto [I]mplementation')
    map('<leader>D', safe_telescope_or_builtin('lsp_type_definitions', vim.lsp.buf.type_definition), 'Type [D]efinition')
    map('<leader>ds', safe_telescope_or_builtin('lsp_document_symbols', vim.lsp.buf.document_symbol),
      '[D]ocument [S]ymbols')
    map('<leader>ws', safe_telescope_or_builtin('lsp_dynamic_workspace_symbols', vim.lsp.buf.workspace_symbol),
      '[W]orkspace [S]ymbols')

    -- 🔧 Actions
    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- 📖 Documentation
    map('K', vim.lsp.buf.hover, 'Hover Documentation')

    -- 🩺 Diagnostic Navigation
    map('<leader>e', vim.diagnostic.open_float, 'Show diagnostic [E]rror messages')
    map('[d', vim.diagnostic.goto_prev, 'Go to previous [D]iagnostic message')
    map(']d', vim.diagnostic.goto_next, 'Go to next [D]iagnostic message')
    map('<leader>q', vim.diagnostic.setloclist, 'Open diagnostic [Q]uickfix list')

    -- 💡 Highlight references
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client then
      -- Function to check if client supports method (compatible with 0.10 and 0.11)
      local function client_supports_method(method, bufnr)
        if vim.fn.has('nvim-0.11') == 1 then
          return client:supports_method(method, bufnr)
        else
          return client.supports_method and client.supports_method(method, { bufnr = bufnr })
        end
      end

      if client_supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
        local highlight_augroup = vim.api.nvim_create_augroup('corr3ia-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('corr3ia-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'corr3ia-lsp-highlight', buffer = event2.buf }
          end,
        })
      end

      -- 🔄 Inlay hints (se suportado)
      if client_supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
        map('<leader>th', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
        end, '[T]oggle Inlay [H]ints')
      end
    end
  end,
})

-- 📡 Ativar Language Servers
vim.lsp.enable({
  'lua_ls',
  'intelephense',
  'vls',
  'ts_ls',
  'html',
  'cssls',
  'jsonls',
})
