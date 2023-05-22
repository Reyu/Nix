return {
    {
        "mrcjkb/haskell-tools.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim"
        },
        ft = "haskell",
        opts = {
            tools = {
                hover = {stylize_markdown = true},
                definition = {hoogle_signature_fallback = true}
            },
            hls = {
                on_attach = require('plugins.lsp.keymaps').on_attach,
                filetypes = {"haskell"}
            }
        },
        config = function(plug, opts)
            local ht = require("haskell-tools")
            ht.setup(opts)
            local def_opts = {noremap = true, silent = true}
            vim.api.nvim_create_autocmd({'BufEnter', 'BufRead'}, {
                pattern = {"*.hs", "*.hls"},
                desc = "Haskell-Tools keymaps",
                callback = function(ev)
                    local opts = vim.tbl_extend('keep', def_opts,
                                                {buffer = ev.buf})
                    require('which-key').register({
                        ["<LocalLeader>r"] = {name = "Repl"}
                    })
                    opts.desc = "Toggle Repl (for package)"
                    vim.keymap.set('n', '<LocalLeader>rr', ht.repl.toggle, opts)
                    opts.desc = "Toggle Repl (for file)"
                    vim.keymap.set('n', '<LocalLeader>rf', function()
                        ht.repl.toggle(vim.api.nvim_buf_get_name(0))
                    end, opts)
                    opts.desc = "Quit Repl"
                    vim.keymap.set('n', '<LocalLeader>rq', ht.repl.quit, opts)
                    ht.dap.discover_configurations(ev.buf)
                end
            })
        end
    }, {
        "neovim/nvim-lspconfig",
        event = {"BufReadPre", "BufNewFile"},
        dependencies = {
            {
                "folke/neoconf.nvim",
                cmd = "Neoconf",
                opts = {plugins = {jsonls = {configured_servers_only = false}}}
            },
            {"folke/neodev.nvim", opts = {experimental = {pathStrict = true}}},
            {"mason.nvim"}, {"williamboman/mason-lspconfig.nvim"},
            "b0o/SchemaStore.nvim"
        },
        opts = {
            diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = {spacing = 4, prefix = "●"},
                severity_sort = true
            },
            autoformat = true,
            defaults = {on_attach = require('plugins.lsp.util').on_attach},
            servers = {
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
                            completion = {callSnippet = "Replace"}
                        }
                    }
                },
                bashls = {},
                dockerls = {},
                html = {},
                pyright = {},
                vimls = {},
                yamlls = {settings = {yaml = {keyOrdering = false}}}
            },
            setup = {}
        },
        config = function(_, opts)
            vim.diagnostic.config(opts.diagnostics)

            require("lspconfig").util.default_config =
                vim.tbl_extend("force",
                               require("lspconfig").util.default_config,
                               opts.defaults or {})

            local servers = opts.servers
            local capabilities = require("cmp_nvim_lsp").default_capabilities(
                                     vim.lsp.protocol.make_client_capabilities())

            local function setup(server)
                local server_opts = vim.tbl_deep_extend("force", {
                    capabilities = vim.deepcopy(capabilities)
                }, servers[server] or {})

                if opts.setup[server] then
                    if opts.setup[server](server, server_opts) then
                        return
                    end
                elseif opts.setup["*"] then
                    if opts.setup["*"](server, server_opts) then
                        return
                    end
                end
                require("lspconfig")[server].setup(server_opts)
            end

            local mlsp = require("mason-lspconfig")
            local available = mlsp.get_available_servers()

            local ensure_installed = {} ---@type string[]
            for server, server_opts in pairs(servers) do
                if server_opts then
                    server_opts = server_opts == true and {} or server_opts
                    -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
                    if server_opts.mason == false or
                        not vim.tbl_contains(available, server) then
                        setup(server)
                    else
                        ensure_installed[#ensure_installed + 1] = server
                    end
                end
            end

            require("mason-lspconfig").setup({
                ensure_installed = ensure_installed
            })
            require("mason-lspconfig").setup_handlers({setup})
        end
    }, {
        "jose-elias-alvarez/null-ls.nvim",
        event = {"BufReadPre", "BufNewFile"},
        dependencies = {"mason.nvim"},
        opts = function()
            local nls = require("null-ls")
            return {
                sources = {
                    nls.builtins.code_actions.gitsigns,
                    nls.builtins.code_actions.refactoring,
                    nls.builtins.diagnostics.commitlint,
                    nls.builtins.diagnostics.dotenv_linter,
                    nls.builtins.hover.dictionary
                }
            }
        end
    }, {
        "williamboman/mason.nvim",
        dependencies = {
            {
                "jayp0521/mason-null-ls.nvim",
                dependencies = {"jose-elias-alvarez/null-ls.nvim"}
            },
            {
                "jayp0521/mason-nvim-dap.nvim",
                dependencies = {"mfussenegger/nvim-dap"}
            }
        },
        cmd = "Mason",
        opts = {ensure_installed = {"shfmt"}},
        config = function(_, opts)
            require("mason").setup(opts)
            local mr = require("mason-registry")
            for _, tool in ipairs(opts.ensure_installed) do
                local p = mr.get_package(tool)
                if not p:is_installed() then p:install() end
            end
        end
    }
}
