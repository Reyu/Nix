local on_attach = function(client, bufnr)
    vim.cmd [[packadd fidget-nvim]]
    require("fidget").setup({window = {blend = 0}})

    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.diagnostic.config({
        virtual_text = {source = "always"},
        float = {source = "always"}
    })

    local function preview_location_callback(_, result)
        if result == nil or vim.tbl_isempty(result) then return nil end
        vim.lsp.util.preview_location(result[1], {border = "rounded"})
    end

    function PeekDefinition()
        local params = vim.lsp.util.make_position_params()
        return vim.lsp.buf_request(bufnr, 'textDocument/definition', params,
                                   preview_location_callback)
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
    }, {mode = "n", noremap = true, silent = true, buffer = bufnr})

    local function hasCap(cap) return client.server_capabilities[cap] ~= nil end

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

-- Set lspconfig defaults
local nvim_lsp = require('lspconfig')
nvim_lsp.util.default_config = vim.tbl_extend("force",
                                              nvim_lsp.util.default_config, {
    on_attach = on_attach,
    handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover,
                                              {border = "rounded"}),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers
                                                          .signature_help,
                                                      {border = "rounded"}),
        ['window/showMessage'] = function(_, result, ctx, _)
                local client = vim.lsp.get_client_by_id(ctx.client_id)
                local lvl = ({'ERROR', 'WARN', 'INFO', 'DEBUG'})[result.type]
                require("notify")(result.message, lvl, {
                    title = 'LSP | ' .. client.name,
                    timeout = 10000,
                    keep = function() return lvl == 'ERROR' or lvl == 'WARN' end
                })
        end

    },
    capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol
                                                                    .make_client_capabilities()),
    log_level = vim.lsp.protocol.MessageType.Log,
    message_level = vim.lsp.protocol.MessageType.Log,
    settings = {
        json = {
            schemas = require('schemastore').json.schemas(),
            validate = {enable = true}
        },
        Lua = {
            runtime = {version = 'LuaJIT'},
            diagnostics = {globals = {'vim'}},
            workspace = {library = vim.api.nvim_get_runtime_file("", true)},
            telemetry = {enable = false}
        },
        haskell = {
            formattingProvider = "floskell",
            plugin = {rename = {globalOn = true}}
        }
    }
})

nvim_lsp.bashls.setup {}
nvim_lsp.dockerls.setup {}
nvim_lsp.html.setup {}
nvim_lsp.jsonls.setup {cmd = {"json-languageserver", "--stdio"}}
nvim_lsp.ltex.setup {}
nvim_lsp.nil_ls.setup {}
nvim_lsp.pyright.setup {}
nvim_lsp.rnix.setup {}
nvim_lsp.sumneko_lua.setup {}
nvim_lsp.terraformls.setup {}
nvim_lsp.vimls.setup {}
nvim_lsp.yamlls.setup {}

local ht = require("haskell-tools")
ht.setup {
    hls = {
        on_attach = function(client, bufnr)
            -- haskell-language-server relies heavily on codeLenses,
            -- so auto-refresh (see advanced configuration) is enabled by default
            require("which-key").register({
                l = {vim.lsp.codelens.run, "Run Code Lens"},
                h = {
                    name = "Haskell",
                    s = {ht.hoogle.hoogle_signature, "Hoogle Signature"}
                }
            }, {
                mode = "n",
                prefix = "<space>",
                noremap = true,
                silent = true,
                buffer = bufnr
            })
            nvim_lsp.util.default_config.on_attach(client, bufnr)
        end
    }
}
