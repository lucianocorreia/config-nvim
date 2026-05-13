local M = {}

local GROUP = 'corr3ia_bookmarks'
local SIGN = 'Corr3iaBookmarkSign'

local state = {}

vim.fn.sign_define(SIGN, {
  text = '',
  texthl = 'DiagnosticHint',
  numhl = '',
  linehl = '',
})

local function ensure(bufnr)
  state[bufnr] = state[bufnr] or {}
  return state[bufnr]
end

local function sign_id(bufnr, lnum)
  return (bufnr * 100000) + lnum
end

function M.toggle()
  local bufnr = vim.api.nvim_get_current_buf()
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  local marks = ensure(bufnr)
  local id = sign_id(bufnr, lnum)

  if marks[lnum] then
    marks[lnum] = nil
    vim.fn.sign_unplace(GROUP, { id = id, buffer = bufnr })
    vim.notify('Bookmark removido da linha ' .. lnum, vim.log.levels.INFO)
    return
  end

  marks[lnum] = true
  vim.fn.sign_place(id, GROUP, SIGN, bufnr, { lnum = lnum, priority = 10 })
  vim.notify('Bookmark adicionado na linha ' .. lnum, vim.log.levels.INFO)
end

local function sorted_marks(bufnr)
  local marks = ensure(bufnr)
  local lines = {}
  for line, enabled in pairs(marks) do
    if enabled then
      lines[#lines + 1] = line
    end
  end
  table.sort(lines)
  return lines
end

function M.next()
  local bufnr = vim.api.nvim_get_current_buf()
  local current = vim.api.nvim_win_get_cursor(0)[1]
  local lines = sorted_marks(bufnr)

  for _, line in ipairs(lines) do
    if line > current then
      vim.api.nvim_win_set_cursor(0, { line, 0 })
      return
    end
  end

  if #lines > 0 then
    vim.api.nvim_win_set_cursor(0, { lines[1], 0 })
  else
    vim.notify('Nenhum bookmark neste buffer', vim.log.levels.INFO)
  end
end

function M.prev()
  local bufnr = vim.api.nvim_get_current_buf()
  local current = vim.api.nvim_win_get_cursor(0)[1]
  local lines = sorted_marks(bufnr)

  for i = #lines, 1, -1 do
    if lines[i] < current then
      vim.api.nvim_win_set_cursor(0, { lines[i], 0 })
      return
    end
  end

  if #lines > 0 then
    vim.api.nvim_win_set_cursor(0, { lines[#lines], 0 })
  else
    vim.notify('Nenhum bookmark neste buffer', vim.log.levels.INFO)
  end
end

function M.list_qf()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = sorted_marks(bufnr)
  if #lines == 0 then
    vim.notify('Nenhum bookmark neste buffer', vim.log.levels.INFO)
    return
  end

  local items = {}
  for _, line in ipairs(lines) do
    items[#items + 1] = {
      bufnr = bufnr,
      lnum = line,
      col = 1,
      text = 'Bookmark',
    }
  end

  vim.fn.setqflist({}, ' ', { title = 'Bookmarks', items = items })
  vim.cmd 'copen'
end

function M.clear_buffer()
  local bufnr = vim.api.nvim_get_current_buf()
  state[bufnr] = {}
  vim.fn.sign_unplace(GROUP, { buffer = bufnr })
  vim.notify('Bookmarks limpos do buffer', vim.log.levels.INFO)
end

vim.api.nvim_create_autocmd('BufWipeout', {
  group = vim.api.nvim_create_augroup('corr3ia-bookmarks-cleanup', { clear = true }),
  callback = function(event)
    state[event.buf] = nil
  end,
})

return M
