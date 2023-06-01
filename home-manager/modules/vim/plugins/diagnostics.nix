{ pkgs, ... }: with pkgs.vimPlugins; [
  neotest-python neotest-haskell
  {
    plugin = neotest;
    optional = true;
    type = "lua";
    config = ''
      if not vim.g.started_by_firenvim then
        vim.api.nvim_command('packadd neotest')
        require('which-key').register({ ['<LocalLeader>t'] = "+Tests" })
        local neotest = require('neotest')
        neotest.setup({
          adapters = {
            require('neotest-python')({ python = require('reyu.util').pythonPath() }),
            require('neotest-haskell')
          }
        })
        vim.keymap.set('n', ']n', function() neotest.jump.next({status = 'failed'}) end, { desc = 'Next failed test'})
        vim.keymap.set('n', '[n', function() neotest.jump.prev({status = 'failed'}) end, { desc = 'Previous failed test'})
        vim.keymap.set('n', '<LocalLeader>ts', neotest.summary.toggle, { desc = 'NeoTest Summary'})
        vim.keymap.set('n', '<LocalLeader>ta', function() neotest.run.run({suite = true}) end, { desc = 'Run test suite'})
        vim.keymap.set('n', '<LocalLeader>tf', function() neotest.run.run(vim.fn.expand('%')) end, { desc = 'Run tests in file'})
        vim.keymap.set('n', '<LocalLeader>tn', neotest.run.run, { desc = 'Run nearest test'})
        vim.keymap.set('n', '<LocalLeader>td', function() neotest.run.run_last({strategy = 'dap'}) end, { desc = 'Debug last test'})
        vim.keymap.set('n', '<LocalLeader>tD', function() neotest.run.run({suite = true, strategy = 'dap'}) end, { desc = 'Debug test suite'})
        vim.keymap.set('n', '<LocalLeader>to', neotest.output.open, { desc = 'View output'})
        vim.keymap.set('n', '<LocalLeader>tO', neotest.output_panel.toggle, { desc = 'Toggle output pannel'})
        vim.keymap.set('n', '<LocalLeader>tk', neotest.run.stop, { desc = 'Stop running tests'})
      end
    '';
  }
  {
    plugin = trouble-nvim;
    optional = true;
    type = "lua";
    config = ''
      if not vim.g.started_by_firenvim then
        vim.api.nvim_command('packadd trouble.nvim')
        local trouble = require('trouble')
        trouble.setup()

        vim.keymap.set('n', '<LocalLeader>xx', '<CMD>TroubleToggle<CR>',
          {silent = true, noremap = true, desc = 'Toggle'}
        )
        vim.keymap.set('n', '<LocalLeader>xw', '<CMD>TroubleToggle workspace_diagnostics<CR>',
          {silent = true, noremap = true, desc = 'Workspace diagnostics'}
        )
        vim.keymap.set('n', '<LocalLeader>xd', '<CMD>TroubleToggle document_diagnostics<CR>',
          {silent = true, noremap = true, desc = 'Document diagnostics'}
        )
        vim.keymap.set('n', '<LocalLeader>xl', '<CMD>TroubleToggle loclist<CR>',
          {silent = true, noremap = true, desc = 'Location list'}
        )
        vim.keymap.set('n', '<LocalLeader>xq', '<CMD>TroubleToggle quickfix<CR>',
          {silent = true, noremap = true, desc = 'Quickfix'}
        )
        vim.keymap.set('n', 'gR', '<cmd>TroubleToggle lsp_references<cr>',
          {silent = true, noremap = true, desc = 'LSP References'}
        )
        vim.keymap.set('n', ']x', function() trouble.next({skip_groups = true, jump = true}) end,
          {silent = true, noremap = true, desc = 'Next Trouble item'}
        )
        vim.keymap.set('n', '[x', function() trouble.next({skip_groups = true, jump = true}) end,
          {silent = true, noremap = true, desc = 'Previous Trouble item'}
        )
      end
    '';
  }
  {
    plugin = nvim-dap;
    optional = true;
    type = "lua";
    config = ''
      if not vim.g.started_by_firenvim then
          vim.api.nvim_command('packadd nvim-dap')
          local dap = require('dap')

          require('which-key').register({['<LocalLeader>d'] = {name = 'Debug'}})

          vim.fn.sign_define('DapBreakpoint', {
              text = '🔴',
              texthl = 'DiagnosticInfo',
              linehl = "",
              numhl = ""
          })
          vim.fn.sign_define('DapBreakpointCondition', {
              text = '🚦',
              texthl = 'DiagnosticInfo',
              linehl = "",
              numhl = ""
          })
          vim.fn.sign_define('DapBreakpointRejected', {
              text = '🚫',
              texthl = 'DiagnosticError',
              linehl = "",
              numhl = ""
          })
          vim.fn.sign_define('DapLogPoint', {
              text = '📓',
              texthl = 'DiagnosticInfo',
              linehl = "",
              numhl = ""
          })
          vim.fn.sign_define('DapStopped', {
              text = '🛑',
              texthl = 'DiagnosticError',
              linehl = 'DiagnosticUnderlineError',
              numhl = 'DiagnosticError'
          })

          dap.adapters = {
              nlua = function(callback, config)
                  callback({
                      type = 'server',
                      host = config['host'],
                      port = config['port']
                  })
              end
          }
          dap.configurations = {
              lua = {
                  {
                      type = 'nlua',
                      request = 'attach',
                      name = "Attach to running Neovim instance",
                      host = function()
                          local value = vim.fn.input('Host [127.0.0.1]: ')
                          if value ~= "" then return value end
                          return '127.0.0.1'
                      end,
                      port = function()
                          local val = tonumber(vim.fn.input('Port: '))
                          assert(val, "Please provide a port number")
                          return val
                      end
                  }
              }
          }
          vim.api.nvim_create_autocmd("FileType", {
              pattern = {"dap-repl"},
              callback = require('dap.ext.autocompl').attach
          })
      end
    '';
  }
  {
    plugin = nvim-dap-python;
    optional = true;
    type = "lua";
    config = ''
      if not vim.g.started_by_firenvim then
        vim.api.nvim_command('packadd nvim-dap-python')
        require('dap-python').setup(require('reyu.util').pythonPath())
      end
    '';
  }
  {
    plugin = nvim-dap-ui;
    optional = true;
    type = "lua";
    config = ''
      if not vim.g.started_by_firenvim then
        vim.api.nvim_command('packadd nvim-dap-ui')
        require('dapui').setup({
            layouts = {
                {
                    elements = {
                        {id = 'scopes', size = 0.3},
                        {id = 'breakpoints', size = 0.3},
                        {id = 'stacks', size = 0.2},
                        {id = 'watches', size = 0.2}
                    },
                    size = 60,
                    position = 'left'
                },
                {
                    elements = {'repl', 'console'},
                    size = 0.25,
                    position = 'bottom'
                }
            },
            floating = {
                max_height = nil,
                max_width = nil,
                border = 'single',
                mappings = {close = {'q', '<Esc>'}}
            },
            windows = {indent = 1},
            render = {max_type_length = nil, max_value_lines = 100}
        })
        vim.keymap.set('n', '<LocalLeader>du', require('dapui').toggle, {desc = 'Toggle debug UI'})
      end
    '';
  }
]
