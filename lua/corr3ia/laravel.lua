-- Helper to run a shell command in a new terminal buffer
local M = {}

local function run_in_terminal(cmd)
  vim.cmd('split | terminal ' .. cmd)
end

-- Run any shell command and show result in a notification
local function run_and_notify(cmd, title)
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        local message = table.concat(data, '\n')
        -- Optional: break up long lines
        local formatted = message:gsub('([^\n\r]{120})', '%1\n')
        vim.notify(formatted, vim.log.levels.INFO, { title = title or table.concat(cmd, ' ') })
      end
    end,
  })
end

-- Laravel Artisan helpers
M.artisan = function(command)
  run_and_notify({ 'php', 'artisan', command }, 'php artisan ' .. command)
end

M.artisant = function(command)
  run_in_terminal('php artisan ' .. command)
end

M.clear_cache = function()
  M.artisan 'config:cache'
end

M.optimize_clear = function()
  M.artisan 'optimize:clear'
end

M.tinker = function()
  M.artisant 'tinker'
  vim.cmd 'startinsert'
end

return M
