-- return {
--   'sainnhe/everforest',
--   lazy = false,
--   priority = 1000,
--   config = function()
--     -- Optionally configure and load the colorscheme
--     -- directly inside the plugin declaration.
--     vim.g.everforest_enable_italic = true
--     vim.g.everforest_background = 'hard' -- 'soft', 'medium', or 'hard'
--     vim.g.everforest_ui_contrast = 'high' -- 'low' or 'highkj
--     vim.g.everforest_diagnostic_text_highlight = true
--     vim.g.everforest_diagnostic_line_highlight = true
--     vim.g.everforest_diagnostic_virtual_text = 'coloured' -- 'grey' or 'coloured'
--     vim.g.everforest_transparent_background = false
--     vim.g.everforest_better_performance = true
--     vim.g.everforest_dim_inactive_windows = false
--     vim.g.everforest_sign_column_background = 'none' -- 'grey' or 'none'
--     vim.g.everforest_spell_foreground = false
--     vim.g.everforest_show_eob = false
--     vim.g.everforest_float_style = 'bright' -- 'bright' or 'dim'
--     vim.g.everforest_inlay_hints_background = 'dimmed' -- 'none' or 'dimmed'
--     vim.g.everforest_current_word = 'bold'
--
--     vim.cmd.colorscheme 'everforest'
--   end,
-- }
-- *****************************************************************************************
-- Everforest
return {
  'neanias/everforest-nvim',
  version = false,
  lazy = false,
  priority = 1000, -- make sure to load this before all the other start plugins
  -- Optional; default configuration will be used if setup isn't called.
  config = function()
    require('everforest').setup {
      ---Controls the "hardness" of the background. Options are "soft", "medium" or "hard".
      ---Default is "medium".
      background = 'hard',
      ---How much of the background should be transparent. 2 will have more UI
      ---components be transparent (e.g. status line background)
      transparent_background_level = 0,
      ---Whether italics should be used for keywords and more.
      italics = true,
      ---Disable italic fonts for comments. Comments are in italics by default, set
      ---this to `true` to make them _not_ italic!
      disable_italic_comments = false,
      ---By default, the colour of the sign column background is the same as the as normal text
      ---background, but you can use a grey background by setting this to `"grey"`.
      sign_column_background = 'none',
      ---The contrast of line numbers, indent lines, etc. Options are `"high"` or
      ---`"low"` (default).
      ui_contrast = 'low',
      ---Dim inactive windows. Only works in Neovim. Can look a bit weird with Telescope.
      ---
      ---When this option is used in conjunction with show_eob set to `false`, the
      ---end of the buffer will only be hidden inside the active window. Inside
      ---inactive windows, the end of buffer filler characters will be visible in
      ---dimmed symbols. This is due to the way Vim and Neovim handle `EndOfBuffer`.
      dim_inactive_windows = false,
      ---Some plugins support highlighting error/warning/info/hint texts, by
      ---default these texts are only underlined, but you can use this option to
      ---also highlight the background of them.
      diagnostic_text_highlight = true,
      ---Which colour the diagnostic text should be. Options are `"grey"` or `"coloured"` (default)
      diagnostic_virtual_text = 'coloured',
      ---Some plugins support highlighting error/warning/info/hint lines, but this
      ---feature is disabled by default in this colour scheme.
      diagnostic_line_highlight = true,
      ---By default, this color scheme won't colour the foreground of |spell|, instead
      ---colored under curls will be used. If you also want to colour the foreground,
      ---set this option to `true`.
      spell_foreground = true,
      ---Whether to show the EndOfBuffer highlight.
      show_eob = false,
      ---Style used to make floating windows stand out from other windows. `"bright"`
      ---makes the background of these windows lighter than |hl-Normal|, whereas
      ---`"dim"` makes it darker.
      ---
      ---Floating windows include for instance diagnostic pop-ups, scrollable
      ---documentation windows from completion engines, overlay windows from
      ---installers, etc.
      ---
      ---NB: This is only significant for dark backgrounds as the light palettes
      ---have the same colour for both values in the switch.
      float_style = 'bright',
      ---Inlay hints are special markers that are displayed inline with the code to
      ---provide you with additional information. You can use this option to customize
      ---the background color of inlay hints.
      ---
      ---Options are `"none"` or `"dimmed"`.
      inlay_hints_background = 'none',
      ---You can override specific highlights to use other groups or a hex colour.
      ---This function will be called with the highlights and colour palette tables.
      ---@param highlight_groups Highlights
      ---@param palette Palette
      on_highlights = function(highlight_groups, palette)
        highlight_groups.DiagnosticVirtualTextError = { fg = '#b86466', bg = 'NONE' }
        highlight_groups.DiagnosticVirtualTextWarn = { fg = '#e69875', bg = 'NONE' }
        highlight_groups.DiagnosticVirtualTextInfo = { fg = '#7fbbb3', bg = 'NONE' }
        highlight_groups.DiagnosticVirtualTextHint = { fg = '#c9c6bf', bg = 'NONE' }

        -- highlight_groups.DiagnosticVirtualLineError = { fg = '#b86466', bg = 'NONE' }
        -- highlight_groups.DiagnosticVirtualLineWarn = { fg = '#e69875', bg = 'NONE' }
        -- highlight_groups.DiagnosticVirtualLineInfo = { fg = '#7fbbb3', bg = 'NONE' }
        -- highlight_groups.DiagnosticVirtualLineHint = { fg = '#c9c6bf', bg = 'NONE' }

        highlight_groups.Visual = { bg = palette.bg_visual, bold = false }

        -- change the background color of the terminal window
        -- highlight_groups.Terminal = { bg = palette.red }
      end,
      ---You can override colours in the palette to use different hex colours.
      ---This function will be called once the base and background colours have
      ---been mixed on the palette.
      ---@param palette Palette
      colours_override = function(palette)
        -- palette.red = '#b86466'
        -- palette.red = '#E67E80'
        palette.red = '#ffa198'
      end,
    }

    vim.cmd [[colorscheme everforest]]
  end,
}
--
-- *****************************************************************************************

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
--
-- return {
--   'rebelot/kanagawa.nvim',
--   config = function()
--     require('kanagawa').setup {
--       compile = false, -- enable compiling the colorscheme
--       undercurl = false, -- enable undercurls
--       commentStyle = { italic = true, bold = false },
--       functionStyle = { bold = false },
--       keywordStyle = { italic = false, bold = false },
--       statementStyle = { bold = false },
--       typeStyle = { bold = false },
--       transparent = false, -- do not set background color
--       dimInactive = false, -- dim inactive window `:h hl-NormalNC`
--       terminalColors = true, -- define vim.g.terminal_color_{0,17}
--       colors = { -- add/modify theme and palette colors
--         palette = {
--           samuraiRed = '#C34043',
--         },
--         theme = {
--           wave = {},
--           lotus = {},
--           dragon = {},
--           all = {
--             ui = {
--               bg_gutter = 'none',
--               underline = 'none',
--               italic = false,
--               bold = false,
--             },
--           },
--         },
--       },
--       overrides = function(colors) -- add/modify highlights
--         return {
--           Boolean = { bold = false },
--           -- LineNr = {
--           --   fg = colors.palette.bg or colors.theme[vim.g.kanagawa_theme or 'dragon'].bg,
--           --   bg = colors.palette.bg or colors.theme[vim.g.kanagawa_theme or 'dragon'].bg,
--           -- },
--         }
--       end,
--       theme = 'wave', -- Load "wave" theme
--       background = { -- map the value of 'background' option to a theme
--         dark = 'wave', -- try "dragon" !
--         light = 'lotus',
--       },
--     }
--
--     vim.cmd.colorscheme 'kanagawa'
--   end,
-- }

-- Colorscheme configuration for Neovim using Catppuccin theme
-- return {
--   'catppuccin/nvim',
--   name = 'catppuccin',
--   config = function()
--     require('catppuccin').setup {
--       flavour = 'mocha', -- latte, frappe, macchiato, mocha
--       background = { -- :h background
--         light = 'latte',
--         dark = 'mocha',
--       },
--       transparent_background = false, -- disables setting the background color.
--       show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
--       term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
--       dim_inactive = {
--         enabled = false, -- dims the background color of inactive window
--         shade = 'dark',
--         percentage = 0.15, -- percentage of the shade to apply to the inactive window
--       },
--       no_italic = false, -- Force no italic
--       no_bold = true, -- Force no bold
--       no_underline = true, -- Force no underline
--       styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
--         comments = { 'italic' }, -- Change the style of comments
--         conditionals = { 'italic' },
--         loops = {},
--         functions = {},
--         keywords = {},
--         strings = {},
--         variables = {},
--         numbers = {},
--         booleans = {},
--         properties = {},
--         types = {},
--         operators = {},
--         -- miscs = {}, -- Uncomment to turn off hard-coded styles
--       },
--       color_overrides = {},
--       custom_highlights = function(colors)
--         return {
--           DiagnosticVirtualTextWarn = { fg = colors.overlay1, bg = colors.none, italic = true },
--         }
--       end,
--       default_integrations = true,
--       integrations = {
--         blink_cmp = true,
--         gitsigns = true,
--         nvimtree = true,
--         treesitter = true,
--         notify = true,
--         noice = true,
--         harpoon = true,
--         mason = true,
--         mini = {
--           enabled = true,
--           indentscope_color = '',
--         },
--         dropbar = {
--           enabled = true,
--           color_mode = false, -- enable color for kind's texts, not just kind's icons
--         },
--         indent_blankline = {
--           enabled = true,
--           scope_color = '', -- catppuccin color (eg. `lavender`) Default: text
--           colored_indent_levels = false,
--         },
--         copilot_vim = true,
--         snacks = {
--           enabled = true,
--           indent_scope_color = '', -- catppuccin color (eg. `lavender`) Default: text
--         },
--         nvim_surround = true,
--         flash = true,
--         lsp_trouble = true,
--         native_lsp = {
--           enabled = true,
--           virtual_text = {
--             errors = { 'italic' },
--             hints = { 'italic' },
--             warnings = { 'italic' },
--             information = { 'italic' },
--             ok = { 'italic' },
--           },
--           underlines = {
--             errors = { 'underline' },
--             hints = { 'underline' },
--             warnings = { 'underline' },
--             information = { 'underline' },
--             ok = { 'underline' },
--           },
--           inlay_hints = {
--             background = true,
--           },
--         },
--         which_key = true,
--         -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
--       },
--     }
--
--     -- setup must be called before loading
--     vim.cmd.colorscheme 'catppuccin'
--   end,
-- }
