return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs', -- Sets main module to use for opts
  -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
  opts = {
    local_max_filesize = 300 * 1024,
    ensure_installed = { 'bash', 'c', 'diff', 'html', 'java', 'javascript', 'typescript', 'tsx', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'vue', 'php', 'c_sharp', 'razor' },
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      -- Desabilitar treesitter para Blade (vamos usar syntax tradicional)
      disable = function(lang, buf)
        if lang == 'blade' then
          return true
        end

        local uv = vim.uv or vim.loop
        local name = vim.api.nvim_buf_get_name(buf)
        if name == '' then
          return false
        end
        local ok, stat = pcall(uv.fs_stat, name)
        return ok and stat and stat.size > (300 * 1024) or false
      end,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = {
      enable = true,
      disable = function(lang, buf)
        if lang == 'ruby' then
          return true
        end

        local uv = vim.uv or vim.loop
        local name = vim.api.nvim_buf_get_name(buf)
        if name == '' then
          return false
        end
        local ok, stat = pcall(uv.fs_stat, name)
        return ok and stat and stat.size > (300 * 1024) or false
      end,
    },
  },
  -- There are additional nvim-treesitter modules that you can use to interact
  -- with nvim-treesitter. You should go explore a few and see what interests you:
  --
  --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
  --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
  --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}
