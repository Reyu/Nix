require('telescope').load_extension('dap')
local dap = require('dap')
dap.defaults.fallback.external_terminal = {
  command = 'alacritty';
  args = {'-e'};
}

dap.adapters.haskell = {
  type = 'executable';
  command = 'haskell-debug-adapter';
  args = {'--hackage-version=0.0.33.0'};
}
dap.configurations.haskell = {
  {
    type = 'haskell',
    request = 'launch',
    name = 'haskell-debug-adapter',
    workspace = '${workspaceFolder}',
    startup = "${file}",
    stopOnEntry = true,
    logFile = vim.fn.stdpath('data') .. '/haskell-dap.log',
    logLevel = 'WARNING',
    ghciEnv = vim.empty_dict(),
    ghciPrompt = "λ: ",
    ghciInitialPrompt = "λ: ",
    ghciCmd= "cabal exec -- ghci-dap --interactive -i -i${workspaceFolder}",
  },
}
