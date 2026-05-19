local M = {}

local function fallback_map(mode, lhs, rhs, desc, opts)
  vim.keymap.set(mode, lhs, rhs, vim.tbl_extend('force', { desc = desc }, opts or {}))
end

local function snacks_picker(method, opts)
  return function()
    local Snacks = require 'snacks'
    Snacks.picker[method](opts and opts() or nil)
  end
end

local function snacks_call(callback)
  return function()
    callback(require 'snacks')
  end
end

function M.setup(map)
  map = map or fallback_map

  local plugin_maps = {
    {
      {
        'n',
        '<leader>cf',
        function()
          require('conform').format({ async = true, lsp_format = 'fallback' }, function(err)
            if err then
              vim.notify('Format failed: ' .. err, vim.log.levels.ERROR)
              return
            end
            vim.notify('Buffer formatted successfully', vim.log.levels.INFO)
          end)
        end,
        '[F]ormat buffer',
      },
      {
        'v',
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
        '[F]ormat selected text',
      },
    },
    {
      {
        'i',
        '<C-g>',
        function()
          require('blink.cmp').show { providers = { 'copilot' } }
        end,
        'Mostrar sugestões do Copilot',
      },
      {
        'i',
        '<Tab>',
        function()
          local suggestion = require 'copilot.suggestion'
          if suggestion.is_visible() then
            suggestion.accept()
            return
          end
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, false, true), 'n', false)
        end,
        'Copilot: Aceita sugestão ou Tab normal',
      },
    },
    {
      { 'n', '<leader>cco', '<Cmd>CccPick<CR>', 'Ccc [O]pen', { silent = true } },
      { 'n', '<leader>ccc', '<Cmd>CccHighlighterToggle<CR>', 'Ccc [C]olor [C]olumn', { silent = true } },
      { 'n', '<leader>ccv', '<Cmd>CccConvert<CR>', 'Ccc [C]onvert', { silent = true } },
    },
    {
      { 'n', '<leader>ee', '<CMD>Oil<CR>', 'Open parent directory' },
    },
    {
      {
        'n',
        ']t',
        function()
          require('todo-comments').jump_next()
        end,
        'Next todo comment',
      },
      {
        'n',
        '[t',
        function()
          require('todo-comments').jump_prev()
        end,
        'Previous todo comment',
      },
    },
    {
      {
        'n',
        '<leader>ql',
        function()
          require('quicker').toggle()
        end,
        'Toggle quickfix',
      },
    },
    {
      {
        { 'n', 'x', 'o' },
        's',
        function()
          require('flash').jump()
        end,
        'Flash',
      },
      {
        { 'n', 'x', 'o' },
        'S',
        function()
          require('flash').treesitter()
        end,
        'Flash Treesitter',
      },
      {
        'o',
        'r',
        function()
          require('flash').remote()
        end,
        'Remote Flash',
      },
      {
        { 'o', 'x' },
        'R',
        function()
          require('flash').treesitter_search()
        end,
        'Treesitter Search',
      },
      {
        'c',
        '<C-s>',
        function()
          require('flash').toggle()
        end,
        'Toggle Flash Search',
      },
    },
    {
      { 'n', '<leader>ha', '<cmd>Grapple toggle<cr>', 'Grapple: toggle tag' },
      { 'n', '<leader>hq', '<cmd>Grapple toggle_tags<cr>', 'Grapple: toggle tags menu' },
      { 'n', '<leader>1', '<cmd>Grapple select index=1<cr>', 'Grapple: select tag 1' },
      { 'n', '<leader>2', '<cmd>Grapple select index=2<cr>', 'Grapple: select tag 2' },
      { 'n', '<leader>3', '<cmd>Grapple select index=3<cr>', 'Grapple: select tag 3' },
      { 'n', '<leader>4', '<cmd>Grapple select index=4<cr>', 'Grapple: select tag 4' },
      { 'n', '<leader>5', '<cmd>Grapple select index=5<cr>', 'Grapple: select tag 5' },
    },
    {
      {
        { 'n', 't', 'i', 'x' },
        '<leader>aa',
        function()
          require('sidekick.cli').toggle()
        end,
        'Sidekick: Toggle CLI',
      },
      {
        'n',
        '<leader>as',
        function()
          require('sidekick.cli').select { filter = { installed = true } }
        end,
        'Sidekick: Select CLI Tool',
      },
      {
        'n',
        '<leader>ad',
        function()
          require('sidekick.cli').close()
        end,
        'Sidekick: Detach CLI Session',
      },
      {
        { 'n', 'x' },
        '<leader>at',
        function()
          require('sidekick.cli').send { msg = '{this}' }
        end,
        'Sidekick: Send This',
      },
      {
        'n',
        '<leader>af',
        function()
          require('sidekick.cli').send { msg = '{file}' }
        end,
        'Sidekick: Send File',
      },
      {
        'x',
        '<leader>av',
        function()
          require('sidekick.cli').send { msg = '{selection}' }
        end,
        'Sidekick: Send Visual Selection',
      },
      {
        { 'n', 'x' },
        '<leader>ap',
        function()
          require('sidekick.cli').prompt()
        end,
        'Sidekick: Select Prompt',
      },
      {
        'n',
        '<leader>aq',
        function()
          vim.ui.input({ prompt = 'Pergunta rápida para IA: ' }, function(input)
            if not input or input == '' then
              return
            end
            require('sidekick.cli').send {
              msg = input .. '\n\nContexto atual:\n{this}',
            }
          end)
        end,
        'Sidekick: Quick Ask (contexto atual)',
      },
      {
        'n',
        '<leader>al',
        function()
          require('sidekick.cli').send {
            msg = 'Gere APENAS uma linha de código para o contexto abaixo. Sem explicações.\n\n{this}',
          }
        end,
        'Sidekick: Gerar 1 linha',
      },
      {
        'x',
        '<leader>ae',
        function()
          require('sidekick.cli').send {
            msg = 'Ajuste SOMENTE o trecho selecionado. Retorne apenas código final.\n\n{selection}',
          }
        end,
        'Sidekick: Ajustar seleção',
      },
      {
        'n',
        '<leader>ag',
        function()
          require('sidekick.cli').toggle { name = 'gemini', focus = true }
        end,
        'Sidekick: Gemini (Flash)',
      },
    },
    {
      { 'n', '<leader>xX', '<cmd>Trouble diagnostics toggle<cr>', 'Diagnostics (Trouble)' },
      { 'n', '<leader>xx', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', 'Buffer Diagnostics (Trouble)' },
      { 'n', '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', 'Symbols (Trouble)' },
      { 'n', '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', 'LSP Definitions / references / ... (Trouble)' },
      { 'n', '<leader>xL', '<cmd>Trouble loclist toggle<cr>', 'Location List (Trouble)' },
      { 'n', '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', 'Quickfix List (Trouble)' },
      { 'n', '<leader>xT', '<cmd>Trouble todo toggle<cr>', 'TODO (Trouble)' },
      { 'n', '<leader>xt', '<cmd>Trouble todo toggle filter.buf=0<cr>', 'TODO (Trouble)' },
    },
    {
      {
        'n',
        '<leader>ff',
        snacks_call(function(Snacks)
          Snacks.picker.smart {
            layout = { preview = { enabled = false } },
            sort = function(a, b)
              if a.score ~= b.score then
                return a.score > b.score
              end
              return #(a.text or '') < #(b.text or '')
            end,
          }
        end),
        'Smart Find Files',
      },
      {
        'n',
        '<leader><leader>',
        snacks_call(function(Snacks)
          Snacks.picker.buffers { layout = { preview = { enabled = false } } }
        end),
        'Buffers',
      },
      { 'n', '<leader>:', snacks_picker 'command_history', 'Command History' },
      { 'n', '<leader>fc', snacks_call(function(Snacks)
        Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
      end), 'Find Config File' },
      {
        'n',
        '<leader>fg',
        snacks_call(function(Snacks)
          Snacks.picker.git_files {
            layout = { preview = { enabled = false } },
            sort = function(a, b)
              if a.score ~= b.score then
                return a.score > b.score
              end
              return #(a.text or '') < #(b.text or '')
            end,
          }
        end),
        'Find Files',
      },
      {
        'n',
        '<leader>sf',
        snacks_call(function(Snacks)
          Snacks.picker.files {
            layout = { preview = { enabled = false } },
            sort = function(a, b)
              if a.score ~= b.score then
                return a.score > b.score
              end
              return #(a.text or '') < #(b.text or '')
            end,
          }
        end),
        'Find Git Files',
      },
      { 'n', '<leader>fp', snacks_picker 'projects', 'Projects' },
      { 'n', '<leader>fr', snacks_call(function(Snacks)
        Snacks.picker.recent { filter = { cwd = true } }
      end), 'Recent files' },
      { 'n', '<leader>gb', snacks_picker 'git_branches', 'Git Branches' },
      { 'n', '<leader>gl', snacks_picker 'git_log', 'Git Log' },
      { 'n', '<leader>gL', snacks_picker 'git_log_line', 'Git Log Line' },
      { 'n', '<leader>gs', snacks_picker 'git_status', 'Git Status' },
      { 'n', '<leader>gS', snacks_picker 'git_stash', 'Git Stash' },
      { 'n', '<leader>gd', snacks_picker 'git_diff', 'Git Diff (Hunks)' },
      { 'n', '<leader>gf', snacks_picker 'git_log_file', 'Git Log File' },
      { 'n', '<leader>sb', snacks_picker 'lines', 'Buffer Lines' },
      { 'n', '<leader>sB', snacks_picker 'grep_buffers', 'Grep Open Buffers' },
      { 'n', '<leader>ss', snacks_picker 'grep', 'Grep' },
      { { 'n', 'x' }, '<leader>sw', snacks_picker 'grep_word', 'Visual selection or word' },
      { 'n', '<leader>s"', snacks_picker 'registers', 'Registers' },
      { 'n', '<leader>s/', snacks_picker 'search_history', 'Search History' },
      { 'n', '<leader>sa', snacks_picker 'autocmds', 'Autocmds' },
      { 'n', '<leader>sc', snacks_picker 'command_history', 'Command History' },
      { 'n', '<leader>sC', snacks_picker 'commands', 'Commands' },
      {
        'n',
        '<leader>sd',
        snacks_call(function(Snacks)
          Snacks.picker.diagnostics_buffer { layout = { preview = { enabled = false } } }
        end),
        'Diagnostics',
      },
      {
        'n',
        '<leader>sD',
        snacks_call(function(Snacks)
          Snacks.picker.diagnostics { layout = { preview = { enabled = false } } }
        end),
        'Buffer Diagnostics',
      },
      { 'n', '<leader>sh', snacks_picker 'help', 'Help Pages' },
      { 'n', '<leader>sH', snacks_picker 'highlights', 'Highlights' },
      { 'n', '<leader>si', snacks_picker 'icons', 'Icons' },
      { 'n', '<leader>sj', snacks_picker 'jumps', 'Jumps' },
      { 'n', '<leader>sk', snacks_call(function(Snacks)
        Snacks.picker.keymaps { layout = { preview = { enabled = false } } }
      end), 'Keymaps' },
      { 'n', '<leader>sl', snacks_picker 'loclist', 'Location List' },
      { 'n', '<leader>sm', snacks_picker 'marks', 'Marks' },
      { 'n', '<leader>sM', snacks_picker 'man', 'Man Pages' },
      -- { 'n', '<leader>sp', snacks_picker 'lazy', 'Search for Plugin Spec' },
      { 'n', '<leader>sq', snacks_picker 'qflist', 'Quickfix List' },
      { 'n', '<leader>sR', snacks_picker 'resume', 'Resume' },
      { 'n', '<leader>su', snacks_picker 'undo', 'Undo History' },
      { 'n', '<leader>uC', snacks_picker 'colorschemes', 'Colorschemes' },
      { 'n', 'grd', snacks_picker 'lsp_definitions', 'Goto Definition' },
      { 'n', '<leader>gd', snacks_picker 'lsp_definitions', 'Goto Definition' },
      { 'n', 'grD', snacks_picker 'lsp_declarations', 'Goto Declaration' },
      { 'n', 'grr', snacks_picker 'lsp_references', 'References', { nowait = true } },
      { 'n', 'gri', snacks_picker 'lsp_implementations', 'Goto Implementation' },
      { 'n', 'gry', snacks_picker 'lsp_type_definitions', 'Goto T[y]pe Definition' },
      {
        'n',
        'gro',
        snacks_call(function(Snacks)
          Snacks.picker.lsp_symbols {
            scope = 'buf',
            layout = { preview = { enabled = false } },
          }
        end),
        'LSP Symbols',
      },
      { 'n', '<leader>sS', snacks_picker 'lsp_workspace_symbols', 'LSP Workspace Symbols' },
      { 'n', '<leader>n', snacks_call(function(Snacks)
        Snacks.notifier.show_history()
      end), 'Notification History' },
      { 'n', '<leader>bd', snacks_call(function(Snacks)
        Snacks.bufdelete()
      end), 'Delete Buffer' },
      { 'n', '<leader>cR', snacks_call(function(Snacks)
        Snacks.rename.rename_file()
      end), 'Rename File' },
      { { 'n', 'v' }, '<leader>gB', snacks_call(function(Snacks)
        Snacks.gitbrowse()
      end), 'Git Browse' },
      { 'n', '<leader>gg', snacks_call(function(Snacks)
        Snacks.lazygit()
      end), 'Lazygit' },
      { 'n', '<leader>un', snacks_call(function(Snacks)
        Snacks.notifier.hide()
      end), 'Dismiss All Notifications' },
      { 'n', '<C-/>', snacks_call(function(Snacks)
        Snacks.terminal()
      end), 'Toggle Terminal' },
      { 't', '<C-/>', snacks_call(function(Snacks)
        Snacks.terminal()
      end), 'Toggle Terminal' },
      { 'n', '<C-_>', snacks_call(function(Snacks)
        Snacks.terminal()
      end), 'which_key_ignore' },
      {
        { 'n', 't' },
        ']]',
        function()
          require('snacks').words.jump(vim.v.count1)
        end,
        'Next Reference',
      },
      {
        { 'n', 't' },
        '[[',
        function()
          require('snacks').words.jump(-vim.v.count1)
        end,
        'Prev Reference',
      },
      {
        'n',
        '<leader>N',
        snacks_call(function(Snacks)
          Snacks.win {
            file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
            width = 0.6,
            height = 0.6,
            wo = { spell = false, wrap = false, signcolumn = 'yes', statuscolumn = ' ', conceallevel = 3 },
          }
        end),
        'Neovim News',
      },
    },
  }

  for _, group in ipairs(plugin_maps) do
    for _, item in ipairs(group) do
      map(item[1], item[2], item[3], item[4], item[5])
    end
  end

  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('corr3ia-plugin-http-keymaps', { clear = true }),
    pattern = 'http',
    callback = function(event)
      local opts = { buffer = event.buf, silent = true }
      local kulala = require 'kulala'
      map('n', '<leader>hr', kulala.run, '[H]TTP [R]un request', opts)
      map('n', '<leader>hi', kulala.inspect, '[H]TTP [I]nspect', opts)
      map('n', '<leader>ht', kulala.toggle_view, '[H]TTP [T]oggle view', opts)
      map('n', '<leader>hp', kulala.jump_prev, '[H]TTP [P]revious', opts)
      map('n', '<leader>hn', kulala.jump_next, '[H]TTP [N]ext', opts)
      map('n', '<leader>hc', kulala.copy, '[H]TTP [C]opy as cURL', opts)
    end,
  })
end

return M
