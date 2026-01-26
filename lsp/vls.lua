-- Vue Language Server configuration (Vetur/VLS - ideal para Vue 2)
return {
  cmd = { 'vls' },
  filetypes = { 'vue' },
  root_markers = { 'package.json', '.git' },
  root_dir = function(bufnr)
    local root = vim.fs.root(bufnr, { 'package.json', '.git' })
    if not root then return nil end
    
    -- Verificar se é Vue 2
    local package_json = root .. '/package.json'
    local f = io.open(package_json, 'r')
    if f then
      local content = f:read('*all')
      f:close()
      -- Se encontrar Vue 2.x, retorna o root
      if content:match('"vue"%s*:%s*"[^"]*2%.') then
        return root
      end
    end
    return nil
  end,
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
      format = {
        enable = true,
        options = {
          tabSize = 2,
          useTabs = false,
        },
        defaultFormatter = {
          html = 'prettier',
          css = 'prettier',
          postcss = 'prettier',
          scss = 'prettier',
          less = 'prettier',
          js = 'prettier',
          ts = 'prettier',
        },
      },
    },
  },
}
