return {
    {
        "lewis6991/gitsigns.nvim",
        cond = not vim.g.started_by_firenvim,
        event = "VeryLazy",
        opts = {
            current_line_blame = true,
        },
        keys = {
            {'ih', ':<C-U>Gitsigns select_hunk<CR>', mode = {'o','x'}, desc = 'Select Git Hunk'},
            {']h', function()
                if vim.wo.diff then return ']c' end
                vim.schedule(function() require('gitsigns').next_hunk() end)
                return '<Ignore>'
            end, desc = 'Next Git Hunk', expr = true},
            {'[h', function()
                if vim.wo.diff then return '[c' end
                vim.schedule(function() require('gitsigns').prev_hunk() end)
                return '<Ignore>'
            end, desc = 'Prev Git Hunk', expr = true},
            {'<Leader>g', desc = "+Git"},
            {'<Leader>gb', function() require('gitsigns').blame_line({full=true}) end, desc = 'Blame'},
            {'<Leader>gt', desc = "+Git"},
            {'<Leader>gtb', function() require('gitsigns').toggle_current_line_blame() end, desc = 'Toggle Blame Line'},
            {'<Leader>gtd', function() require('gitsigns').toggle_deleted() end, desc = 'Toggle Deleted'},
            {'<Leader>gtw', function() require('gitsigns').toggle_word_diff() end, desc = 'Toggle Word Diff'},
            {'<Leader>gh', desc = "+Hunk"},
            {'<Leader>ghs', function() require('gitsigns').stage_hunk() end, desc = 'Stage Hunk'},
            {'<Leader>ghs', function() require('gitsigns').stage_hunk({vim.fn.line('.'), vim.fn.line('v')}) end, mode = 'v', desc = 'Stage Hunk'},
            {'<Leader>ghr', function() require('gitsigns').reset_hunk() end, desc = 'Reset Hunk'},
            {'<Leader>ghr', function() require('gitsigns').reset_hunk({vim.fn.line('.'), vim.fn.line('v')}) end, mode = 'v', desc = 'Reset Hunk'},
            {'<Leader>ghS', function() require('gitsigns').stage_buffer() end, desc = 'Stage Buffer'},
            {'<Leader>ghu', function() require('gitsigns').undo_stage_hunk() end, desc = 'Undo Stage Hunk'},
            {'<Leader>ghR', function() require('gitsigns').reset_buffer() end, desc = 'Reset Buffer'},
            {'<Leader>ghp', function() require('gitsigns').preview_hunk() end, desc = 'Preview Hunk'},
            {'<Leader>ghb', function() require('gitsigns').blame_line() end, desc = 'Blame Line'},
            {'<Leader>ghd', function() require('gitsigns').diffthis() end, desc = 'Diff This'},
            {'<Leader>ghD', function() require('gitsigns').diffthis('~') end, desc = 'Diff This (~)'},
        },
    }, {
        "tpope/vim-fugitive",
        cond = not vim.g.started_by_firenvim,
        cmd = {
            "G", "Git", "Ggrep", "Glgrep", "Gclog", "Gllog", "Gcd", "Glcd",
            "Gedit", "Gsplit", "Gvsplit", "Gtabedit", "Gpedit", "Gdrop",
            "Gread", "Gwrite", "Gw", "Gwq", "Gdiffsplit", "Gvdiffsplit",
            "Ghdiffsplit", "GMove", "GRename", "GDelete", "GRemote", "GUnlink",
            "GBrowse"
        },
        keys = {
            {'<Leader>g', desc = '+Git'},
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
        "pwntester/octo.nvim",
        cond = not vim.g.started_by_firenvim,
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
            if not vim.g.started_by_firenvim then
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
        end
    }
}
