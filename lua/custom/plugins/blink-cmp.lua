-- Autocompletion: blink.cmp
return {
  'saghen/blink.cmp',
  event = 'VimEnter',
  version = '1.*',
  dependencies = {
    -- Copilot integration via blink-copilot
    'fang2hou/blink-copilot',
    -- Snippet Engine
    {
      'L3MON4D3/LuaSnip',
      version = '2.*',
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        --    See the README about individual language/framework/plugin snippets:
        --    https://github.com/rafamadriz/friendly-snippets
        {
          'rafamadriz/friendly-snippets',
          config = function()
            local ok_vscode, vscode_loader = pcall(require, 'luasnip.loaders.from_vscode')
            if ok_vscode then
              vscode_loader.lazy_load()
            end

            local ok_lua, lua_loader = pcall(require, 'luasnip.loaders.from_lua')
            if ok_lua then
              lua_loader.lazy_load { paths = { '~/.config/nvim/snippets' } }
            end
          end,
        },
      },
      config = function()
        local ok, luasnip = pcall(require, 'luasnip')
        if not ok then
          return
        end

        -- Configuração para desativar o snippet quando sair da região
        luasnip.config.setup {
          region_check_events = 'CursorMoved,CursorHold,InsertEnter',
          delete_check_events = 'TextChanged,InsertLeave',
        }
      end,
    },
    -- Optional lazydev integration for Lua development
    {
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
        library = {
          { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
      },
    },
  },
  config = function()
    local blink = require 'blink.cmp'
    local has_luasnip = pcall(require, 'luasnip')
    local has_lazydev = pcall(require, 'lazydev.integrations.blink')

    local default_sources = { 'lsp', 'buffer', 'path' }
    if has_luasnip then
      table.insert(default_sources, 'snippets')
    end
    if has_lazydev then
      table.insert(default_sources, 'lazydev')
    end

    local providers = {
      -- copilot = {
      --   module = 'blink-copilot',
      --   name = 'copilot',
      --   score_offset = 100,
      --   async = true,
      --   opts = {
      --     max_completions = 3,
      --   },
      -- },
    }

    if has_lazydev then
      providers.lazydev = {
        module = 'lazydev.integrations.blink',
        score_offset = 100,
        fallbacks = { 'lsp' },
      }
    end

    blink.setup {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'enter',

        -- Para mais advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
        ghost_text = { enabled = false },
        menu = {
          auto_show = true, -- 🔥 FIX: Mostrar menu automaticamente
          winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None,CurSearch:None',
          draw = {
            columns = { { 'kind_icon', 'label', 'label_description', gap = 1 }, { 'kind' } },
          },
        },
      },

      sources = {
        default = default_sources,
        providers = providers,
      },

      snippets = has_luasnip and { preset = 'luasnip' } or { preset = 'default' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'lua' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    }
  end,
}
