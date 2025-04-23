-- Colorscheme configuration for Neovim using Catppuccin theme
return {
  'catppuccin/nvim',
  name = 'catppuccin',
  config = function()
    require('catppuccin').setup {
      flavour = 'mocha', -- latte, frappe, macchiato, mocha
      background = { -- :h background
        light = 'latte',
        dark = 'mocha',
      },
      transparent_background = false, -- disables setting the background color.
      show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
      term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
      dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = 'dark',
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
      },
      no_italic = false, -- Force no italic
      no_bold = true, -- Force no bold
      no_underline = true, -- Force no underline
      styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { 'italic' }, -- Change the style of comments
        conditionals = { 'italic' },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
        -- miscs = {}, -- Uncomment to turn off hard-coded styles
      },
      color_overrides = {},
      custom_highlights = {},
      default_integrations = true,
      integrations = {
        blink_cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = true,
        noice = true,
        harpoon = true,
        mason = true,
        mini = {
          enabled = true,
          indentscope_color = '',
        },
        dropbar = {
          enabled = true,
          color_mode = false, -- enable color for kind's texts, not just kind's icons
        },
        indent_blankline = {
          enabled = true,
          scope_color = '', -- catppuccin color (eg. `lavender`) Default: text
          colored_indent_levels = false,
        },
        copilot_vim = true,
        snacks = {
          enabled = true,
          indent_scope_color = '', -- catppuccin color (eg. `lavender`) Default: text
        },
        nvim_surround = true,
        flash = true,
        lsp_trouble = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { 'italic' },
            hints = { 'italic' },
            warnings = { 'italic' },
            information = { 'italic' },
            ok = { 'italic' },
          },
          underlines = {
            errors = { 'underline' },
            hints = { 'underline' },
            warnings = { 'underline' },
            information = { 'underline' },
            ok = { 'underline' },
          },
          inlay_hints = {
            background = true,
          },
        },
        which_key = true,
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
      },
    }

    -- setup must be called before loading
    vim.cmd.colorscheme 'catppuccin'
  end,
}

-- *****************************************************************************************
-- Norde colorscheme
-- return {
--   'gbprod/nord.nvim',
--   lazy = false,
--   priority = 1000,
--   config = function()
--     require('nord').setup {
--       -- your configuration comes here
--       -- or leave it empty to use the default settings
--       transparent = false, -- Enable this to disable setting the background color
--       terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
--       diff = { mode = 'bg' }, -- enables/disables colorful backgrounds when used in diff mode. values : [bg|fg]
--       borders = true, -- Enable the border between verticaly split windows visible
--       errors = { mode = 'bg' }, -- Display mode for errors and diagnostics
--       -- values : [bg|fg|none]
--       search = { theme = 'vim' }, -- theme for highlighting search results
--       -- values : [vim|vscode]
--       styles = {
--         -- Style to be applied to different syntax groups
--         -- Value is any valid attr-list value for `:help nvim_set_hl`
--         comments = { italic = true },
--         keywords = {},
--         functions = {},
--         variables = {},
--
--         -- To customize lualine/bufferline
--         bufferline = {
--           current = {},
--           modified = { italic = true },
--         },
--       },
--
--       -- colorblind mode
--       -- see https://github.com/EdenEast/nightfox.nvim#colorblind
--       -- simulation mode has not been implemented yet.
--       colorblind = {
--         enable = false,
--         preserve_background = false,
--         severity = {
--           protan = 0.0,
--           deutan = 0.0,
--           tritan = 0.0,
--         },
--       },
--
--       -- Override the default colors
--       ---@param colors Nord.Palette
--       on_colors = function(colors) end,
--
--       --- You can override specific highlights to use other groups or a hex color
--       --- function will be called with all highlights and the colorScheme table
--       ---@param colors Nord.Palette
--       on_highlights = function(highlights, colors) end,
--     }
--     vim.cmd.colorscheme 'nord'
--   end,
-- }
--
-- *****************************************************************************************
--
--  Rose pine
-- return {
--   'rose-pine/neovim',
--   name = 'rose-pine',
--   config = function()
--     require('rose-pine').setup {
--       variant = 'auto', -- auto, main, moon, or dawn
--       dark_variant = 'main', -- main, moon, or dawn
--       dim_inactive_windows = false,
--       extend_background_behind_borders = true,
--
--       enable = {
--         terminal = true,
--         legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
--         migrations = true, -- Handle deprecated options automatically
--       },
--
--       styles = {
--         bold = true,
--         italic = true,
--         transparency = false,
--       },
--
--       groups = {
--         border = 'muted',
--         link = 'iris',
--         panel = 'surface',
--
--         error = 'love',
--         hint = 'iris',
--         info = 'foam',
--         note = 'pine',
--         todo = 'rose',
--         warn = 'gold',
--
--         git_add = 'foam',
--         git_change = 'rose',
--         git_delete = 'love',
--         git_dirty = 'rose',
--         git_ignore = 'muted',
--         git_merge = 'iris',
--         git_rename = 'pine',
--         git_stage = 'iris',
--         git_text = 'rose',
--         git_untracked = 'subtle',
--
--         h1 = 'iris',
--         h2 = 'foam',
--         h3 = 'rose',
--         h4 = 'gold',
--         h5 = 'pine',
--         h6 = 'foam',
--       },
--
--       palette = {
--         -- Override the builtin palette per variant
--         -- moon = {
--         --     base = '#18191a',
--         --     overlay = '#363738',
--         -- },
--       },
--
--       -- NOTE: Highlight groups are extended (merged) by default. Disable this
--       -- per group via `inherit = false`
--       highlight_groups = {
--         -- Comment = { fg = "foam" },
--         -- StatusLine = { fg = "love", bg = "love", blend = 15 },
--         -- VertSplit = { fg = "muted", bg = "muted" },
--         -- Visual = { fg = "base", bg = "text", inherit = false },
--       },
--
--       before_highlight = function(group, highlight, palette)
--         -- Disable all undercurls
--         -- if highlight.undercurl then
--         --     highlight.undercurl = false
--         -- end
--         --
--         -- Change palette colour
--         -- if highlight.fg == palette.pine then
--         --     highlight.fg = palette.foam
--         -- end
--       end,
--     }
--
--     vim.cmd 'colorscheme rose-pine'
--   end,
-- }
