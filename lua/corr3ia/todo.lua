local M = {}

local todo_file_path = vim.fn.expand '~/Documents/todos.md'

local function ensure_todo_file()
  if vim.fn.filereadable(todo_file_path) == 0 then
    vim.fn.writefile({}, todo_file_path)
  end
end

-- Abre o arquivo de todos
function M.open()
  ensure_todo_file()
  vim.cmd('vsplit ' .. todo_file_path)
  vim.cmd('e ' .. todo_file_path)
end

-- Marca/Desmarca um TODO
function M.toggle()
  local line_nr = vim.api.nvim_win_get_cursor(0)[1] - 1
  local line = vim.api.nvim_get_current_line()

  if line:match '%- %[ %]' then
    line = line:gsub('%- %[ %]', '- [x]')
  elseif line:match '%- %[x%]' then
    line = line:gsub('%- %[x%]', '- [ ]')
  else
    return
  end

  vim.api.nvim_buf_set_lines(0, line_nr, line_nr + 1, false, { line })
end

-- Cria uma seção com o dia atual
function M.header()
  local buf_name = vim.api.nvim_buf_get_name(0)
  if not buf_name:find 'todos%.md' then
    print 'Você não está no arquivo de todos.md!'
    return
  end

  local today = os.date '%Y-%m-%d'
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line_nr = cursor[1]

  -- Insere a seção
  vim.api.nvim_buf_set_lines(0, line_nr, line_nr, false, { '## ' .. today .. ' ' })
  vim.api.nvim_win_set_cursor(0, { line_nr + 1, 5 + #today })
  vim.cmd 'startinsert'
end

-- Adiciona um novo TODO na linha atual
function M.add()
  local buf_name = vim.api.nvim_buf_get_name(0)
  if not buf_name:find 'todos%.md' then
    print 'Você não está no arquivo de todos.md!'
    return
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local line_nr = cursor[1]

  -- Cria o TODO com o espaço explícito depois do "]"
  local todo_text = '- [ ]  ' -- Aqui criamos o espaço logo após o colchete
  vim.api.nvim_buf_set_lines(0, line_nr, line_nr, false, { todo_text })

  -- Vamos agora mover o cursor após o espaço
  -- O número 7 é o número de caracteres após "- [ ] "
  vim.api.nvim_win_set_cursor(0, { line_nr + 1, 7 }) -- Cursor depois do espaço

  -- Coloca o editor em modo de inserção
  vim.cmd 'startinsert'
end

return M
