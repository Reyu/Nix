local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    require("which-key").register({
        g = {
            name = "Goto",
            D = {function() vim.lsp.buf.declaration() end, "Goto Declaration"},
            d = {function() vim.lsp.buf.definition() end, "Goto Definition"},
            i = {
                function() vim.lsp.buf.implementation() end,
                "Goto Implementation"
            },
            r = {function() vim.lsp.buf.references() end, "Goto References"}
        },
        K = {function() vim.lsp.buf.hover() end, "Show hover menu"},
        ["<C-k>"] = {
            function() vim.lsp.buf.signature_help() end, "Signature Help"
        },
        ["<space>"] = {
            name = "LSP Actions",
            w = {
                name = "LSP Workspace",
                a = {
                    function()
                        vim.lsp.buf.add_workspace_folder()
                    end, "Add workspase folder"
                },
                r = {
                    function()
                        vim.lsp.buf.remove_workspace_folder()
                    end, "Remove workspace folder"
                },
                l = {
                    function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, "List workspace folders"
                }
            },
            D = {
                function() vim.lsp.buf.type_definition() end, "Type Definition"
            },
            r = {function() vim.lsp.buf.rename() end, "Rename"},
            e = {
                function() vim.diagnostic.open_float() end,
                "Show line diagnostics"
            },
            q = {function() vim.diagnostic.setloclist() end, "Set loclist"},
            a = {function() vim.lsp.buf.code_action() end, "Run Code Action"},
            s = {function() vim.lsp.buf.signature_help() end, "Signature Help"},
            f = {
                function() vim.lsp.buf.format({async = true}) end,
                "Run formatter"
            }
        }
    }, {mode = "n", buffer = buffnr})

    function hasCap(cap)
        return client.server_capabilities[cap] ~= nil
    end

    -- Set some keybinds conditional on server capabilities
    if hasCap("document_formatting") then
        require("which-key").register({
            f = {function() vim.lsp.buf.formatting() end, "Formatt Buffer"}
        }, {prefix = "<space>"})
    end
    if hasCap("document_range_formatting") then
        require("which-key").register({
            f = {
                function() vim.lsp.buf.range_formatting() end,
                "Formatt Selection"
            }
        }, {mode = "v"})
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
    ]], false)
    end
end

-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Use a loop to conveniently both setup defined servers and
-- map buffer local keybindings when the language server attaches
local servers = {
    "bashls", "dockerls", "hls", "html", -- "jedi_language_server",
    "jsonls", "pyright", "terraformls", "vimls", "yamlls"
}
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        log_level = vim.lsp.protocol.MessageType.Log,
        message_level = vim.lsp.protocol.MessageType.Log,
        settings = {haskell = {formattingProvider = "stylish-haskell"}}
    }
end
