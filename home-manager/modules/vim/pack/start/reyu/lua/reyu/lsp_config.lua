require('neoconf').setup()
require('neodev').setup({ library = { plugins = { 'neotest' }, types = true } })

local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.diagnostic.config({
        virtual_text = true,
        float = { source = "always" }
    })

    local function preview_location_callback(_, result)
        if result == nil or vim.tbl_isempty(result) then return nil end
        vim.lsp.util.preview_location(result[1], { border = "rounded" })
    end

    function PeekDefinition()
        local params = vim.lsp.util.make_position_params(0, 'utf-16')
        return vim.lsp.buf_request(bufnr, 'textDocument/definition', params,
            preview_location_callback)
    end

    -- Mappings.
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
        { silent = true, noremap = true, buffer = bufnr, desc = 'Goto Declaration' })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition,
        { silent = true, noremap = true, buffer = bufnr, desc = 'Goto Definition' })
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation,
        { silent = true, noremap = true, buffer = bufnr, desc = 'Goto Implementation' })
    vim.keymap.set('n', 'gr', vim.lsp.buf.references,
        { silent = true, noremap = true, buffer = bufnr, desc = 'Goto References' })
    vim.keymap.set('n', 'K', function()
        local winid = require('ufo').peekFoldedLinesUnderCursor()
        if not winid then
            vim.lsp.buf.hover()
        end
    end,
        { silent = true, noremap = true, buffer = bufnr, desc = 'Show hover menu' })
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help,
        { silent = true, noremap = true, buffer = bufnr, desc = 'Show signature help' })
    vim.keymap.set('n', '<LocalLeader>wa', vim.lsp.buf.add_workspace_folder,
        { silent = true, noremap = true, buffer = bufnr, desc = 'Add workspace folder' })
    vim.keymap.set('n', '<LocalLeader>wr', vim.lsp.buf.remove_workspace_folder,
        { silent = true, noremap = true, buffer = bufnr, desc = 'Remove workspace folder' })
    vim.keymap.set('n', '<LocalLeader>wr', vim.lsp.buf.list_workspace_folders,
        { silent = true, noremap = true, buffer = bufnr, desc = 'List workspace folders' })
    vim.keymap.set('n', '<LocalLeader>D', vim.lsp.buf.type_definition,
        { silent = true, noremap = true, buffer = bufnr, desc = 'Type definition' })
    vim.keymap.set('n', '<LocalLeader>p', PeekDefinition,
        { silent = true, noremap = true, buffer = bufnr, desc = 'Peek definition' })
    vim.keymap.set('n', '<LocalLeader>r', vim.lsp.buf.rename,
        { silent = true, noremap = true, buffer = bufnr, desc = 'Rename symbol' })
    vim.keymap.set('n', '<LocalLeader>e', vim.diagnostic.open_float,
        { silent = true, noremap = true, buffer = bufnr, desc = 'Show line diagnostics' })
    vim.keymap.set('n', '<LocalLeader>q', vim.diagnostic.setloclist,
        { silent = true, noremap = true, buffer = bufnr, desc = 'Set location list' })
    vim.keymap.set('n', '<LocalLeader>a', vim.lsp.buf.code_action,
        { silent = true, noremap = true, buffer = bufnr, desc = 'Run code actions' })
    vim.keymap.set('n', '<LocalLeader>s', vim.lsp.buf.signature_help,
        { silent = true, noremap = true, buffer = bufnr, desc = 'Signature help' })
    vim.keymap.set('n', '<LocalLeader>f', vim.lsp.buf.format,
        { silent = true, noremap = true, buffer = bufnr, desc = 'Run formatter' })

    local function hasCap(cap) return client.server_capabilities[cap] ~= nil end

    -- Set some keybinds conditional on server capabilities
    if hasCap("document_formatting") then
        vim.keymap.set('n', '<LocalLeader>f', vim.lsp.buf.format,
            { silent = true, noremap = true, buffer = bufnr, desc = 'Run formatter' })
    end
    if hasCap("document_range_formatting") then
        vim.keymap.set('v', '<LocalLeader>f', vim.lsp.buf.range_format,
            { silent = true, noremap = true, buffer = bufnr, desc = 'Run formatter' })
    end

    -- Set autocommands conditional on server_capabilities
    if hasCap("document_highlight") then
        vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd!
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]]   , false)
    end
end

-- Set lspconfig defaults
local nvim_lsp = require('lspconfig')

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}

nvim_lsp.util.default_config = vim.tbl_extend("force",
    nvim_lsp.util.default_config, {
    on_attach = on_attach,
    handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover,
            { border = "rounded" }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers
            .signature_help,
            { border = "rounded" }),
    },
    capabilities = capabilities,
    log_level = vim.lsp.protocol.MessageType.Log,
    message_level = vim.lsp.protocol.MessageType.Log,
    settings = {
        json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true }
        },
        Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false }
        }
    }
})

nvim_lsp.bashls.setup {}
nvim_lsp.dockerls.setup {}
nvim_lsp.hls.setup {}
nvim_lsp.html.setup {}
nvim_lsp.jsonls.setup { cmd = { "json-languageserver", "--stdio" } }
nvim_lsp.ltex.setup {}
nvim_lsp.pyright.setup {}
nvim_lsp.sumneko_lua.setup {}
nvim_lsp.terraformls.setup {}
nvim_lsp.vimls.setup {}
nvim_lsp.yamlls.setup {}

local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.code_actions.gitrebase,
        null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.code_actions.proselint,
        null_ls.builtins.diagnostics.gitlint,
        null_ls.builtins.formatting.trim_newlines,
        null_ls.builtins.formatting.trim_whitespace,
    },
})
