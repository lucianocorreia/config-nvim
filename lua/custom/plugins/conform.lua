return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>cf',
      function()
        require('conform').format({ async = true, lsp_format = 'fallback' }, function(err)
          if not err then
            require('fidget').notify('Buffer formatted successfully', vim.log.levels.INFO)
          else
            require('fidget').notify('Format failed: ' .. err, vim.log.levels.ERROR)
          end
        end)
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
    {
      '<leader>cf',
      function()
        vim.lsp.buf.format {
          async = true,
          range = {
            ['start'] = vim.api.nvim_buf_get_mark(0, '<'),
            ['end'] = vim.api.nvim_buf_get_mark(0, '>'),
          },
        }
      end,
      mode = 'v',
      desc = '[F]ormat selected text',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = {
        c = true,
        cpp = true,
        php = true,
        vue = true,
        -- JSON e XML são habilitados para format_on_save
        -- javascript/typescript são habilitados para format_on_save
      }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 500,
          lsp_format = 'fallback',
        }
      end
    end,
    format_after_save = function(bufnr)
      local disable_filetypes = {
        c = true,
        cpp = true,
        php = true,
        vue = true,
      }
      if not disable_filetypes[vim.bo[bufnr].filetype] then
        vim.schedule(function()
          require('fidget').notify('File formatted on save', vim.log.levels.INFO, { annote = vim.bo[bufnr].filetype })
        end)
      end
    end,
    formatters_by_ft = {
      lua = { 'stylua' },

      -- 📄 JSON formatting
      json = { 'prettierd', 'prettier', stop_after_first = true },
      jsonc = { 'prettierd', 'prettier', stop_after_first = true },

      -- 📋 XML formatting
      xml = { 'xmllint' },

      -- 🌐 Web development
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },
      html = { 'prettierd', 'prettier', stop_after_first = true },
      css = { 'prettierd', 'prettier', stop_after_first = true },
      scss = { 'prettierd', 'prettier', stop_after_first = true },
      yaml = { 'prettierd', 'prettier', stop_after_first = true },
      yml = { 'prettierd', 'prettier', stop_after_first = true },

      -- 🐍 Python (exemplo commented)
      -- python = { "isort", "black" },

      -- 🎮 Godot/GDScript
      gdscript = { 'gdformat' },
      gd = { 'gdformat' },
    },
  },
}
