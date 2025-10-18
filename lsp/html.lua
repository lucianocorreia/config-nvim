-- HTML Language Server configuration
return {
  cmd = { 'vscode-html-language-server', '--stdio' },
  filetypes = { 'html', 'templ' },
  root_markers = { '.git' },
  settings = {},
}
