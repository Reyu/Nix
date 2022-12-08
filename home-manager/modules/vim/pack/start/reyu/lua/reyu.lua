local M = {}

function M.setup()
    require('reyu.options')
    require('reyu.theme')
    require('reyu.lsp_config')
    require('reyu.plugins')
end

return M
