return {
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
