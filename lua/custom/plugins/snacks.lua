return {
  'folke/snacks.nvim',
  priority = 1000,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    explorer = { enabled = false },
    indent = {
      enabled = true,
      animate = { enabled = false },
      scope = { enabled = false },
      chunk = { enabled = false },
    },
    input = { enabled = true },
    notifier = {
      enabled = false,
      timeout = 3000,
      filter = function(notif)
        local msg = notif.msg or ''
        if type(msg) == 'table' then
          msg = table.concat(msg, ' ')
        end
        msg = tostring(msg):lower()

        if msg:match('roslyn')
          or msg:match('initialized')
          or msg:match('project.*initialized')
          or msg:match('language server.*started')
          or msg:match('server.*ready') then
          return false
        end

        return true
      end,
    },
    picker = {
      enabled = true,
      matcher = {
        frecency = true,
      },
      formatters = {
        file = {
          filename_first = true,
        },
      },
      ui_select = true,
    },
    quickfile = { enabled = true },
    scope = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {},
    },
  },
  init = function()
    local function hex_to_rgb(hex)
      hex = hex:gsub('#', '')
      return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
    end

    local function rgb_to_hex(r, g, b)
      return string.format('#%02x%02x%02x', r, g, b)
    end

    local function blend(fg, bg, alpha)
      local fr, fg2, fb = hex_to_rgb(fg)
      local br, bg2, bb = hex_to_rgb(bg)
      local r = math.floor((alpha * fr) + ((1 - alpha) * br) + 0.5)
      local g = math.floor((alpha * fg2) + ((1 - alpha) * bg2) + 0.5)
      local b = math.floor((alpha * fb) + ((1 - alpha) * bb) + 0.5)
      return rgb_to_hex(r, g, b)
    end

    local function set_indent_highlights()
      -- Keep indent guides subtle by blending Normal fg into bg.
      local normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
      local fg = normal.fg and string.format('#%06x', normal.fg) or '#d3c6aa'
      local bg = normal.bg and string.format('#%06x', normal.bg) or '#1f2326'
      local subtle = blend(fg, bg, 0.22)

      vim.api.nvim_set_hl(0, 'SnacksIndent', { fg = subtle, nocombine = true })
      vim.api.nvim_set_hl(0, 'SnacksIndentScope', { fg = subtle, nocombine = true })
      vim.api.nvim_set_hl(0, 'SnacksIndentChunk', { fg = subtle, nocombine = true })

      for i = 1, 8 do
        vim.api.nvim_set_hl(0, 'SnacksIndent' .. i, { fg = subtle, nocombine = true })
      end
    end

    set_indent_highlights()
    vim.api.nvim_create_autocmd('ColorScheme', {
      group = vim.api.nvim_create_augroup('corr3ia-snacks-indent-colors', { clear = true }),
      callback = set_indent_highlights,
    })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd

        Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
        Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
        Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>uL'
        Snacks.toggle.diagnostics():map '<leader>ud'
        Snacks.toggle.line_number():map '<leader>ul'
        Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>uc'
        Snacks.toggle.treesitter():map '<leader>uT'
        Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Backgoound' }):map '<leader>ub'
        Snacks.toggle.inlay_hints():map '<leader>uh'
        Snacks.toggle.indent():map '<leader>ug'
        Snacks.toggle.dim():map '<leader>uD'
      end,
    })
  end,
}
