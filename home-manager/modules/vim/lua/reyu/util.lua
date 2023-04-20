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

return M
