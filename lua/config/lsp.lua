-- 🔧 Configuração do LSP (Neovim 0.11 Native)
-- Este arquivo contém toda a configuração do Language Server Protocol

-- 🔧 Diagnostic Configuration
vim.diagnostic.config({
  update_in_insert = false,

  -- 📝 Virtual Text (inline messages)
  virtual_text = {
    spacing = 4,
    prefix = function(diagnostic)
      -- Usar setas como o tiny-inline-diagnostic
      local icons = {
        [vim.diagnostic.severity.ERROR] = '➤',
        [vim.diagnostic.severity.WARN] = '➤',
        [vim.diagnostic.severity.INFO] = '➤',
        [vim.diagnostic.severity.HINT] = '➤',
      }
      return icons[diagnostic.severity] or '➤'
    end,
    suffix = '',
    format = function(diagnostic)
      -- Limitar tamanho da mensagem
      local message = diagnostic.message
      local max_width = 80
      if #message > max_width then
        return message:sub(1, max_width - 3) .. '...'
      end
      return message
    end,
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
    --  Highlight references
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

      -- Document highlight
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

      -- 🔄 Inlay hints (se suportado) - apenas toggle, sem keymap
      if client_supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
        -- Inlay hints disponíveis via :lua vim.lsp.inlay_hint.enable()
      end
    end
  end,
})

-- 📦 Load LSP configurations
local lsp_dir = vim.fn.stdpath('config') .. '/lsp/'
local lsp_configs = {
  'lua_ls',
  'intelephense',
  'ts_ls',
  'html',
  'cssls',
  'jsonls',
  'gdscript',
}

local loaded_count = 0
for _, server in ipairs(lsp_configs) do
  local config_file = lsp_dir .. server .. '.lua'
  if vim.fn.filereadable(config_file) == 1 then
    local success, config = pcall(dofile, config_file)
    if success and config then
      vim.lsp.config(server, config)
      loaded_count = loaded_count + 1
    else
      vim.notify('Failed to load ' .. server .. ' config: ' .. tostring(config), vim.log.levels.ERROR)
    end
  end
end

-- Enable Language Servers (except Vue)
vim.lsp.enable({
  'lua_ls',
  'intelephense',
  'ts_ls',
  'html',
  'cssls',
  'jsonls',
  'gdscript',
})

-- Vue LSP com autocmd (mais confiável)
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'vue',
  callback = function(args)
    local bufnr = args.buf
    local root = vim.fs.root(bufnr, { 'package.json', '.git', 'composer.json' })
    
    if not root then return end
    
    -- Verificar versão do Vue
    local package_json = root .. '/package.json'
    local f = io.open(package_json, 'r')
    if not f then return end
    
    local content = f:read('*all')
    f:close()
    
    local is_vue2 = content:match('"vue"%s*:%s*"[^"]*2%.') ~= nil
    local is_vue3 = content:match('"vue"%s*:%s*"[^"]*3%.') ~= nil
    
    if is_vue2 then
      -- Vue 2: usar VLS
      vim.lsp.start({
        name = 'vls',
        cmd = { 'vls' },
        root_dir = root,
        settings = {
          vetur = {
            ignoreProjectWarning = true,
            useWorkspaceDependencies = false,
            validation = {
              template = true,
              script = true,
              style = true,
            },
            completion = {
              autoImport = true,
              tagCasing = 'kebab',
              useScaffoldSnippets = true,
            },
          },
        },
      })
    elseif is_vue3 then
      -- Vue 3: Volar com configuração correta
      vim.lsp.start({
        name = 'volar',
        cmd = { 'vue-language-server', '--stdio' },
        root_dir = root,
        init_options = {
          typescript = {
            tsdk = root .. '/node_modules/typescript/lib'
          }
        },
        filetypes = { 'vue' },
      })
    end
  end,
})
