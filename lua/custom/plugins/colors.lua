-- *****************************************************************************************
-- Everforest
-- return {
--   'neanias/everforest-nvim',
--   version = false,
--   lazy = false,
--   priority = 1000, -- make sure to load this before all the other start plugins
--   -- Optional; default configuration will be used if setup isn't called.
--   config = function()
--     require('everforest').setup {
--       ---Controls the "hardness" of the background. Options are "soft", "medium" or "hard".
--       ---Default is "medium".
--       background = 'hard',
--       ---How much of the background should be transparent. 2 will have more UI
--       ---components be transparent (e.g. status line background)
--       transparent_background_level = 0,
--       ---Whether italics should be used for keywords and more.
--       italics = false,
--       ---Disable italic fonts for comments. Comments are in italics by default, set
--       ---this to `true` to make them _not_ italic!
--       disable_italic_comments = true,
--       ---By default, the colour of the sign column background is the same as the as normal text
--       ---background, but you can use a grey background by setting this to `"grey"`.
--       sign_column_background = 'none',
--       ---The contrast of line numbers, indent lines, etc. Options are `"high"` or
--       ---`"low"` (default).
--       ui_contrast = 'low',
--       ---Dim inactive windows. Only works in Neovim. Can look a bit weird with Telescope.
--       ---
--       ---When this option is used in conjunction with show_eob set to `false`, the
--       ---end of the buffer will only be hidden inside the active window. Inside
--       ---inactive windows, the end of buffer filler characters will be visible in
--       ---dimmed symbols. This is due to the way Vim and Neovim handle `EndOfBuffer`.
--       dim_inactive_windows = false,
--       ---Some plugins support highlighting error/warning/info/hint texts, by
--       ---default these texts are only underlined, but you can use this option to
--       ---also highlight the background of them.
--       diagnostic_text_highlight = true,
--       ---Which colour the diagnostic text should be. Options are `"grey"` or `"coloured"` (default)
--       diagnostic_virtual_text = 'coloured',
--       ---Some plugins support highlighting error/warning/info/hint lines, but this
--       ---feature is disabled by default in this colour scheme.
--       diagnostic_line_highlight = true,
--       ---By default, this color scheme won't colour the foreground of |spell|, instead
--       ---colored under curls will be used. If you also want to colour the foreground,
--       ---set this option to `true`.
--       spell_foreground = true,
--       ---Whether to show the EndOfBuffer highlight.
--       show_eob = false,
--       ---Style used to make floating windows stand out from other windows. `"bright"`
--       ---makes the background of these windows lighter than |hl-Normal|, whereas
--       ---`"dim"` makes it darker.
--       ---
--       ---Floating windows include for instance diagnostic pop-ups, scrollable
--       ---documentation windows from completion engines, overlay windows from
--       ---installers, etc.
--       ---
--       ---NB: This is only significant for dark backgrounds as the light palettes
--       ---have the same colour for both values in the switch.
--       float_style = 'bright',
--       ---Inlay hints are special markers that are displayed inline with the code to
--       ---provide you with additional information. You can use this option to customize
--       ---the background color of inlay hints.
--       ---
--       ---Options are `"none"` or `"dimmed"`.
--       inlay_hints_background = 'none',
--       ---You can override specific highlights to use other groups or a hex colour.
--       ---This function will be called with the highlights and colour palette tables.
--       ---@param highlight_groups Highlights
--       ---@param palette Palette
--       on_highlights = function(highlight_groups, palette)
--         highlight_groups.DiagnosticVirtualTextError = { fg = '#b86466', bg = 'NONE' }
--         highlight_groups.DiagnosticVirtualTextWarn = { fg = '#e69875', bg = 'NONE' }
--         highlight_groups.DiagnosticVirtualTextInfo = { fg = '#7fbbb3', bg = 'NONE' }
--         highlight_groups.DiagnosticVirtualTextHint = { fg = '#c9c6bf', bg = 'NONE' }
--
--         -- 🎨 Customização de cores de seleção e yank
--         -- Cor de seleção visual (quando você seleciona texto)
--         -- highlight_groups.Visual = {
--         --   bg = '#5A6B44', -- Verde escuro mais suave
--         --   fg = 'NONE',    -- Mantém a cor do texto original
--         --   bold = false
--         -- }
--         --
--         -- -- Cor quando você faz yank (cópia) - IncSearch é usado para highlight do yank
--         -- highlight_groups.IncSearch = {
--         --   bg = '#dbbc7f', -- Cor clara/amarelada
--         --   fg = '#343F44', -- Texto escuro para contraste
--         --   bold = false
--         -- }
--
--         -- 🐘 PHP: Destacar caractere $ com cor de keywords
--         -- Usar a mesma cor de public, static, class, function, etc.
--         highlight_groups.phpVarSelector = {
--           fg = palette.purple, -- Mesma cor das palavras-chave (public, static, etc.)
--           bold = false,
--         }
--
--         -- Alternativa mais específica para treesitter (caso use)
--         highlight_groups['@variable.builtin.php'] = {
--           fg = palette.purple,
--           bold = false,
--         }
--
--         -- Para syntax highlighting tradicional
--         highlight_groups.phpIdentifier = {
--           fg = palette.fg, -- Cor normal para o nome da variável
--         }
--
--         -- 🔷 C#: Remover itálicos de classes, tipos e namespaces
--         highlight_groups['@type.cs'] = { fg = palette.blue, italic = false }
--         highlight_groups['@type.builtin.cs'] = { fg = palette.blue, italic = false }
--         highlight_groups['@namespace.cs'] = { fg = palette.yellow, italic = false }
--         highlight_groups['@property.cs'] = { fg = palette.fg, italic = false }
--         highlight_groups['@method.cs'] = { fg = palette.green, italic = false }
--         highlight_groups['@keyword.cs'] = { fg = palette.purple, italic = false }
--         highlight_groups['@attribute.cs'] = { fg = palette.orange, italic = false }
--
--         -- Para syntax highlighting tradicional (fallback)
--         highlight_groups.csType = { fg = palette.blue, italic = false }
--         highlight_groups.csClass = { fg = palette.blue, italic = false }
--         highlight_groups.csClassType = { fg = palette.blue, italic = false }
--         highlight_groups.csStorage = { fg = palette.purple, italic = false }
--
--         -- change the background color of the terminal window
--         highlight_groups.Terminal = { bg = palette.red }
--       end,
--       ---You can override colours in the palette to use different hex colours.
--       ---This function will be called once the base and background colours have
--       ---been mixed on the palette.
--       ---@param palette Palette
--       colours_override = function(palette)
--         -- palette.red = '#b86466'
--         -- palette.red = '#E67E80'
--         -- palette.red = '#ffa198'
--         palette.red = '#E67E80'
--       end,
--     }
--
--     vim.cmd [[colorscheme everforest]]
--   end,
-- }

-- *****************************************************************************************
-- Colorscheme vague
--
return {
  'vague-theme/vague.nvim',
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other plugins
  config = function()
    require('vague').setup {
      transparent = false, -- don't set background
      -- disable bold/italic globally in `style`
      bold = false,
      italic = false,
      style = {
        -- "none" is the same thing as default. But "italic" and "bold" are also valid options
        boolean = 'bold',
        number = 'none',
        float = 'none',
        error = 'bold',
        comments = 'italic',
        conditionals = 'none',
        functions = 'none',
        headings = 'bold',
        operators = 'none',
        strings = 'italic',
        variables = 'none',

        -- keywords
        keywords = 'none',
        keyword_return = 'italic',
        keywords_loop = 'none',
        keywords_label = 'none',
        keywords_exception = 'none',

        -- builtin
        builtin_constants = 'bold',
        builtin_functions = 'none',
        builtin_types = 'bold',
        builtin_variables = 'none',
      },
      -- plugin styles where applicable
      -- make an issue/pr if you'd like to see more styling options!
      plugins = {
        lsp = {
          diagnostic_error = 'bold',
          diagnostic_hint = 'none',
          diagnostic_info = 'italic',
          diagnostic_ok = 'none',
          diagnostic_warn = 'bold',
        },
        neotest = {
          focused = 'bold',
          adapter_name = 'bold',
        },
        telescope = {
          match = 'bold',
        },
      },

      -- Override highlights or add new highlights
      on_highlights = function(highlights, colors)
        -- Blink-cmp: linha selecionada com fundo diferente mas sem afetar o texto
        highlights.BlinkCmpMenuSelection = { bg = colors.visual, blend = 10 }

        -- Snacks picker: linha selecionada sem afetar matches
        highlights.Visual = { bg = colors.visual }
        highlights.SnacksPickerListCursorLine = { bg = colors.visual }

        -- Comentários: ajustar cor
        highlights.Comment = { fg = '#627562', italic = true } -- tom esverdeado balanceado; original: '#606079'
        
        -- 🔷 C#: Comentários com a mesma cor customizada
        highlights['@comment.cs'] = { fg = '#627562', italic = true }
        highlights['@lsp.type.comment.cs'] = { fg = '#627562', italic = true }

        -- 🔷 Blade: Melhorar syntax highlighting de diretivas PHP/Blade
        -- Diretivas Blade (@if, @foreach, @endif, etc.) em laranja/dourado
        -- data_get() em azul claro (builtin)
        highlights.bladeDirective = { fg = '#e0a363', bold = true } -- laranja/number color
        highlights.bladeDelimiter = { fg = '#e0a363', bold = true }
        highlights.bladeEcho = { fg = '#b4d4cf' } -- azul claro builtin
        highlights.bladeComment = { fg = colors.comment, italic = true }
        
        -- Treesitter highlights para Blade
        highlights['@keyword.blade'] = { fg = '#e0a363', bold = true }
        highlights['@keyword.directive.blade'] = { fg = '#e0a363', bold = true }
        highlights['@tag.delimiter.blade'] = { fg = '#e0a363', bold = true }
        highlights['@function.blade'] = { fg = '#b4d4cf' } -- funções em azul claro
        highlights['@function.builtin.blade'] = { fg = '#b4d4cf' }
        
        -- 🔷 HTML: Ajustar cor dos brackets <> para azul (mesma cor do nome da tag)
        highlights.htmlTag = { fg = '#6e94b2' } -- < > em azul
        highlights.htmlEndTag = { fg = '#6e94b2' } -- </ > em azul
      end,

      -- Override colors
      colors = {
        bg = '#1a1a1c',
        inactiveBg = '#22222a',
        fg = '#cdcdcd',
        floatBorder = '#878787',
        line = '#252530',
        comment = '#6b6b80', -- original: '#606079'
        builtin = '#b4d4cf',
        func = '#c48282',
        string = '#e8b589',
        number = '#e0a363',
        property = '#c3c3d5',
        constant = '#aeaed1',
        parameter = '#bb9dbd',
        visual = '#333738',
        error = '#d8647e',
        warning = '#f3be7c',
        hint = '#7e98e8',
        operator = '#90a0b5',
        keyword = '#6e94b2',
        type = '#9bb4bc',
        search = '#405065',
        plus = '#7fa563',
        delta = '#f3be7c',
      },
    }
    vim.cmd 'colorscheme vague'
  end,
}

--
-- *****************************************************************************************
-- Colorscheme rose-pine
-- return {
--   'rose-pine/neovim',
--   name = 'rose-pine',
--   config = function()
--     require('rose-pine').setup {
--       variant = 'auto', -- auto, main, moon, or dawn
--       dark_variant = 'moon', -- main, moon, or dawn
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
--         bold = false,
--         italic = false,
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
--         -- Comment = { fg = 'iris' },
--         -- StatusLine = { fg = "love", bg = "love", blend = 15 },
--         -- VertSplit = { fg = "muted", bg = "muted" },
--         -- Visual = { fg = 'base', bg = 'text', inherit = false },
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

-- *****************************************************************************************

-- Colorscheme configuration for Neovim using Catppuccin theme
-- return {
--   'catppuccin/nvim',
--   name = 'catppuccin',
--   config = function()
--     require('catppuccin').setup {
--       flavour = 'macchiato', -- latte, frappe, macchiato, mocha
--       background = { -- :h background
--         light = 'latte',
--         dark = 'macchiato',
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
