local M = {}

local plugins_dir = vim.fs.joinpath(vim.fn.stdpath('config'), 'lua', 'custom', 'plugins')

local plugins = {}
local seen_order = {}

local function is_spec(value)
  if type(value) ~= 'table' then
    return false
  end

  return value.src ~= nil
    or type(value[1]) == 'string'
    or value.name ~= nil
    or value.version ~= nil
    or value.dependencies ~= nil
    or value.opts ~= nil
    or value.config ~= nil
    or value.init ~= nil
    or value.keys ~= nil
    or value.build ~= nil
    or value.event ~= nil
    or value.cmd ~= nil
    or value.ft ~= nil
    or value.main ~= nil
    or value.enabled ~= nil
    or value.priority ~= nil
end

local function normalize_source(src)
  if not src or src == '' then
    return nil
  end

  if src:match('^https?://') or src:match('^git@') or src:match('^%a[%w+.-]*:') then
    return src
  end

  return 'https://github.com/' .. src
end

local function derive_name(spec)
  local src = spec.src or spec[1]
  if spec.name then
    return spec.name
  end
  if not src then
    return nil
  end

  local name = src:match('/([^/]+)$') or src
  return name:gsub('%.git$', '')
end

local function merge_specs(current, incoming)
  for key, value in pairs(incoming) do
    if key ~= '_module' and key ~= '_index' then
      if current[key] == nil or key == 'config' or key == 'opts' or key == 'keys' or key == 'init' or key == 'build' then
        current[key] = value
      end
    end
  end

  current._module = incoming._module or current._module
  current._index = math.min(current._index or incoming._index, incoming._index or current._index)
  return current
end

local function normalize_spec(raw, module_name, index)
  if type(raw) ~= 'table' then
    return nil
  end

  local src = raw.src or raw[1]
  if not src then
    return nil
  end

  local spec = vim.deepcopy(raw)
  spec.src = normalize_source(src)
  spec.name = derive_name(raw)
  if spec.version == false then
    spec.version = nil
  elseif type(spec.version) == 'string' and spec.version:find('*', 1, true) then
    local normalized = spec.version:gsub('%.%*$', ''):gsub('%*$', '')
    local ok, range = pcall(vim.version.range, normalized)
    spec.version = ok and range or nil
  end
  spec._module = module_name
  spec._index = index
  return spec
end

local function flatten(raw, module_name, items, index)
  items = items or {}
  index = index or 0

  if not raw then
    return items, index
  end

  if is_spec(raw) then
    index = index + 1
    local spec = normalize_spec(raw, module_name, index)
    if spec then
      items[#items + 1] = spec
    end
    return items, index
  end

  if type(raw) ~= 'table' then
    return items, index
  end

  for _, value in ipairs(raw) do
    items, index = flatten(value, module_name, items, index)
  end

  return items, index
end

local function collect(spec)
  if not spec or spec.enabled == false or not spec.name or not spec.src then
    return
  end

  for _, dependency in ipairs(flatten(spec.dependencies, spec._module)) do
    collect(dependency)
  end

  local existing = plugins[spec.name]
  if existing then
    plugins[spec.name] = merge_specs(existing, spec)
    return
  end

  plugins[spec.name] = spec
  seen_order[#seen_order + 1] = spec.name
end

local function discover_modules()
  local modules = {}
  for name, kind in vim.fs.dir(plugins_dir) do
    if kind == 'file' and name:sub(-4) == '.lua' and name ~= 'init.lua' and not name:match('%.backup') then
      local module_name = 'custom.plugins.' .. name:gsub('%.lua$', '')
      modules[#modules + 1] = module_name
    end
  end

  table.sort(modules)
  return modules
end

local function infer_main(spec)
  local candidates = {}
  local raw_name = spec.main or spec.name

  if raw_name then
    candidates[#candidates + 1] = raw_name
    candidates[#candidates + 1] = raw_name:gsub('%.nvim$', '')
    candidates[#candidates + 1] = raw_name:gsub('^nvim%-', '')
    candidates[#candidates + 1] = raw_name:gsub('%-nvim$', '')
    candidates[#candidates + 1] = raw_name:gsub('%.lua$', '')
  end

  for _, candidate in ipairs(candidates) do
    local normalized = candidate:gsub('%-', '.')
    local ok, module = pcall(require, normalized)
    if ok then
      return module
    end
  end

  return nil
end

local function register_keys(spec)
  if type(spec.keys) ~= 'table' then
    return
  end

  for _, mapping in ipairs(spec.keys) do
    if type(mapping) == 'table' and mapping[1] and mapping[2] then
      local opts = {}
      for key, value in pairs(mapping) do
        if type(key) ~= 'number' and key ~= 'mode' then
          opts[key] = value
        end
      end

      local mode = mapping.mode or 'n'
      if mode == '' then
        mode = 'n'
      end

      vim.keymap.set(mode, mapping[1], mapping[2], opts)
    end
  end
end

local function execute_build(build, path, plugin_name)
  local command = build
  if type(command) == 'function' then
    command = command()
  end

  if type(command) ~= 'string' or command == '' then
    return
  end

  if command:sub(1, 1) == ':' then
    vim.schedule(function()
      pcall(vim.cmd.packadd, plugin_name)
      pcall(vim.cmd, command:sub(2))
    end)
    return
  end

  vim.system({ 'sh', '-c', command }, { cwd = path }, function(result)
    if result.code ~= 0 then
      vim.schedule(function()
        vim.notify('Build falhou para ' .. plugin_name .. ': ' .. vim.trim(result.stderr or ''), vim.log.levels.ERROR)
      end)
    end
  end)
end

local function run_setup(spec)
  if spec._setup_ran then
    return
  end

  spec._setup_ran = true

  if spec.enabled == false then
    return
  end

  if spec.init and not spec._init_ran then
    spec._init_ran = true
    local ok, err = pcall(spec.init)
    if not ok then
      vim.notify('Erro em init de ' .. spec.name .. ': ' .. err, vim.log.levels.ERROR)
    end
  end

  local ok, err
  if spec.config then
    ok, err = pcall(spec.config, spec, spec.opts)
  elseif spec.opts ~= nil then
    local module = infer_main(spec)
    if module and type(module.setup) == 'function' then
      ok, err = pcall(module.setup, spec.opts)
    else
      ok = true
    end
  else
    ok = true
  end

  if not ok then
    vim.notify('Erro em setup de ' .. spec.name .. ': ' .. err, vim.log.levels.ERROR)
  end

  register_keys(spec)
end

local function setup_matches_filetype(spec)
  local current = vim.bo.filetype
  if current == '' then
    return false
  end

  if type(spec.ft) == 'string' then
    return spec.ft == current
  end

  if type(spec.ft) == 'table' then
    return vim.tbl_contains(spec.ft, current)
  end

  return false
end

function M.setup()
  if type(vim.pack) ~= 'table' or type(vim.pack.add) ~= 'function' then
    vim.notify('vim.pack não está disponível nesta versão do Neovim', vim.log.levels.ERROR)
    return
  end

  local modules = discover_modules()
  for _, module_name in ipairs(modules) do
    local ok, raw = pcall(require, module_name)
    if ok then
      for _, spec in ipairs(flatten(raw, module_name)) do
        collect(spec)
      end
    else
      vim.notify('Falha ao carregar ' .. module_name .. ': ' .. raw, vim.log.levels.WARN)
    end
  end

  local build_hooks = {}
  local pack_specs = {}
  for _, name in ipairs(seen_order) do
    local spec = plugins[name]
    local pack_spec = {
      src = spec.src,
      name = spec.name,
    }
    if type(spec.version) == 'string' or type(spec.version) == 'table' then
      pack_spec.version = spec.version
    end

    pack_specs[#pack_specs + 1] = pack_spec
    if spec.build then
      build_hooks[name] = spec.build
    end
  end

  vim.api.nvim_create_autocmd('PackChanged', {
    group = vim.api.nvim_create_augroup('corr3ia-pack-build', { clear = true }),
    callback = function(event)
      local build = build_hooks[event.data.spec.name]
      if build and (event.data.kind == 'install' or event.data.kind == 'update') then
        execute_build(build, event.data.path, event.data.spec.name)
      end
    end,
  })

  vim.pack.add(pack_specs)

  table.sort(seen_order, function(left, right)
    local left_spec = plugins[left]
    local right_spec = plugins[right]
    local left_priority = left_spec.priority or 0
    local right_priority = right_spec.priority or 0
    if left_priority == right_priority then
      return (left_spec._index or 0) < (right_spec._index or 0)
    end
    return left_priority > right_priority
  end)

  for _, name in ipairs(seen_order) do
    local spec = plugins[name]
    if spec.ft and spec.lazy ~= false then
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('corr3ia-pack-ft-' .. spec.name, { clear = true }),
        pattern = spec.ft,
        once = true,
        callback = function()
          run_setup(spec)
        end,
      })

      if setup_matches_filetype(spec) then
        run_setup(spec)
      end
    else
      run_setup(spec)
    end
  end
end

return M
