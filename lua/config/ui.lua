local M = {}

function M.setup()
  local ok, ui2 = pcall(require, 'vim._core.ui2')
  if not ok then
    return
  end

  ui2.enable({
    enable = true,
    msg = {
      target = 'cmd',
      pager = { height = 1 },
      msg = { height = 0.5, timeout = 4500 },
      dialog = { height = 0.5 },
      cmd = { height = 0.5 },
    },
  })
end

M.setup()

return M
