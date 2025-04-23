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
    on_stderr = function(_, err)
      if err and err[1] ~= '' then
        local message = table.concat(err, '\n')
        vim.notify(message, vim.log.levels.ERROR, {
          title = 'Erro: ' .. (title or table.concat(cmd, ' ')),
        })
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

M.create_migration_klingo = function()
  vim.ui.input({ prompt = 'Nome da migration: ' }, function(migration_name)
    if not migration_name or migration_name == '' then
      return
    end

    vim.ui.input({ prompt = 'Nome da tabela: ' }, function(table_name)
      if not table_name or table_name == '' then
        return
      end

      table_name = string.upper(table_name) -- 👈 converte para maiúsculas

      local cmd = {
        'php',
        'artisan',
        'make:migration',
        migration_name,
        '--table=' .. table_name,
        '--path=database/azure',
      }

      run_and_notify(cmd, 'Criando migration')
    end)
  end)
end

return M
