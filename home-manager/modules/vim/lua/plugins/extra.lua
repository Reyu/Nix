return {
    {"direnv/direnv.vim", lazy = false}, {
        'hkupty/iron.nvim',
        cond = not vim.g.started_by_firenvim,
        event = {"BufReadPre", "BufNewFile"},
        main = 'iron.core',
        opts = function()
            local view = require('iron.view')
            return {
                config = {
                    scratch_repl = true,
                    repl_definition = {
                        sh = {command = {"zsh"}},
                        haskell = {
                            command = function(meta)
                                local file =
                                    vim.api.nvim_buf_get_name(meta.current_bufnr)
                                return require('haskell-tools').repl
                                           .mk_repl_cmd(file)
                            end
                        }
                    },
                    repl_open_cmd = view.center("40%")
                },
                keymaps = {
                    send_motion = "<space>sc",
                    visual_send = "<space>sc",
                    send_file = "<space>sf",
                    send_line = "<space>sl",
                    send_mark = "<space>sm",
                    mark_motion = "<space>mc",
                    mark_visual = "<space>mc",
                    remove_mark = "<space>md",
                    cr = "<space>s<cr>",
                    interrupt = "<space>s<space>",
                    exit = "<space>sq",
                    clear = "<space>cl"
                },
                highlight = {italic = true},
                ignore_blank_lines = true
            }
        end
    }, {
        "phaazon/mind.nvim",
        cond = not vim.g.started_by_firenvim,
        dependencies = {"nvim-lua/plenary.nvim"},
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
        cond = not vim.g.started_by_firenvim,
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
        cond = vim.g.started_by_firenvim,
        build = function()
            require("lazy").load({plugins = "firenvim", wait = true})
            vim.fn["firenvim#install"](0)
        end,
        lazy = false,
        config = function()
            vim.g.firenvim_config = {
                globalSettings = {alt = 'all'},
                localSettings = {
                    ['.*'] = {
                        cmdline = 'firenvim',
                        content = 'text',
                        priority = 0,
                        selector = 'textarea:not([readonly]), div[role="textbox"]',
                        takeover = 'empty'
                    }
                }
            }
            vim.api.nvim_create_autocmd({'UIEnter'}, {
                callback = function(event)
                    local client = vim.api.nvim_get_chan_info(vim.v.event.chan)
                                       .client
                    if client ~= nil and client.name == "Firenvim" then
                        vim.keymap.set('n', '<Esc><Esc>',
                                       vim.fn['firenvim#focus_page'])
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
            })
        end
    }, {
        "kndndrj/nvim-dbee",
        cond = not vim.g.started_by_firenvim,
        dependencies = {"MunifTanjim/nui.nvim"},
        main = "dbee",
        build = function() require("dbee").install() end,
        init = function()
            require('which-key').register({['<Leader>d'] = "+DBee"}, {})
        end,
        config = true,
        keys = {
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
            'nvim-tree/nvim-web-devicons', 'kndndrj/projector-loader-vscode'
        },
        opts = {
            outputs = {
                task = {module = "builtin", options = nil},
                debug = {module = "dap", options = nil},
                database = {module = "dbee", options = nil}
            }
        },
        keys = {
            {
                "<Leader>s",
                function() require('projector').continue() end,
                desc = 'Continue',
                noremap = true,
                silent = true
            }
        }
    }
}
