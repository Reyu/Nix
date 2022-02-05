require('telescope').load_extension('dap')

local dap = require('dap')
dap.defaults.fallback.external_terminal = {
  command = 'alacritty';
  args = {'-e'};
}

-- TODO: Fix this non-working bullshit
dap.adapters.haskell = {
  type = 'executable';
  command = 'haskell-debug-adapter';
  args = {'--hackage-version=0.0.33.0'};
}
dap.configurations.haskell = {
  {
    type = 'haskell',
    request = 'launch',
    name = 'ghci-dap',
    workspace = '${workspaceFolder}',
    startup = "${file}",
    stopOnEntry = true,
    logFile = vim.fn.stdpath('data') .. '/haskell-dap.log',
    logLevel = 'DEBUG',
    ghciEnv = vim.empty_dict(),
    ghciPrompt = "Prelude> ",
    ghciInitialPrompt = "Prelude> ",
    ghciCmd = "ghci-dap --interactive -i -i${workspaceFolder}",
  },
}

dap.adapters.python = {
  type = 'executable';
  command = 'python';
  args = { '-m', 'debugpy.adapter' };
}
dap.configurations.python = {
  {
    type = 'python';
    request = 'launch';
    name = "Launch file";
    program = "${file}";
  },
}
