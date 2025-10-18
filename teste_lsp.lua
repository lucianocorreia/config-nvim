-- Teste do LSP para Lua
local teste = "hello world"

vim.print("LSP está funcionando!")

-- Função de teste
local function minha_funcao()
  return teste:upper()
end

minha_funcao()
