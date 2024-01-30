return {
    {"direnv/direnv.vim", lazy = false},
    {
        -- FlowState Reading
        "nullchilly/fsread.nvim",
        cmd = {
            "FSRead",
            "FSClear",
            "FSToggle"
        }
    }, {
        "nvim-neorg/neorg",
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter",
                opts = {ensure_installed = {'norg'}}
            }
        },
        build = ":Neorg sync-parsers",
        cmd = {"Neorg"},
        ft = "norg",
        opts = {
            load = {
                ["core.defaults"] = {},
                ["core.promo"] = {},
                ["core.dirman"] = {
                    config = {workspaces = {home = "~/Notes"}},
                    index = "main.norg"
                },
                ["core.concealer"] = {},
                ["core.qol.todo_items"] = {},
                ["core.integrations.zen_mode"] = {}
            }
        }
    }, {
        "glacambre/firenvim",
        cond = not not vim.g.started_by_firenvim,
        lazy = false;
        build = function() vim.fn['firenvim#install'](0) end,
        keys = {{"<Esc><Esc>", vim.fn['firenvim#focus_page']}},
        init = function()
            vim.g.firenvim_config = {
                globalSettings = {alt = 'all'},
                localSettings = {
                    ['.*'] = {
                        cmdline = 'neovim',
                        content = 'text',
                        priority = 0,
                        selector = 'textarea:not([readonly]), div[role="textbox"]',
                        takeover = 'empty'
                    }
                }
            }

            if vim.fn.exists('g:started_by_firenvim') == 1 then
                vim.g.firenvim_timer_started = false
                vim.api.nvim_create_autocmd({"TextChanged"}, {
                    pattern = {"*"},
                    nested = true,
                    callback = function()
                        if vim.g.firenvim_timer_started then
                            return
                        else
                            vim.g.firenvim_timer_started = true
                            vim.fn.timer_start(1000, function()
                                vim.g.firenvim_timer_started = false
                                vim.cmd('write')
                            end)
                        end
                    end
                })
            end
        end
    }, {
        "kndndrj/nvim-dbee",
        cond = not vim.g.started_by_firenvim,
        dependencies = {"MunifTanjim/nui.nvim"},
        main = "dbee",
        build = function() require("dbee").install() end,
        config = true;
        keys = {
            {'<Leader>d', desc = '+DBee'},
            {
                "<Leader>do",
                function() require('dbee').open() end,
                desc = 'Open',
                silent = true,
                noremap = true
            }, {
                "<Leader>dc",
                function() require('dbee').close() end,
                desc = 'Close',
                silent = true,
                noremap = true
            }, {
                "<Leader>dn",
                function() require('dbee').next() end,
                desc = 'Next Page',
                silent = true,
                noremap = true
            }, {
                "<Leader>dp",
                function() require('dbee').prev() end,
                desc = 'Prev Page',
                silent = true,
                noremap = true
            }, {
                "<Leader>dq",
                function() require('dbee').execute(vim.input()) end,
                desc = 'Query',
                silent = true,
                noremap = true
            }
        }
    }, {
        "kndndrj/nvim-projector",
        cond = not vim.g.started_by_firenvim,
        dependencies = {
            'mfussenegger/nvim-dap', 'rcarriga/nvim-dap-ui',
            'nvim-tree/nvim-web-devicons', 'kndndrj/projector-vscode',
            "kndndrj/projector-neotest", "nvim-neotest/neotest",
            "kndndrj/projector-dbee",
        },
        config = true,
        opts = function ()
            return {
            core = {
                automatic_reload = true,
            },
            loaders = {
                require("projector.loaders").BuiltinLoader:new {
                    path = function()
                        return vim.fn.getcwd() .. "/.vim/projector.json"
                    end,
                },
                require("projector.loaders").DapLoader:new(),require("projector_vscode").LaunchJsonLoader:new(),
                require("projector_vscode").TasksJsonLoader:new(),
            },
            outputs = {
                require("projector.outputs").TaskOutputBuilder:new(),
                require("projector.outputs").DapOutputBuilder:new(),
                require("projector_dbee").OutputBuilder:new(),
            },
        }
        end,
        keys = {
            {
                "<Leader>p",
                function() require('projector').toggle() end,
                desc = 'Projector',
                noremap = true,
                silent = true
            },
            {
                "<Leader>c",
                function() require('projector').continue() end,
                desc = 'Debug: Continue',
                noremap = true,
                silent = true
            },
            {
                "<Leader>k",
                function() require('projector').kill() end,
                desc = 'Debug: Kill Session',
                noremap = true,
                silent = true
            },
            {
                "<Leader>N",
                function() require('projector').next() end,
                desc = 'Debug: Next',
                noremap = true,
                silent = true
            },
            {
                "<Leader>P",
                function() require('projector').previous() end,
                desc = 'Debug: Previous',
                noremap = true,
                silent = true
            },
            {
                "<Leader>R",
                function() require('projector').restart() end,
                desc = 'Debug: Restart',
                noremap = true,
                silent = true
            }
        }
    }
}
