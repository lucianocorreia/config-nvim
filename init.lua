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
vim.keymap.set('n', '<leader>lj', require('funcs').log_variable_json,
  { desc = 'Log PHP variable with json_encode', noremap = true })
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

  -- LSP Configuration using Neovim 0.11 native LSP
  {
    'j-hui/fidget.nvim',
    opts = {},
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

-- LSP Configuration using Neovim 0.11 native LSP
-- Configure diagnostics
vim.diagnostic.config({
  severity_sort = true,
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
})

-- LSP Attach autocommand for keymaps and features
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- LSP Keymaps (using the default ones from Neovim 0.11)
    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

    -- Get the client to check for capabilities
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client then
      -- Function to check if client supports method (compatible with 0.10 and 0.11)
      local function client_supports_method(method, bufnr)
        if vim.fn.has('nvim-0.11') == 1 then
          return client:supports_method(method, bufnr)
        else
          return client.supports_method and client.supports_method(method, { bufnr = bufnr })
        end
      end

      -- Document highlights
      if client_supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
        local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
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
          group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds({ group = 'lsp-highlight', buffer = event2.buf })
          end,
        })
      end

      -- Inlay hints toggle
      if client_supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
        map('<leader>th', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
        end, '[T]oggle Inlay [H]ints')
      end
    end
  end,
})

-- Enable language servers
vim.lsp.enable({
  'lua_ls',
  'intelephense',
  'vls',
  'ts_ls',
  'html',
  'cssls',
  'jsonls',
})

-- LSP Status and Debugging Commands
-- Command to show LSP clients attached to current buffer
vim.api.nvim_create_user_command('LspStatus', function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    print('No LSP clients attached to current buffer')
    return
  end

  print('LSP Clients attached to current buffer:')
  print('=====================================')
  for _, client in pairs(clients) do
    print(string.format('• %s (id: %d)', client.name, client.id))
    print(string.format('  Root dir: %s', client.root_dir or 'N/A'))
    print(string.format('  Filetypes: %s', table.concat(client.config.filetypes or {}, ', ')))
    if client.server_capabilities then
      local caps = {}
      if client.server_capabilities.completionProvider then table.insert(caps, 'completion') end
      if client.server_capabilities.hoverProvider then table.insert(caps, 'hover') end
      if client.server_capabilities.definitionProvider then table.insert(caps, 'definition') end
      if client.server_capabilities.referencesProvider then table.insert(caps, 'references') end
      if client.server_capabilities.renameProvider then table.insert(caps, 'rename') end
      print(string.format('  Capabilities: %s', table.concat(caps, ', ')))
    end
    print('')
  end
end, { desc = 'Show LSP status for current buffer' })

-- Command to list all LSP clients
vim.api.nvim_create_user_command('LspClients', function()
  local clients = vim.lsp.get_clients()
  if #clients == 0 then
    print('No LSP clients running')
    return
  end

  print('All LSP Clients:')
  print('================')
  for _, client in pairs(clients) do
    print(string.format('• %s (id: %d) - %s', client.name, client.id,
      #client.attached_buffers > 0 and 'Active' or 'Inactive'))
  end
end, { desc = 'List all LSP clients' })

-- Command to restart LSP for current buffer
vim.api.nvim_create_user_command('LspRestart', function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    print('No LSP clients to restart')
    return
  end

  for _, client in pairs(clients) do
    print('Restarting LSP client: ' .. client.name)
    vim.lsp.enable(client.name, false)  -- Disable
    vim.schedule(function()
      vim.lsp.enable(client.name, true) -- Re-enable
    end)
  end
end, { desc = 'Restart LSP clients for current buffer' })

-- Command to show enabled LSP configurations
vim.api.nvim_create_user_command('LspConfigs', function()
  local configs = { 'lua_ls', 'intelephense', 'vls', 'ts_ls', 'html', 'cssls', 'jsonls' }
  print('LSP Configurations:')
  print('===================')
  for _, config in ipairs(configs) do
    local enabled = vim.lsp.is_enabled(config)
    local status = enabled and '✅ Enabled' or '❌ Disabled'
    print(string.format('• %s: %s', config, status))
  end
  print('\nUse :checkhealth vim.lsp for detailed diagnostics')
end, { desc = 'Show LSP configuration status' })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
