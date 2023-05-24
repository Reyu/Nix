return {
    {"direnv/direnv.vim", lazy = false},
    {
        "nullchilly/fsread.nvim",
        cmds = {
            "FSRead",
            "FSClear",
            "FSToggle"
        }
    }, {
        "phaazon/mind.nvim",
        enabled = false,
        dependencies = {"nvim-lua/plenary.nvim"},
        cond = vim.fn.exists('g:started_by_firenvim') == 0,
        cmd = {"MindOpenMain", "MindOpenProject", "MindOpenSmartProject"},
        opts = {
            edit = {
                data_header = '@document.meta\ntitle: %s\n@end',
                data_extension = '.norg',
                copy_link_format = '{:%s:}'
            }
        },
        init = function()
            require("which-key").register({["<Leader>m"] = {name = "Mind"}})
        end,
        keys = {
            {
                '<Leader>mo',
                function() require('mind').open_main() end,
                silent = true,
                noremap = true,
                desc = "Open Mind"
            }, {
                '<Leader>mc',
                function() require('mind').close() end,
                silent = true,
                noremap = true,
                desc = "Close Mind"
            }, {
                '<Leader>mr',
                function() require('mind').reload_state() end,
                silent = true,
                noremap = true,
                desc = "Reload Mind State"
            }, {
                '<LocalLeader>m',
                function() require('mind').open_smart_project() end,
                silent = true,
                noremap = true,
                desc = "Open Mind"
            }
        }
    }, {
        "nvim-neorg/neorg",
        enabled = false,
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
        enabled = false,
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
    }
}
