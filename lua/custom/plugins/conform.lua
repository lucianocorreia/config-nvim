return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
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
      local disable_filetypes = { c = true, cpp = true, php = true, vue = true }
      if not disable_filetypes[vim.bo[bufnr].filetype] then
        vim.schedule(function()
          require('fidget').notify('formatted (' .. vim.bo[bufnr].filetype .. ')', vim.log.levels.INFO)
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
      vue = { 'prettierd', 'prettier', stop_after_first = true },
      html = { 'prettierd', 'prettier', stop_after_first = true },
      css = { 'prettierd', 'prettier', stop_after_first = true },
      scss = { 'prettierd', 'prettier', stop_after_first = true },
      yaml = { 'prettierd', 'prettier', stop_after_first = true },
      yml = { 'prettierd', 'prettier', stop_after_first = true },

      -- 🐍 Python (exemplo commented)
      -- python = { "isort", "black" },

      -- 🎮 Godot/GDScript
      gdscript = { 'gdformat' },
      gdscript3 = { 'gdformat' },
      gd = { 'gdformat' },
    },
    formatters = {
      gdformat = {
        command = vim.fn.stdpath('data') .. '/mason/bin/gdformat',
        args = { '-', '--line-length', '180' },
        stdin = true,
      },
    },
  },
}
