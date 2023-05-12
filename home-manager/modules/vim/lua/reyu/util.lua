local M = {}

function M.pythonPath()
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

-- Helper functions for Hydra
function M.toggleOpt(opt, trueVal, falseVal)
    local _trueVal = trueVal or true
    local _falseVal = falseVal or false
    return function()
        if vim.o[opt] == _trueVal then
            vim.o[opt] = _falseVal
        else
            vim.o[opt] = _trueVal
        end
    end
end
function M.displayOpt(opt, trueVal)
    local _trueVal = trueVal or true
    return function()
        if vim.o[opt] == _trueVal then
            return "🟢" -- Enabled
        else
            return "🔴" -- Disabled
        end
    end
end

return M
