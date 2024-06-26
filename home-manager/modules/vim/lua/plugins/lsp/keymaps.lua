local M = {}

M.keys = {
    {'gD', vim.lsp.buf.declaration, desc = 'Goto Declaration'},
    {'gd', '<Cmd>Trouble lsp_type_definitions<CR>', desc = 'Goto Definition'},
    {'gi', '<Cmd>Trouble lsp_implementations<CR>', desc = 'Goto Implementation'},
    {'gr', '<Cmd>Trouble lsp_references<CR>', desc = 'Goto References'}, {
        'K',
        function()
            local winid = require('ufo').peekFoldedLinesUnderCursor()
            if not winid then vim.lsp.buf.hover() end
        end,
        desc = 'Show hover menu'
    }, {'<C-k>', vim.lsp.buf.signature_help, desc = 'Show signature help'}, {
        '<LocalLeader>wa',
        vim.lsp.buf.add_workspace_folder,
        desc = 'Add workspace folder'
    }, {
        '<LocalLeader>wr',
        vim.lsp.buf.remove_workspace_folder,
        desc = 'Remove workspace folder'
    }, {
        '<LocalLeader>wl',
        function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end,
        desc = 'List workspace folders'
    },
    {'<LocalLeader>D', vim.lsp.buf.type_definition, desc = 'Type definition'},
    {'<LocalLeader>z', vim.lsp.buf.rename, desc = 'Rename symbol'},
    {
        '<LocalLeader>e',
        vim.diagnostic.open_float,
        desc = 'Show line diagnostics'
    },
    {'<LocalLeader>q', vim.diagnostic.setloclist, desc = 'Set location list'},
    {'<LocalLeader>ca', vim.lsp.buf.code_action, desc = 'Run code actions'},
    {'<LocalLeader>cl', vim.lsp.codelens.run, desc = 'Run Codelens'},
    {'<LocalLeader>s', vim.lsp.buf.signature_help, desc = 'Signature help'}, {
        '<LocalLeader>f',
        vim.lsp.buf.format,
        desc = 'Run formatter',
    }
}

function M.on_attach(client, bufnr)
    require('which-key').register({['<LocalLeader>c'] = {name = "code"}},
        {buffer = bufnr})
    require('which-key').register({['<LocalLeader>w'] = {name = "workspace"}},
        {buffer = bufnr})

    local Keys = require("lazy.core.handler.keys")
    local keymaps = {}

    for _, value in ipairs(M.keys) do
        local keys = Keys.parse(value)
        if keys[2] == vim.NIL or keys[2] == false then
            keymaps[keys.id] = nil
        else
            keymaps[keys.id] = keys
        end
    end

    for _, keys in pairs(keymaps) do
        if not keys.has or client.server_capabilities[keys.has .. "Provider"] then
            local opts = Keys.opts(keys)
            opts.has = nil
            opts.silent = true
            opts.buffer = bufnr
            if not pcall(function() vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts) end) then
                vim.print("Failed on LSP keymap: " .. keys.lhs)
            end
        end
    end
end

return M
