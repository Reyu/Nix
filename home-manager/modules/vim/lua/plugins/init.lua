local util = require('reyu.util')
local toggleOpt = util.toggleOpt
local displayOpt = util.displayOpt

return {
    {
        "folke/which-key.nvim",
        cond = vim.fn.exists('g:started_by_firenvim') == 0,
        opts = {
            plugins = {spelling = {enabled = true}},
            window = {
                border = 'single',
                margin = {5, 10, 5, 10},
                padding = {1, 2, 1, 2}
            }
        }
    }, {
        "anuvyklack/hydra.nvim",
        cond = vim.fn.exists('g:started_by_firenvim') == 0,
        keys = {{"<Leader>o", mode = {"n", "x"}, desc = "Options Hydra"}},
        config = function()
            local Hydra = require("hydra")

            Hydra({
                name = 'Options',
                hint = [[
^ ^      Options
^
%{c} _c_ursor line
%{i} _i_nvisible characters
%{n} _n_umber
%{r} _r_elative number
%{s} _s_pell
%{v} _v_irtual edit
%{w} _w_rap
%{t} diagnostic virtual _t_ext
^
^ ^ _<Esc>_ or _q_ to quit
]],
                config = {
                    color = 'amaranth',
                    invoke_on_body = true,
                    hint = {
                        position = "middle",
                        border = "single",
                        funcs = {
                            c = displayOpt('cursorline'),
                            i = displayOpt('list'),
                            n = displayOpt('number'),
                            r = displayOpt('relativenumber'),
                            s = displayOpt('spell'),
                            v = displayOpt('virtualedit', "all"),
                            w = displayOpt('wrap'),
                            t = function()
                                if vim.diagnostic.config().virtual_text then
                                    return "🟢"
                                else
                                    return "🔴"
                                end
                            end
                        }
                    }
                },
                mode = {"n", "x"},
                body = "<Leader>o",
                heads = {
                    {'c', toggleOpt('cursorline')}, {'i', toggleOpt('list')},
                    {'n', toggleOpt('number')},
                    {'r', toggleOpt('relativenumber')},
                    {'s', toggleOpt('spell')},
                    {'v', toggleOpt('virtualedit', "all", "")},
                    {'w', toggleOpt('wrap')}, {
                        't', function()
                            if vim.diagnostic.config().virtual_text then
                                vim.diagnostic.config({virtual_text = false})
                            else
                                vim.diagnostic.config({virtual_text = true})
                            end
                        end
                    }, {'q', nil, {exit = true}}, {'<Esc>', nil, {exit = true}}
                }
            })
        end
    },
    {
        "dstein64/vim-startuptime",
        cmd = "StartupTime",
        config = function() vim.g.startuptime_tries = 10 end
    },
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = {
            options = {
                "buffers", "curdir", "tabpages", "winsize", "help", "globals"
            }
        },
        init = function()
            require("which-key").register({["<Leader>q"] = { name = "Sessions" }})
        end,
        keys = {
            {
                "<leader>qs",
                function() require("persistence").load() end,
                desc = "Restore Session"
            }, {
                "<leader>ql",
                function()
                    require("persistence").load({last = true})
                end,
                desc = "Restore Last Session"
            }, {
                "<leader>qd",
                function() require("persistence").stop() end,
                desc = "Don't Save Current Session"
            }
        }
    },
    {"tpope/vim-repeat", event = "VeryLazy"},
    {"norcalli/nvim-terminal.lua", config = true},
    {
        "andymass/vim-matchup",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            opts = function (opts)
                opts["matchup"] = {enable = true}
            end
        },
        event = "BufReadPost",
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
        end,
    },
}
