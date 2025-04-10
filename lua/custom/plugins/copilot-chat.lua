return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'github/copilot.vim' }, -- or zbirenbaum/copilot.lua
      { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
    },
    keys = {
      { '<leader>zc', ':CopilotChat<CR>', mode = 'n', desc = 'Copilot Chat' },
      { '<leader>ze', ':CopilotChatExplain<CR>', mode = 'v', desc = 'Copilot Chat Explain Code' },
      { '<leader>zr', ':CopilotChatReview<CR>', mode = 'v', desc = 'Copilot Chat Review Code' },
      { '<leader>zf', ':CopilotChatFix<CR>', mode = 'v', desc = 'Copilot Chat Fix Code' },
      { '<leader>zo', ':CopilotChatOptimize<CR>', mode = 'v', desc = 'Copilot Chat Optimize Code' },
      { '<leader>zd', ':CopilotChatDocs<CR>', mode = 'v', desc = 'Copilot Chat Generate Docs' },
      { '<leader>zt', ':CopilotChatTests<CR>', mode = 'v', desc = 'Copilot Chat Generate Tests' },
      { '<leader>zm', ':CopilotChatCommit<CR>', mode = 'n', desc = 'Copilot Chat Generate Commit Message' },
    },
  },
}
