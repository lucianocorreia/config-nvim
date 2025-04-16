local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s('dg', {
    t 'data_get(',
    t '$',
    i(1, 'var'),
    t ', ',
    t "'",
    i(2, 'key'),
    t "'",
    t ')',
  }),

  s({ trig = 'lj', name = 'Log JSON', dscr = 'Logger JSON' }, {
    t 'logger(json_encode(',
    i(1, '$var'),
    t ', JSON_PRETTY_PRINT));',
  }),

  -- Log JSON 2
  s({ trig = 'ljj', name = 'Log JSON 2', dscr = 'Logger JSON with label' }, {
    t "logger('",
    i(1, 'label'),
    t ": ' .  json_encode(",
    i(2, '$var'),
    t ', JSON_PRETTY_PRINT));',
  }),
}
