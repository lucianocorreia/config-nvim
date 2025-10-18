#!/bin/bash

echo "🔍 Testando LSP Servers..."
echo "=========================="

# Teste básico de cada language server
echo "🟢 Lua Language Server:"
lua-language-server --version 2>/dev/null && echo "✅ OK" || echo "❌ ERRO"

echo "🟢 Intelephense:"
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"rootUri":null}}' | intelephense --stdio 2>/dev/null | head -1 >/dev/null && echo "✅ OK" || echo "❌ ERRO"

echo "🟢 TypeScript Language Server:"
typescript-language-server --version 2>/dev/null && echo "✅ OK" || echo "❌ ERRO"

echo "🟢 HTML Language Server:"
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"rootUri":null}}' | timeout 2 vscode-html-language-server --stdio 2>/dev/null >/dev/null && echo "✅ OK" || echo "❌ ERRO"

echo "🟢 CSS Language Server:"
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"rootUri":null}}' | timeout 2 vscode-css-language-server --stdio 2>/dev/null >/dev/null && echo "✅ OK" || echo "❌ ERRO"

echo "🟢 JSON Language Server:"
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"rootUri":null}}' | timeout 2 vscode-json-language-server --stdio 2>/dev/null >/dev/null && echo "✅ OK" || echo "❌ ERRO"

echo "🟢 Vue Language Server:"
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"rootUri":null}}' | timeout 2 vue-language-server --stdio 2>/dev/null >/dev/null && echo "✅ OK" || echo "❌ ERRO"

echo ""
echo "🎉 Todos os language servers foram testados!"
echo "Agora você pode abrir o Neovim e usar :LspStatus para verificar!"
