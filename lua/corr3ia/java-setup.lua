local M = {}

local codelens_group = vim.api.nvim_create_augroup('corr3ia-jdtls-codelens', { clear = false })
local commands_registered = false
local java_codelens_alignment_patched = false

local root_markers = {
  'mvnw',
  'mvnw.cmd',
  'pom.xml',
  'gradlew',
  'gradlew.bat',
  'build.gradle',
  'build.gradle.kts',
  'settings.gradle',
  'settings.gradle.kts',
  '.project',
  '.classpath',
  '.git',
}

local external_tools_dir = vim.fs.joinpath(vim.fn.stdpath 'data', 'external')

local function get_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok, blink = pcall(require, 'blink.cmp')
  if ok and type(blink.get_lsp_capabilities) == 'function' then
    capabilities = blink.get_lsp_capabilities()
  end

  return capabilities
end

local function find_root(bufnr)
  local root = vim.fs.root(bufnr, root_markers)
  if root then
    return root
  end

  local name = vim.api.nvim_buf_get_name(bufnr)
  if name ~= '' then
    return vim.fs.dirname(name)
  end

  return vim.fn.getcwd()
end

local function sanitize_project_name(path)
  local name = vim.fs.basename(path)
  if not name or name == '' then
    name = 'java-project'
  end

  local suffix = ''
  local ok, hash = pcall(vim.fn.sha256, path)
  if ok and type(hash) == 'string' and hash ~= '' then
    suffix = '-' .. hash:sub(1, 8)
  end

  return (name:gsub('[^%w%-_]', '_')) .. suffix
end

local function resolve_jdtls_cmd()
  local local_jdtls = vim.fs.joinpath(external_tools_dir, 'jdtls', 'bin', 'jdtls')
  if vim.fn.executable(local_jdtls) == 1 then
    return local_jdtls
  end

  if vim.fn.executable 'jdtls' == 1 then
    return vim.fn.exepath 'jdtls'
  end

  local mason_jdtls = vim.fs.joinpath(vim.fn.stdpath 'data', 'mason', 'bin', 'jdtls')
  if vim.fn.executable(mason_jdtls) == 1 then
    return mason_jdtls
  end

  return nil
end

local function resolve_maven_cmd()
  if vim.fn.executable 'mvn' == 1 then
    return vim.fn.exepath 'mvn'
  end

  local sdkman_maven = vim.fs.joinpath(vim.env.HOME or '', '.sdkman', 'candidates', 'maven', 'current', 'bin', 'mvn')
  if vim.fn.executable(sdkman_maven) == 1 then
    return sdkman_maven
  end

  local local_maven = vim.fs.joinpath(external_tools_dir, 'maven', 'bin', 'mvn')
  if vim.fn.executable(local_maven) == 1 then
    return local_maven
  end

  return nil
end

local function build_cmd_env()
  local path_entries = {}
  local seen = {}

  local function add_path(path)
    if not path or path == '' or seen[path] then
      return
    end
    seen[path] = true
    path_entries[#path_entries + 1] = path
  end

  local maven_cmd = resolve_maven_cmd()
  if maven_cmd then
    add_path(vim.fs.dirname(maven_cmd))
  end

  add_path(vim.env.PATH or '')

  local env = {
    PATH = table.concat(path_entries, ':'),
  }

  local java_cmd = vim.fn.exepath 'java'
  if java_cmd ~= '' then
    env.JAVA_HOME = vim.fs.dirname(vim.fs.dirname(java_cmd))
  end

  return env
end

local function split_glob(pattern)
  local matches = vim.fn.glob(pattern, true, true)
  return type(matches) == 'table' and matches or {}
end

local function collect_bundles()
  local mason_share = vim.fs.joinpath(vim.fn.stdpath 'data', 'mason', 'share')
  local bundles = {}

  vim.list_extend(bundles, split_glob(vim.fs.joinpath(mason_share, 'java-debug-adapter', 'com.microsoft.java.debug.plugin-*.jar')))

  local excluded = {
    ['com.microsoft.java.test.runner-jar-with-dependencies.jar'] = true,
    ['jacocoagent.jar'] = true,
  }

  for _, jar in ipairs(split_glob(vim.fs.joinpath(mason_share, 'java-test', '*.jar'))) do
    if not excluded[vim.fs.basename(jar)] then
      bundles[#bundles + 1] = jar
    end
  end

  table.sort(bundles)
  return bundles
end

local function make_workspace_dir(root_dir)
  local workspace_root = vim.fs.joinpath(vim.fn.stdpath 'data', 'jdtls-workspace')
  local workspace_dir = vim.fs.joinpath(workspace_root, sanitize_project_name(root_dir))
  vim.fn.mkdir(workspace_dir, 'p')
  return workspace_dir
end

local function refresh_codelens(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  pcall(vim.lsp.codelens.enable, true, { bufnr = bufnr })
end

local function patch_java_codelens_alignment()
  if java_codelens_alignment_patched then
    return
  end

  local _, provider = debug.getupvalue(vim.lsp.codelens.get, 1)
  if type(provider) ~= 'table' or type(provider.on_win) ~= 'function' then
    return
  end

  local original_on_win = provider.on_win

  provider.on_win = function(self, toprow, botrow)
    if vim.bo[self.bufnr].filetype ~= 'java' then
      return original_on_win(self, toprow, botrow)
    end

    for row = toprow, botrow do
      if self.row_version[row] ~= self.version then
        for client_id, state in pairs(self.client_state) do
          local namespace = state.namespace

          vim.api.nvim_buf_clear_namespace(self.bufnr, namespace, row, row + 1)

          local lenses = state.row_lenses[row]
          if lenses then
            table.sort(lenses, function(left, right)
              return left.range.start.character < right.range.start.character
            end)

            local client = assert(vim.lsp.get_client_by_id(client_id))
            local virt_text = {
              { '', 'LspCodeLensSeparator' },
            }

            for _, lens in ipairs(lenses) do
              if not lens.command then
                self:resolve(client, lens)
              else
                vim.list_extend(virt_text, {
                  { lens.command.title, 'LspCodeLens' },
                  { ' | ', 'LspCodeLensSeparator' },
                })
              end
            end

            table.remove(virt_text)

            if #virt_text == 1 then
              table.insert(virt_text, { '', 'LspCodeLens' })
            end

            vim.api.nvim_buf_set_extmark(self.bufnr, namespace, row, 0, {
              virt_lines = { virt_text },
              virt_lines_above = true,
              virt_lines_overflow = 'scroll',
              hl_mode = 'combine',
            })

            if row == 0 then
              vim.fn.winrestview { topfill = 1 }
            end
          end

          self.row_version[row] = self.version
        end
      end
    end

    if botrow == vim.api.nvim_buf_line_count(self.bufnr) - 1 then
      for _, state in pairs(self.client_state) do
        vim.api.nvim_buf_clear_namespace(self.bufnr, state.namespace, botrow + 1, -1)
      end
    end
  end

  java_codelens_alignment_patched = true
end

local function build_config(bufnr)
  local root_dir = find_root(bufnr)
  local cmd = resolve_jdtls_cmd()

  if not cmd then
    vim.notify('jdtls nao encontrado. Instale-o no PATH ou em ' .. vim.fs.joinpath(external_tools_dir, 'jdtls'), vim.log.levels.WARN)
    return nil
  end

  local ok, jdtls = pcall(require, 'jdtls')
  if not ok then
    vim.notify('nvim-jdtls nao esta disponivel', vim.log.levels.ERROR)
    return nil
  end

  local extended_client_capabilities = vim.deepcopy(jdtls.extendedClientCapabilities or {})
  extended_client_capabilities.resolveAdditionalTextEditsSupport = true

  return {
    cmd = { cmd, '-data', make_workspace_dir(root_dir) },
    cmd_env = build_cmd_env(),
    root_dir = root_dir,
    capabilities = get_capabilities(),
    settings = {
      java = {
        eclipse = {
          downloadSources = true,
        },
        maven = {
          downloadSources = true,
        },
        configuration = {
          updateBuildConfiguration = 'interactive',
        },
        implementationsCodeLens = {
          enabled = true,
        },
        references = {
          includeDecompiledSources = true,
        },
        referencesCodeLens = {
          enabled = true,
        },
        format = {
          enabled = true,
        },
        inlayHints = {
          parameterNames = {
            enabled = 'all',
          },
        },
      },
    },
    init_options = {
      bundles = collect_bundles(),
      extendedClientCapabilities = extended_client_capabilities,
    },
    handlers = {
      ['$/progress'] = function() end,
    },
    on_attach = function(client, attached_bufnr)
      if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, attached_bufnr) then
        vim.lsp.inlay_hint.enable(true, { bufnr = attached_bufnr })
      end

      if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens, attached_bufnr) then
        vim.lsp.codelens.enable(true, { bufnr = attached_bufnr })
        refresh_codelens(attached_bufnr)

        vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
          group = codelens_group,
          buffer = attached_bufnr,
          callback = function()
            refresh_codelens(attached_bufnr)
          end,
          desc = 'Refresh JDTLS code lens',
        })
      end
    end,
  }
end

function M.start_or_attach(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  patch_java_codelens_alignment()

  local config = build_config(bufnr)
  if not config then
    return
  end

  require('jdtls').start_or_attach(config)
end

function M.check_setup()
  local bufnr = vim.api.nvim_get_current_buf()
  local root_dir = find_root(bufnr)
  local cmd = resolve_jdtls_cmd()
  local maven_cmd = resolve_maven_cmd()
  local bundles = collect_bundles()

  -- print('Java setup:')
  -- print('  root: ' .. root_dir)
  -- print('  java: ' .. (vim.fn.exepath('java') ~= '' and vim.fn.exepath('java') or 'nao encontrado'))
  -- print('  jdtls: ' .. (cmd or 'nao encontrado'))
  -- print('  maven: ' .. (maven_cmd or 'nao encontrado'))
  -- print('  bundles: ' .. #bundles)
  -- print('  workspace: ' .. make_workspace_dir(root_dir))
end

function M.install_tools()
  vim.notify('Esta configuracao prioriza ferramentas externas: instale mvn, jdtls e google-java-format fora do Mason.', vim.log.levels.INFO)
end

function M.register_commands()
  if commands_registered then
    return
  end

  commands_registered = true

  vim.api.nvim_create_user_command('JavaCheck', M.check_setup, {
    desc = 'Verificar configuracao Java/JDTLS',
  })

  vim.api.nvim_create_user_command('JavaToolsInstall', M.install_tools, {
    desc = 'Instalar ferramentas Java via Mason',
  })
end

return M
