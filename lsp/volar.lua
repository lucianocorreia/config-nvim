-- Vue Language Server configuration (Volar - Vue 3 / Laravel)
return {
  cmd = { 'vue-language-server', '--stdio' },
  filetypes = { 'vue' },
  root_markers = { 'package.json', '.git', 'composer.json' },
  root_dir = function(bufnr)
    local root = vim.fs.root(bufnr, { 'package.json', '.git', 'composer.json' })
    if not root then return nil end
    
    -- Verificar se é Vue 3
    local package_json = root .. '/package.json'
    local f = io.open(package_json, 'r')
    if f then
      local content = f:read('*all')
      f:close()
      -- Se encontrar Vue 3.x, retorna o root
      if content:match('"vue"%s*:%s*"[^"]*3%.') then
        return root
      end
    end
    return nil
  end,
  init_options = {
    vue = {
      hybridMode = false,
    },
    typescript = {
      tsdk = ''
    }
  },
  settings = {
    vue = {
      complete = {
        casing = {
          tags = 'kebab',
          props = 'camel'
        }
      },
      updateImportsOnFileMove = {
        enabled = true
      }
    }
  },
}
