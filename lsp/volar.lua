-- Vue Language Server configuration (Volar)
return {
  cmd = { 'vue-language-server', '--stdio' },
  filetypes = { 'vue' },
  root_markers = { 'package.json', '.git' },
  init_options = {
    vue = {
      hybridMode = false,
    },
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
