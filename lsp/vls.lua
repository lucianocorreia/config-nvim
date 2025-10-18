-- Vue Language Server configuration (Vetur/VLS - ideal para Vue 2)
return {
  cmd = { 'vls' },
  filetypes = { 'vue' },
  root_markers = { 'package.json', '.git' },
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
