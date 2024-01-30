local function filter(arr, func)
    local new_index = 1
    local size_orig = #arr
    for old_index, v in ipairs(arr) do
        if func(v, old_index) then
            arr[new_index] = v
            new_index = new_index + 1
        end
    end
    for i = new_index, size_orig do arr[i] = nil end
end

local function filter_diagnostics(diagnostic)
    -- Only filter out Pyright stuff for now
    if diagnostic.source ~= "Pyright" then return true end

    -- Allow kwargs to be unused, sometimes you want many functions to take the
    -- same arguments but you don't use all the arguments in all the functions,
    -- so kwargs is used to suck up all the extras
    if diagnostic.message == '"kwargs" is not accessed' then return false end

    -- Allow variables starting with an underscore
    if string.match(diagnostic.message, '"_.+" is not accessed') then
        return false
    end

    return true
end

local function custom_on_publish_diagnostics(a, result, context, config)
    filter(result.diagnostics, filter_diagnostics)
    vim.lsp.diagnostic.on_publish_diagnostics(a, result, context, config)
end

return {
    {
        "neovim/nvim-lspconfig",
        event = {"BufReadPre", "BufNewFile"},
        dependencies = {
            {
                "folke/neoconf.nvim",
                cmd = "Neoconf",
                opts = {plugins = {jsonls = {configured_servers_only = false}}}
            },
            {"folke/neodev.nvim", opts = {experimental = {pathStrict = true}}},
            "b0o/SchemaStore.nvim"
        },
        opts = {
            diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = false,
                severity_sort = true
            },
            autoformat = true,
            defaults = {on_attach = require('plugins.lsp.util').on_attach},
            servers = {
                nil_ls = {},
                jsonls = {
                    -- lazy-load schemastore when needed
                    on_new_config = function(new_config)
                        new_config.settings.json.schemas = new_config.settings
                                                               .json.schemas or
                                                               {}
                        vim.list_extend(new_config.settings.json.schemas,
                                        require("schemastore").json.schemas())
                    end,
                    settings = {
                        json = {
                            format = {enable = true},
                            validate = {enable = true}
                        }
                    }
                },
                lua_ls = {
                    settings = {
                        Lua = {
                            workspace = {checkThirdParty = false},
                            completion = {callSnippet = "Replace"},
                            diagnostics = {
                                globals = {
                                    'vim'
                                }
                            }
                        }
                    }
                },
                bashls = {},
                dockerls = {},
                html = {},
                pyright = {
                    before_init = function(client, config)
                        local f = io.open(client.rootPath .. "/.python-version")
                        if f ~= nil then
                            config.settings.python.pythonPath = vim.fn['trim'](
                                                                    vim.fn['system'](
                                                                        'pyenv which python'))
                        end
                    end,
                    settings = {python = {pythonPath = {}}}
                },
                vimls = {},
                yamlls = {
                    -- Have to add this for yamlls to understand that we support line folding
                    capabilities = {
                        textDocument = {
                            foldingRange = {
                                dynamicRegistration = false,
                                lineFoldingOnly = true
                            }
                        }
                    },
                    -- lazy-load schemastore when needed
                    on_new_config = function(new_config)
                        new_config.settings.yaml.schemas = new_config.settings
                                                               .yaml.schemas or
                                                               {}
                        vim.list_extend(new_config.settings.yaml.schemas,
                                        require("schemastore").yaml.schemas())
                    end,
                    settings = {
                        redhat = {telemetry = {enabled = false}},
                        yaml = {
                            keyOrdering = false,
                            format = {enable = true},
                            validate = true,
                            schemaStore = {
                                -- Must disable built-in schemaStore support to use
                                -- schemas from SchemaStore.nvim plugin
                                enable = false,
                                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                                url = ""
                            }
                        }
                    }
                }
            }
        },
        config = function(_, opts)
            local nvim_lsp = require('lspconfig')
            vim.diagnostic.config(opts.diagnostics)
            vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
                                                                      custom_on_publish_diagnostics,
                                                                      {})

            nvim_lsp.util.default_config =
                vim.tbl_extend("force", nvim_lsp.util.default_config,
                               opts.defaults or {})

            local capabilities = require("cmp_nvim_lsp").default_capabilities(
                                     vim.lsp.protocol.make_client_capabilities())

            for server, server_opts_ in pairs(opts.servers) do
                local server_opts = vim.tbl_deep_extend("force", {
                    capabilities = vim.deepcopy(capabilities)
                }, server_opts_ or {})
                nvim_lsp[server].setup(server_opts)
            end
        end
    }, {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        event = {"BufReadPre", "BufNewFile"},
        config = true,
        keys = {
            {
                "<Leader>l",
                function() require('lsp_lines').toggle() end,
                silent = true,
                desc = "Toggle lsp_lines"
            }
        }
    }, {
        "mrcjkb/haskell-tools.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim"
        },
        ft = "haskell",
        opts = function()
            return {
                tools = {
                    hover = {stylize_markdown = true},
                    definition = {hoogle_signature_fallback = true}
                },
                hls = {
                    on_attach = require('plugins.lsp.keymaps').on_attach,
                    filetypes = {"haskell"},
                    settings = function(project_root)
                        local ht = require('haskell-tools')
                        return ht.lsp.load_hls_settings(project_root, {
                            settings_file_pattern = 'hls.json'
                        })
                    end
                }
            }
        end,
        config = function(_, opts)
            local ht = require("haskell-tools")
            vim.g.haskell_tools = opts

            local def_opts = {noremap = true, silent = true}
            vim.api.nvim_create_autocmd({'BufEnter', 'BufRead'}, {
                pattern = {"*.hs", "*.hls"},
                desc = "Haskell-Tools keymaps",
                callback = function(ev)
                    local map_opts = vim.tbl_extend('keep', def_opts,
                                                    {buffer = ev.buf})
                    require('which-key').register({
                        ["<LocalLeader>r"] = {name = "Repl"}
                    })
                    map_opts.desc = "Toggle Repl (for package)"
                    vim.keymap.set('n', '<LocalLeader>rr', ht.repl.toggle,
                                   map_opts)
                    map_opts.desc = "Toggle Repl (for file)"
                    vim.keymap.set('n', '<LocalLeader>rf', function()
                        ht.repl.toggle(vim.api.nvim_buf_get_name(0))
                    end, map_opts)
                    map_opts.desc = "Quit Repl"
                    vim.keymap.set('n', '<LocalLeader>rq', ht.repl.quit,
                                   map_opts)
                    map_opts.desc = 'Hoogle Signature'
                    vim.keymap.set('n', '<LocalLeader>h', ht.hoogle.hoogle_signature,
                                   map_opts)
                    ht.dap.discover_configurations(ev.buf)
                    require('telescope').load_extension('ht')
                end
            })
        end
    }
}
