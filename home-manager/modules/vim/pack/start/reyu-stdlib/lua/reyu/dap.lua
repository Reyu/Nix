require('telescope').load_extension('dap')

local dap = require('dap')
local function pythonPath()
    local venv = os.getenv("VIRTUAL_ENV")
    if venv ~= nil and vim.fn.executable(venv .. '/bin/python') == 1 then
        return venv .. '/bin/python'
    else
        return vim.fn.system('which python')
    end
end

dap.defaults.fallback.external_terminal = {command = 'alacritty', args = {'-e'}}
dap.adapters = {
    python = {
        type = 'executable',
        command = 'python',
        args = {'-m', 'debugpy.adapter'}
    },
    haskell = {
        type = 'executable',
        command = 'haskell-debug-adapter',
        args = {'--hackage-version=0.0.33.0'}
    },
    nlua = function(callback, config)
        callback({type = 'server', host = config.host, port = config.port})
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
            type = 'python',
            request = 'launch',
            name = "Launch file",
            pythonPath = pythonPath,
            program = "${file}"
        }, {
            type = 'python',
            request = 'launch',
            name = 'Launch file with arguments',
            pythonPath = pythonPath,
            program = '${file}',
            args = function()
                local args_string = vim.fn.input('Arguments: ')
                return vim.split(args_string, " +")
            end
        }
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
