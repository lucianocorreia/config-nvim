local M = {}

function M.log_variable()
  local ts_utils = require 'nvim-treesitter.ts_utils'
  local node = ts_utils.get_node_at_cursor()

  -- Find variable under cursor
  while node do
    if node:type() == 'variable_name' or node:type() == 'variable' then
      break
    end
    node = node:parent()
  end

  if not node then
    print 'No variable under cursor.'
    return
  end

  local variable_text = vim.treesitter.get_node_text(node, 0)
  local cursor_row = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- Find next empty line (or insert at the end)
  local insert_line = cursor_row
  while insert_line <= #lines do
    local line = lines[insert_line] or ''
    if line:match '^%s*$' then
      break
    end
    insert_line = insert_line + 1
  end

  -- Get indentation from the line above insertion point
  local previous_line = lines[insert_line - 1] or ''
  local indent = previous_line:match '^(%s*)' or ''

  -- Prepare logger and blank line
  local logger_line = indent .. 'logger(json_encode(' .. variable_text .. ', JSON_PRETTY_PRINT));'
  local blank_line = ''

  -- Insert logger line + blank line
  vim.api.nvim_buf_set_lines(0, insert_line, insert_line, false, { logger_line, blank_line })
end

function M.insert_data_get()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local text = "data_get($ , '')"

  -- Get the current line and insert the text at the cursor position
  local line = vim.api.nvim_get_current_line()
  local before = line:sub(1, col + 1) -- Text before the cursor
  local after = line:sub(col + 2) -- Text after the cursor
  local new_line = before .. text .. after
  vim.api.nvim_set_current_line(new_line)

  -- Move cursor right after the '$' in data_get($ , '')
  vim.api.nvim_win_set_cursor(0, { row, col + #'data_get($' })
end

return M
