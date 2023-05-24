return {
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        opts = {
            current_line_blame = true,
            on_attach = function(bufnr)
                local gs = require('gitsigns')

                local function map(mode, l, r, opts)
                    local _opts = {
                        silent = true,
                        noremap = true,
                        buffer = bufnr
                    }
                    vim.tbl_extend("force", _opts, opts or {})
                    vim.keymap.set(mode, l, r, _opts)
                end

                -- Navigation
                map('n', ']c', function()
                    if vim.wo.diff then return ']c' end
                    vim.schedule(function() gs.next_hunk() end)
                    return '<Ignore>'
                end, {expr = true})

                map('n', '[c', function()
                    if vim.wo.diff then return '[c' end
                    vim.schedule(function() gs.prev_hunk() end)
                    return '<Ignore>'
                end, {expr = true})

                -- Actions
                map('n', '<LocalLeader>ghs', gs.stage_hunk,
                    {desc = 'Stage Hunk'})
                map('n', '<LocalLeader>ghr', gs.reset_hunk,
                    {desc = 'Reset Hunk'})
                map('v', '<LocalLeader>ghs', function()
                    gs.stage_hunk({vim.fn.line("."), vim.fn.line("v")})
                end, {desc = 'Stage Hunk'})
                map('v', '<LocalLeader>ghr', function()
                    gs.reset_hunk({vim.fn.line("."), vim.fn.line("v")})
                end, {desc = 'Reset Hunk'})
                map('n', '<LocalLeader>ghS', gs.stage_buffer,
                    {desc = 'Stage Buffer'})
                map('n', '<LocalLeader>ghu', gs.undo_stage_hunk,
                    {desc = 'Unde Stage Hunk'})
                map('n', '<LocalLeader>ghR', gs.reset_buffer,
                    {desc = 'Reset Buffer'})
                map('n', '<LocalLeader>ghp', gs.preview_hunk,
                    {desc = 'Preview Hunk'})
                map('n', '<LocalLeader>ghb',
                    function() gs.blame_line {full = true} end,
                    {desc = 'Blame Line'})
                map('n', '<LocalLeader>gtb', gs.toggle_current_line_blame,
                    {desc = 'Toggle Blame Current Line'})
                map('n', '<LocalLeader>ghd', gs.diffthis, {desc = 'Diff This'})
                map('n', '<LocalLeader>ghD', function()
                    gs.diffthis('~')
                end, {desc = 'Diff This (~)'})
                map('n', '<LocalLeader>gtd', gs.toggle_deleted,
                    {desc = 'Toggle Deleted'})

                -- Text object
                map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
            end
        }
    }, {
        "tpope/vim-fugitive",
        cond = vim.fn.exists('g:started_by_firenvim') == 0,
        cmd = {
            "G", "Git", "Ggrep", "Glgrep", "Gclog", "Gllog", "Gcd", "Glcd",
            "Gedit", "Gsplit", "Gvsplit", "Gtabedit", "Gpedit", "Gdrop",
            "Gread", "Gwrite", "Gw", "Gwq", "Gdiffsplit", "Gvdiffsplit",
            "Ghdiffsplit", "GMove", "GRename", "GDelete", "GRemote", "GUnlink",
            "GBrowse"
        },
        init = function()
            require("which-key").register({["<Leader>g"] = {name = "Git"}})
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
