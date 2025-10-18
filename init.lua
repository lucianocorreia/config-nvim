vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.termguicolors = true

vim.opt.mouse = 'a'

vim.opt.showmode = false

vim.opt.wrap = false

vim.o.winborder = 'rounded'

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

vim.opt.breakindent = true

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes'

vim.opt.updatetime = 250

vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = false

vim.opt.inccommand = 'split'

vim.opt.cursorline = true

vim.opt.scrolloff = 15

vim.opt.confirm = true

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>qq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('i', 'jj', '<ESC>', { desc = 'Exit insert mode with jj' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Movement
vim.keymap.set('n', '<C-L>', '<C-W><C-L>', { desc = 'Move to the [L]eft window' })
vim.keymap.set('n', '<C-H>', '<C-W><C-H>', { desc = 'Move to the [H]ight window' })
vim.keymap.set('n', '<C-K>', '<C-W><C-K>', { desc = 'Move to the [K]ight window' })
vim.keymap.set('n', '<C-J>', '<C-W><C-J>', { desc = 'Move to the [J]ight window' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Move [D]own' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Move [U]p' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Move [N]ext' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Move [N]ext' })

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move [J] down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move [K] up' })

vim.keymap.set('v', '<', '<gv', { desc = 'Move [L]eft', silent = true })
vim.keymap.set('v', '>', '>gv', { desc = 'Move [R]ight', silent = true })

-- -- Resize Window
vim.keymap.set('n', 'H', '2<C-W>>', { desc = 'Resize [H]orizontal' })
vim.keymap.set('n', 'L', '2<C-W><', { desc = 'Resize [L]eft' })

-- Paste in visual mode
vim.keymap.set('n', '<leader>P', '"*p', { desc = 'Paste [P]aste' })
vim.keymap.set('n', '<leader>p', 'viwP', { desc = 'Paste in world', silent = true })
vim.keymap.set('n', '<leader>y', 'viwy', { desc = 'Copy [Y]ank' })

-- replace
vim.keymap.set('n', '<leader>rp', ':%s/\\<<C-r><C-w>\\>//gI<Left><Left><Left>', { desc = 'Replace [P]attern' })
-- vim.keymap.set('n', '<leader>ww', '<Cmd>w<CR>', { desc = 'Save [W]rite' })

-- fold
vim.keymap.set('v', '<C-f>', ':fold<CR>', { desc = 'Fold', silent = true })
vim.keymap.set('n', '<C-f>', '<Cmd>foldopen<CR>', { desc = 'Fold [O]pen', silent = true })

-- buffers (next and previous)
vim.keymap.set('n', '<leader>bn', '<Cmd>bn<CR>', { desc = '[B]uffer [N]ext' })
vim.keymap.set('n', '<leader>bp', '<Cmd>bp<CR>', { desc = '[B]uffer [P]revious' })

-- custom key maps
vim.keymap.set('n', '<leader>lj', require('funcs').log_variable_json, { desc = 'Log PHP variable with json_encode', noremap = true })
vim.keymap.set('n', '<leader>ll', require('funcs').log_variable, { desc = 'Log PHP variable', noremap = true })
vim.keymap.set('n', '<leader>ld', require('funcs').insert_data_get, { desc = "Insert data_get($ , '')" })

-- laravel commands
vim.keymap.set('n', '<leader>lc', function()
  require('corr3ia.laravel').clear_cache()
end, { desc = 'Laravel: config:cache' })

vim.keymap.set('n', '<leader>lo', function()
  require('corr3ia.laravel').optimize_clear()
end, { desc = 'Laravel: optimize:clear' })

vim.keymap.set('n', '<leader>lt', function()
  require('corr3ia.laravel').tinker()
end, { desc = 'Laravel: tinker' })

vim.keymap.set('n', '<leader>lm', function()
  require('corr3ia.laravel').create_migration_klingo()
end, { desc = 'Laravel: Criar migration klingo' })

-- corr3ia-todo commands
vim.keymap.set('n', '<leader>td', function()
  require('corr3ia.todo').open()
end, { desc = 'Corr3ia-todo: Abrir TODO list' })

vim.keymap.set('n', '<leader>tt', function()
  require('corr3ia.todo').toggle()
end, { desc = 'Corr3ia-todo: Toggle TODO list' })

vim.keymap.set('n', '<leader>ta', function()
  require('corr3ia.todo').add()
end, { desc = 'Corr3ia-todo: Add TODO' })

vim.keymap.set('n', '<leader>th', function()
  require('corr3ia.todo').header()
end, { desc = 'Corr3ia-todo: Add Section' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink
      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          -- map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          -- map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          -- map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          -- map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          -- map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          -- map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        -- virtual_lines = { current_line = true },
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      local capabilities = vim.lsp.protocol.make_client_capabilities()

      capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities({}, false))

      local servers = {
        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'vuels',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}

            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})

            -- configure vuels to ignore project warning (Fixed)
            if server_name == 'vuels' then
              server.settings = {
                vetur = {
                  ignoreProjectWarning = true,
                  validation = {
                    template = true,
                    script = true,
                    style = true,
                  },
                  completion = {
                    autoImport = true,
                    tagCasing = 'kebab',
                  },
                },
              }
            end

            -- require('lspconfig')[server_name].setup(server)
            vim.lsp.enable(server_name)
            vim.lsp.config(server_name, server)

            -- local server = servers[server_name] or {}
            -- -- This handles overriding only values explicitly passed
            -- -- by the server configuration above. Useful when disabling
            -- -- certain features of an LSP (for example, turning off formatting for ts_ls)
            -- server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            -- require('lspconfig')[server_name].setup(server)
          end,
        },
      }

      vim.lsp.config('vls', {
        filetypes = { 'vue' },
        settings = {
          vetur = {
            ignoreProjectWarning = true,
            validation = {
              template = true,
              script = true,
              style = true,
            },
            completion = {
              autoImport = true,
              tagCasing = 'kebab',
            },
          },
        },
      })

      -- require('lspconfig').vuels.setup {
      --   filetypes = { 'vue' },
      --   settings = {
      --     vetur = {
      --       ignoreProjectWarning = true,
      --       validation = {
      --         template = true,
      --         script = true,
      --         style = true,
      --       },
      --       completion = {
      --         autoImport = true,
      --         tagCasing = 'kebab',
      --       },
      --     },
      --   },
      -- }
    end,
  },

  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  { import = 'custom.plugins' },

  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
