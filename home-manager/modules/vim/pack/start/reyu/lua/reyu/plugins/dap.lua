local dap_virtual_text = require('nvim-dap-virtual-text')
local dap = require('dap')
local dapui = require('dapui')

local function pythonPath()
    local pyenv = vim.fn.trim(vim.fn.system('pyenv which python'))
    local venv = os.getenv("VIRTUAL_ENV")
    if string.find(pyenv, '^/') ~= nil and vim.fn.executable(pyenv) then
        return pyenv
    elseif venv ~= nil and vim.fn.executable(venv .. '/bin/python') == 1 then
        return venv .. '/bin/python'
    else
        return vim.fn.system('which python')
    end
end

require('dap-python').setup(pythonPath())

vim.fn.sign_define('DapBreakpoint', {
    text = '🔴',
    texthl = 'DiagnosticInfo',
    linehl = '',
    numhl = ''
})
vim.fn.sign_define('DapBreakpointCondition', {
    text = '⭕',
    texthl = 'DiagnosticInfo',
    linehl = '',
    numhl = ''
})
vim.fn.sign_define('DapBreakpointRejected', {
    text = '🚫',
    texthl = 'DiagnosticError',
    linehl = '',
    numhl = ''
})
vim.fn.sign_define('DapLogPoint', {
    text = '📓',
    texthl = 'DiagnosticInfo',
    linehl = '',
    numhl = ''
})
vim.fn.sign_define('DapStopped', {
    text = '🛑',
    texthl = 'DiagnosticError',
    linehl = 'DiagnosticUnderlineError',
    numhl = 'DiagnosticError'
})

dap.defaults.fallback.external_terminal = { command = 'alacritty', args = { '-e' } }
dap.adapters = {
    python = {
        type = 'executable',
        command = 'python',
        args = { '-m', 'debugpy.adapter' }
    },
    haskell = {
        type = 'executable',
        command = 'haskell-debug-adapter',
        args = { '--hackage-version=0.0.33.0' }
    },
    nlua = function(callback, config)
        callback({ type = 'server', host = config['host'], port = config['port'] })
    end
}
dap.configurations = {
    haskell = {
        {
            type = 'haskell',
            request = 'launch',
            name = 'Debug Current File',
            workspace = '${workspaceFolder}',
            startup = "${file}",
            startupFunc = function()
                local val = vim.fn.input('Startup Function [main]: ')
                if val ~= "" then return val end
                return 'main'
            end,
            stopOnEntry = true,
            logFile = vim.fn.stdpath('data') .. '/haskell-dap.log',
            logLevel = 'WARN',
            ghciEnv = vim.empty_dict(),
            ghciPrompt = "H>>=",
            ghciInitialPrompt = "λ: ",
            ghciCmd = "ghci-dap --interactive -i${workspaceFolder}/src"
        }
    },
    python = {
        {
            name = "Python = Remote Attach",
            type = "python",
            request = "attach",
            port = 5678,
            host = "0.0.0.0",
        },
        {
            type = 'python',
            request = 'launch',
            name = 'Launch Module',
            module = function()
                local val = vim.fn.input('Module: ')
                assert(val, 'Please provide a module name')
                return val
            end,
            pythonPath = pythonPath,
            logToFile = true,
            justMyCode = false,
        },
    },
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

dapui.setup({
    layouts = {
        {
            elements = {
                { id = "scopes", size = 0.3 },
                { id = "breakpoints", size = 0.3 },
                { id = "stacks", size = 0.2 },
                { id = "watches", size = 0.2 },
            },
            size = 60,
            position = "left",
        },
        {
            elements = {
                "repl",
                "console",
            },
            size = 0.25,
            position = "bottom",
        },
    },
    floating = {
        max_height = nil,
        max_width = nil,
        border = "single",
        mappings = {
            close = { "q", "<Esc>" },
        },
    },
    windows = { indent = 1 },
    render = {
        max_type_length = nil,
        max_value_lines = 100,
    }
})

dap_virtual_text.setup({
    highlight_new_as_changed = true,
    all_frames = true,
})

vim.keymap.set('n', '<F2>', dapui.toggle,
    { silent = true, noremap = true, desc = 'Toggle debug UI' })
vim.keymap.set('n', '<F5>', dap.continue,
    { silent = true, noremap = true, desc = 'Start or Continue debug session' })
vim.keymap.set('n', '<F10>', dap.step_over,
    { silent = true, noremap = true, desc = 'Run debugger for one step' })
vim.keymap.set('n', '<F11>', dap.step_into,
    { silent = true, noremap = true, desc = 'Step into a function or method' })
vim.keymap.set('n', '<F12>', dap.step_out,
    { silent = true, noremap = true, desc = 'Step out of a function or method' })

vim.keymap.set('n', '<LocalLeader>db', dap.toggle_breakpoint,
    { silent = true, noremap = true, desc = 'Creates or removes a breakpoint' })
vim.keymap.set('n', '<LocalLeader>dB', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
    { silent = true, noremap = true, desc = 'Set breakpoint w/ condition' })
vim.keymap.set('n', '<LocalLeader>de', dap.set_exception_breakpoints,
    { silent = true, noremap = true, desc = 'Sets breakpoints on exceptions' })
vim.keymap.set('n', '<LocalLeader>dl', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end,
    { silent = true, noremap = true, desc = 'Set LogPoint' })
vim.keymap.set('n', '<LocalLeader>dc', dap.clear_breakpoints,
    { silent = true, noremap = true, desc = 'Clear all breakpoints' })
vim.keymap.set('n', '<LocalLeader>dr', dap.repl.open,
    { silent = true, noremap = true, desc = 'Open a REPL' })
vim.keymap.set('n', '<LocalLeader>dR', dap.run_last,
    { silent = true, noremap = true, desc = 'Re-runs the last debug-adapter/configuration' })
vim.keymap.set('n', '<LocalLeader>du', dapui.toggle,
    { silent = true, noremap = true, desc = 'Toggle debug UI' })

local has_hydra, Hydra = pcall(require, 'hydra')
if has_hydra then
    local widgets = require("dap.ui.widgets")

    Hydra({
        hint = [[
     _n_: step over   _s_: Continue/Start
     _i_: step into   _b_: Breakpoint
     _o_: step out    _K_: Eval
     _c_: to cursor   _C_: Close UI
     _p_: pause       ^ ^
     _<Esc>_: exit    _q_: Quit
    ]]   ,
        config = {
            color = 'pink',
            invoke_on_body = true,
            hint = {
                position = 'bottom',
                border = 'rounded'
            },
        },
        name = 'dap',
        mode = { 'n', 'x' },
        body = '<leader>dh',
        heads = {
            { 'n', dap.step_over, { silent = true } },
            { 'i', dap.step_into, { silent = true } },
            { 'o', dap.step_out, { silent = true } },
            { 'c', dap.run_to_cursor, { silent = true } },
            { 's', dap.continue, { silent = true } },
            { 'p', dap.pause, { silent = true } },
            { 'b', dap.toggle_breakpoint, { silent = true } },
            { 'K', widgets.hover, { silent = true } },
            { 'q', function()
                dap.disconnect({ terminateDebuggee = false })
            end, { exit = true, silent = true } },
            { 'C', function()
                dap.close()
                dap_virtual_text.refresh()
            end, { silent = true } },
            { '<Esc>', nil, { exit = true, nowait = true } },
        }
    })
end
