local which_key = require('which-key')
which_key.setup({
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 20,
    },
  },
  window = {
    border = 'single',
    position = 'bottom',
    margin = { 1, 0, 1, 0 },
    padding = { 2, 2, 2, 2 },
    winblend = 0
  },
  disable = {
    buftypes = {},
    filetypes = { 'TelescopePrompt' },
  }
})
