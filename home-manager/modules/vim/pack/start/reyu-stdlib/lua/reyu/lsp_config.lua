local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
    vim.cmd[[packadd fidget-nvim]]
    require("fidget").setup({
        window = {
            blend = 0,
        },
    })

    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.diagnostic.config({
        virtual_text = {source = "always"},
        float = {source = "always"}
    })

    local function preview_location_callback(_, result)
        if result == nil or vim.tbl_isempty(result) then
            return nil
        end
        vim.lsp.util.preview_location(result[1], { border = "rounded" })
    end

    function PeekDefinition()
        local params = vim.lsp.util.make_position_params()
        return vim.lsp.buf_request(bufnr, 'textDocument/definition', params, preview_location_callback)
    end

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
            p = {function() PeekDefinition() end, "Peek Definition"},
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

    function hasCap(cap) return client.server_capabilities[cap] ~= nil end

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

vim.lsp.handlers['window/showMessage'] =
    function(_, result, ctx)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        local lvl = ({'ERROR', 'WARN', 'INFO', 'DEBUG'})[result.type]
        notify(result.message, lvl, {
            title = 'LSP | ' .. client.name,
            timeout = 10000,
            keep = function() return lvl == 'ERROR' or lvl == 'WARN' end
        })
    end

-- LSP settings (for overriding per client)
local handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = "rounded"}),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {border = "rounded"})
}

-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Use a loop to conveniently both setup defined servers and
-- map buffer local keybindings when the language server attaches
local servers = {
    "bashls", "dockerls", "hls", "html", "jsonls", "pyright", "terraformls",
    "vimls", "yamlls"
}

for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        log_level = vim.lsp.protocol.MessageType.Log,
        message_level = vim.lsp.protocol.MessageType.Log,
        handlers = handlers,
        settings = {
            haskell = {
                formattingProvider = 'floskell',
                plugin = {rename = {globalOn = true}}
            },
            json = {
                schemas = require('schemastore').json.schemas(),
                validate = {enable = true}
            }
        }
    }
    if lsp == "jsonls" then
        nvim_lsp.jsonls.setup({cmd = {"json-languageserver", "--stdio"}})
    end
end
