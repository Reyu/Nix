require('telescope').load_extension('dap')

local dap = require('dap')
dap.defaults.fallback.external_terminal = {
  command = 'alacritty';
  args = {'-e'};
}
