local uv = vim.uv or vim.loop

local function is_large_buffer(bufnr, max_bytes)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == '' then
    return false
  end

  local ok, stat = pcall(uv.fs_stat, name)
  return ok and stat and stat.size > max_bytes or false
end

local function has_treesitter_parser(ft)
  local lang = vim.treesitter.language.get_lang(ft) or ft
  return pcall(vim.treesitter.language.add, lang)
end

local function safe_restart_treesitter(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  local ft = vim.bo[bufnr].filetype
  local lang = vim.treesitter.language.get_lang(ft) or ft

  if vim.treesitter.highlighter.active[bufnr] then
    vim.treesitter.highlighter.active[bufnr]:destroy()
  end

  local ok, err = pcall(vim.treesitter.start, bufnr, lang)
  if ok then
    return
  end

  -- Fallback when parser is missing/broken, keeping basic highlighting.
  if ft ~= '' then
    vim.bo[bufnr].syntax = ft
  end

  if not vim.b[bufnr].treesitter_parser_warned then
    vim.b[bufnr].treesitter_parser_warned = true
    vim.schedule(function()
      vim.notify('Treesitter parser ausente para ' .. lang .. '. Rode :TSInstall ' .. lang, vim.log.levels.WARN)
      vim.notify('Detalhe: ' .. tostring(err), vim.log.levels.DEBUG)
    end)
  end
end

-- Desabilitar semantic tokens para servidores pesados em cenários grandes
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('DisableHeavySemanticTokens', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    local ft = vim.bo[args.buf].filetype
    local disable = false

    if client.name == 'roslyn' then
      disable = true
    elseif client.name == 'gdscript' and (ft == 'gd' or ft == 'gdscript' or ft == 'gdscript3') and has_treesitter_parser(ft) then
      -- Godot LSP semantic tokens podem homogeneizar method/type em alguns temas.
      -- Mantemos o highlight do Treesitter, que está mais próximo do preview do picker.
      disable = true
    elseif client.name == 'intelephense' and ft == 'php' and has_treesitter_parser 'php' then
      -- Intelephense pode sobrescrever keyword/type do PHP com semantic tokens.
      -- Preferimos as capturas do Treesitter, que ficam mais próximas do Catppuccin em outros editores.
      disable = false
    elseif client.name == 'vls' and ft == 'vue' and has_treesitter_parser 'vue' then
      -- VLS costuma aplicar semantic tokens de forma tardia em alguns projetos Vue 2.
      disable = true
    elseif (client.name == 'volar' or client.name == 'ts_ls') and ft == 'vue' and is_large_buffer(args.buf, 300 * 1024) and has_treesitter_parser 'vue' then
      disable = true
    end

    if ft == 'vue' and not has_treesitter_parser 'vue' and not vim.g.vue_parser_missing_warned then
      vim.g.vue_parser_missing_warned = true
      vim.schedule(function()
        vim.notify('Parser Treesitter de Vue ausente. Semantic tokens do LSP serão mantidos para evitar cores ruins.', vim.log.levels.WARN)
        vim.notify('Instale com :TSInstall vue (agora que tree-sitter-cli está instalado).', vim.log.levels.INFO)
      end)
    end

    if disable then
      client.server_capabilities.semanticTokensProvider = nil

      -- Forçar refresh do highlighting com Treesitter
      vim.schedule(function()
        safe_restart_treesitter(args.buf)
      end)
    end
  end,
})
