return {
    {
        "tpope/vim-fugitive",
        cond = vim.fn.exists('g:started_by_firenvim') == 0,
        cmd = {"Git"},
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
        "pwntester/octo.nvim",
        cond = vim.fn.exists('g:started_by_firenvim') == 0,
        dependencies = {
            'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim',
            'nvim-tree/nvim-web-devicons'
        },
        cmd = "Octo",
        init = function()
            vim.api.nvim_set_hl(0, 'OctoEditable', {bg = "#073642"})

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
