return {
    {
        "lewis6991/gitsigns.nvim",
        enabled = false,
        config = true,
        event = "VeryLazy",
    },
    {
        "tpope/vim-fugitive",
        cond = vim.fn.exists('g:started_by_firenvim') == 0,
        cmd = {
            "G",
            "Git",
            "Ggrep",
            "Glgrep",
            "Gclog",
            "Gllog",
            "Gcd",
            "Glcd",
            "Gedit",
            "Gsplit",
            "Gvsplit",
            "Gtabedit",
            "Gpedit",
            "Gdrop",
            "Gread",
            "Gwrite",
            "Gw",
            "Gwq",
            "Gdiffsplit",
            "Gvdiffsplit",
            "Ghdiffsplit",
            "GMove",
            "GRename",
            "GDelete",
            "GRemote",
            "GUnlink",
            "GBrowse",
        },
        init = function()
            require("which-key").register({["<Leader>g"] = { name = "Git" }})
        end,
        keys = {
            {
                '<Leader>gs',
                '<Cmd>Git<CR>',
                silent = true,
                noremap = true,
                desc = 'Git Status'
            },
            {
                '<Leader>g<SPACE>',
                ':Git ',
                noremap = true,
                desc = 'Run Git command'
            }
        }
    }, {
        "TimUntersberger/neogit",
        dependencies = {'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim'},
        event = "VeryLazy",
        opts = {
            disable_commit_confirmation = true,
            integrations = {diffview = true}
        },
        cmd = {"Neogit"},
        keys = {
            {
                "<LocalLeader>gn",
                function() require('neogit').open() end,
                desc = "Open Neogit",
                silent = true,
                noremap = true
            }
        }
    }, {
        "pwntester/octo.nvim",
        cond = vim.fn.exists('g:started_by_firenvim') == 0,
        dependencies = {
            'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim',
            'nvim-tree/nvim-web-devicons'
        },
        cmd = "Octo",
        init = function()
            vim.api.nvim_set_hl(0, 'OctoEditable', {bg = "#073642"})
        end,
        config = function(_, opts)
            require('octo').setup()
            local which_key = require('which-key')
            which_key.register({
                i = {name = "Issue"},
                c = {name = "Coment"},
                a = {name = "Assignee"},
                g = {name = "GoTo"},
                l = {name = "Label"},
                p = {name = "PR"},
                r = {name = "Reaction"},
                s = {name = "Suggestion"},
                v = {name = "Reviewer"}
            }, {prefix = "<LocalLeader>"})
        end
    }
}
