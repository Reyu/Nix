return {
    {
        "nvim-neotest/neotest",
        cond = not vim.g.started_by_firenvim,
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-treesitter/nvim-treesitter",
                opts = { ensure_installed = { 'haskell', 'python' }, },
            },
            "antoinemadec/FixCursorHold.nvim",
            "nvim-neotest/neotest-python",
            "mrcjkb/neotest-haskell"
        },
        opts = function (opts)
            vim.api.nvim_create_autocmd({"FileType"}, {
                pattern = {"neotest-summary"},
                callback = function(ev)
                    vim.b[ev.buf].wrap = false
                end,
                desc = "Set nowrap on Neotest Summary pane",
            })
            local opts_ = {
                adapters = {
                    require("neotest-python")({
                        python = require("reyu.util").pythonPath()
                    }),
                    require("neotest-haskell"),
                },
                quickfix = {
                    open = false;
                }
            }
            return vim.tbl_deep_extend("force", opts, opts_)
        end,
        keys = {
            {"<LocalLeader>t", desc = "+Tests"},
            {
                "[n",
                function()
                    require("neotest").jump.prev({status = "failed"})
                end,
                desc = "Previous failed test"
            }, {
                "]n",
                function()
                    require("neotest").jump.next({status = "failed"})
                end,
                desc = "Next failed test"
            }, {
                "<LocalLeader>ts",
                function() require('neotest').summary.toggle() end,
                desc = "NeoTest Summary"
            }, {
                "<LocalLeader>ta",
                function()
                    require('neotest').run.run({suite = true })
                end,
                desc = "Run full test suite"
            }, {
                "<LocalLeader>tf",
                function()
                    require('neotest').run.run(vim.fn.expand("%"))
                end,
                desc = "Run tests in current file"
            }, {
                "<LocalLeader>tn",
                function() require('neotest').run.run() end,
                desc = "Run nearest test"
            }, {
                "<LocalLeader>tt",
                function() require('neotest').run.run_last() end,
                desc = "Rerun the last test"
            }, {
                "<LocalLeader>td",
                function()
                    require('neotest').run.run_last({strategy = "dap"})
                end,
                desc = "Rerun the last test in debugger"
            }, {
                "<LocalLeader>to",
                function()
                    require('neotest').output.open()
                end,
                desc = "View output"
            }, {
                "<LocalLeader>tO",
                function()
                    require('neotest').output_panel.toggle()
                end,
                desc = "Toggle output pannel"
            }, {
                "<LocalLeader>tk",
                function() require('neotest').run.stop() end,
                desc = "Stop running tests"
            }
        }
    }, {
        "mfussenegger/nvim-dap",
        cond = not vim.g.started_by_firenvim,
        dependencies = {
            {
                "theHamsta/nvim-dap-virtual-text",
                opts = {highlight_new_as_changed = true, all_frames = true}
            }, {
                "hrsh7th/nvim-cmp",
                opts = function(_, _)
                    require("cmp").setup.filetype({
                        'dap-repl', 'dapui_watches', 'dapui_hover'
                    }, {sources = {{name = 'dap'}}})
                end
            }, {
                "nvim-treesitter/nvim-treesitter",
                opts = { ensure_installed = { 'dap_repl' }, },
                dependencies = {
                    "LiadOz/nvim-dap-repl-highlights",
                    config = true,
                },
            },
        },
        init = function ()
            if not vim.g.started_by_firenvim then
                require('which-key').register({['<LocalLeader>d'] = {desc = '+Debug'}})
            end
        end,
        keys = {
            {
                '<LocalLeader>db',
                function() require('dap').toggle_breakpoint() end,
                desc = 'Creates or removes a breakpoint'
            }, {
                '<LocalLeader>dB',
                function()
                    require('dap').set_breakpoint(vim.fn.input(
                                                      'Breakpoint condition: '))
                end,
                desc = 'Set breakpoint w/ condition'
            }, {
                '<LocalLeader>de',
                function()
                    require('dap').set_exception_breakpoints()
                end,
                desc = 'Sets breakpoints on exceptions'
            }, {
                '<LocalLeader>dl',
                function()
                    require('dap').set_breakpoint(nil, nil, vim.fn
                                                      .input(
                                                      'Log point message: '))
                end,
                desc = 'Set LogPoint'
            }, {
                '<LocalLeader>dc',
                function() require('dap').clear_breakpoints() end,
                desc = 'Clear all breakpoints'
            }, {
                '<LocalLeader>dr',
                function() require('dap').repl.open() end,
                desc = 'Open a REPL'
            }, {
                '<LocalLeader>dR',
                function() require('dap').run_last() end,
                desc = 'Re-runs the last debug-adapter/configuration'
            }
        },
        opts = {
            defaults = {
                fallback = {
                    external_terminal = {command = 'alacritty', args = {'-e'}}
                }
            },
            configurations = {
                lua = {
                    {
                        type = 'nlua',
                        request = 'attach',
                        name = "Attach to running Neovim instance",
                        host = function()
                            local value = vim.fn.input('Host [127.0.0.1]: ')
                            if value ~= "" then
                                return value
                            end
                            return '127.0.0.1'
                        end,
                        port = function()
                            local val = tonumber(vim.fn.input('Port: '))
                            assert(val, "Please provide a port number")
                            return val
                        end
                    }
                }
            }
        },
        config = function(_, opts)
            vim.fn.sign_define('DapBreakpoint', {
                text = '🔴',
                texthl = 'DiagnosticInfo',
                linehl = '',
                numhl = ''
            })
            vim.fn.sign_define('DapBreakpointCondition', {
                text = '🚦',
                texthl = 'DiagnosticInfo',
                linehl = '',
                numhl = ''
            })
            vim.fn.sign_define('DapBreakpointRejected', {
                text = '🚫',
                texthl = 'DiagnosticError',
                linehl = '',
                numhl = ''
            })
            vim.fn.sign_define('DapLogPoint', {
                text = '📓',
                texthl = 'DiagnosticInfo',
                linehl = '',
                numhl = ''
            })
            vim.fn.sign_define('DapStopped', {
                text = '🛑',
                texthl = 'DiagnosticError',
                linehl = 'DiagnosticUnderlineError',
                numhl = 'DiagnosticError'
            })

            local dap = require("dap")

            vim.tbl_extend("force", dap.defaults, opts.defaults)

            for index, value in ipairs(opts.adapters or {}) do
                dap.adapters[index] = value
            end
            for index, value in ipairs(opts.configurations or {}) do
                dap.configurations[index] = value
            end

            local Hydra = require("hydra")
            Hydra({
                hint = [[
             _n_: step over   _s_: Continue/Start
             _i_: step into   _b_: Breakpoint
             _o_: step out    _K_: Eval
             _c_: to cursor   _C_: Close UI
             _p_: pause       ^ ^
             _<Esc>_: exit    _q_: Quit
            ]],
                config = {
                    color = 'pink',
                    invoke_on_body = true,
                    hint = {position = 'bottom'}
                },
                name = 'dap',
                mode = {'n', 'x'},
                body = '<localleader>dh',
                heads = {
                    {
                        'n', function()
                            require("dap").step_over()
                        end, {silent = true}
                    },
                    {
                        'i', function()
                            require("dap").step_into()
                        end, {silent = true}
                    },
                    {
                        'o', function()
                            require("dap").step_out()
                        end, {silent = true}
                    },
                    {
                        'c', function()
                            require("dap").run_to_cursor()
                        end, {silent = true}
                    },
                    {
                        's', function()
                            require("dap").continue()
                        end, {silent = true}
                    },
                    {
                        'p', function()
                            require("dap").pause()
                        end, {silent = true}
                    },
                    {
                        'b', function()
                            require("dap").toggle_breakpoint()
                        end, {silent = true}
                    },
                    {
                        'K', function()
                            require("dap.ui.widgets").hover()
                        end, {silent = true}
                    }, {
                        'q', function()
                            require("dap").disconnect(
                                {terminateDebuggee = false})
                        end, {exit = true, silent = true}
                    }, {
                        'C', function()
                            require("dap").close()
                            require("dap").refresh()
                        end, {silent = true}
                    }, {'<Esc>', nil, {exit = true, nowait = true}}
                }
            })
        end
    }, {
        "mfussenegger/nvim-dap-python",
        cond = not vim.g.started_by_firenvim,
        dependencies = {"mfussenegger/nvim-dap"},
        ft = "python",
        config = function()
            local util = require('reyu.util')
            require('dap-python').setup(util.pythonPath())
        end
    }, {
        "rcarriga/nvim-dap-ui",
        cond = not vim.g.started_by_firenvim,
        dependencies = {"mfussenegger/nvim-dap"},
        opts = {
            layouts = {
                {
                    elements = {
                        "scopes",
                        "breakpoints",
                        "watches",
                    },
                    size = 60,
                    position = "left"
                },
                {
                    elements = {"repl", "console"},
                    size = 0.25,
                    position = "bottom"
                }
            },
            floating = {
                max_height = nil,
                max_width = nil,
                border = "single",
                mappings = {close = {"q", "<Esc>"}}
            },
            windows = {indent = 1},
            render = {max_type_length = nil, max_value_lines = 100}
        },
        keys = {
            {
                '<F2>',
                function() require('dapui').toggle() end,
                desc = 'Toggle debug UI'
            }, {
                '<LocalLeader>du',
                function() require('dapui').toggle() end,
                desc = 'Toggle debug UI'
            }
        }
    }
}

