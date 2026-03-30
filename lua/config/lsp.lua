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

-- Suppress Intelephense false positives (undefined method/type) in Pest test files
local orig_diagnostics_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
  if result and result.diagnostics then
    local uri = result.uri or ""
    if uri:match("/tests/.*%.php$") then
      result.diagnostics = vim.tbl_filter(function(d)
        return not (d.code == "P1013" or d.code == "P1003")
      end, result.diagnostics)
    end
  end
  orig_diagnostics_handler(err, result, ctx, config)
end

-- 🔍 LSP Attach Function
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('corr3ia-lsp-attach', { clear = true }),
  callback = function(event)
    --  Highlight references
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client then
      -- Document highlight
      if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
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

      -- 🔄 Inlay hints toggle
      if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
        vim.keymap.set('n', '<leader>ih', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
        end, { buffer = event.buf, desc = 'Toggle [I]nlay [H]ints' })
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
      -- Buscar TypeScript SDK (local ou global)
      local tsdk = root .. '/node_modules/typescript/lib'
      if vim.fn.isdirectory(tsdk) == 0 then
        -- Fallback para typescript global via npm/yarn
        local global_ts = vim.fn.system('npm root -g 2>/dev/null'):gsub('\n', '') .. '/typescript/lib'
        if vim.fn.isdirectory(global_ts) == 1 then
          tsdk = global_ts
        else
          tsdk = '' -- Volar tentará encontrar automaticamente
        end
      end
      
      -- Verificar se tem o plugin @vue/typescript-plugin
      local has_vue_plugin = vim.fn.isdirectory(root .. '/node_modules/@vue/typescript-plugin') == 1
      
      if has_vue_plugin then
        -- Modo Híbrido: ts_ls + Volar com plugin
        vim.lsp.start({
          name = 'ts_ls',
          cmd = { 'typescript-language-server', '--stdio' },
          root_dir = root,
          init_options = {
            plugins = {
              {
                name = '@vue/typescript-plugin',
                location = root .. '/node_modules/@vue/typescript-plugin',
                languages = { 'vue' },
              },
            },
          },
          filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact' },
        })
        
        vim.lsp.start({
          name = 'volar',
          cmd = { 'vue-language-server', '--stdio' },
          root_dir = root,
          init_options = {
            typescript = { tsdk = tsdk },
            vue = { hybridMode = true },
          },
          filetypes = { 'vue' },
        })
      else
        -- Modo Take Over: Apenas Volar (melhor para Laravel)
        vim.lsp.start({
          name = 'volar',
          cmd = { 'vue-language-server', '--stdio' },
          root_dir = root,
          init_options = {
            typescript = { tsdk = tsdk },
            vue = { hybridMode = false },
          },
          filetypes = { 'vue', 'typescript', 'javascript' },
          on_new_config = function(new_config, new_root_dir)
            new_config.init_options.typescript.tsdk = new_root_dir .. '/node_modules/typescript/lib'
          end,
        })
      end
    end
  end,
})
