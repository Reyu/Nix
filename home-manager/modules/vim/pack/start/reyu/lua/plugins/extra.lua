return {
    {
        "phaazon/mind.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        cond = vim.fn.exists('g:started_by_firenvim') == 0,
        opts = {
            edit = {
                data_extension = '.rst',
                copy_link_format = '`<%s>`_'
            }
        },
        keys = {
            { '<Leader>mo',      function() require('mind').open_main() end,          silent = true, noremap = true, desc = "Open Mind"},
            { '<Leader>mc',      function() require('mind').close() end,              silent = true, noremap = true, desc = "Close Mind"},
            { '<Leader>mr',      function() require('mind').reload_state() end,       silent = true, noremap = true, desc = "Reload Mind State"},
            { '<LocalLeader>mo', function() require('mind').open_smart_project() end, silent = true, noremap = true, desc = "Open Mind"},
        },
    },
    {
        "glacambre/firenvim",
        build = function() vim.fn['firenvim#install'](0) end,
        keys = {
            { "<Esc><Esc>", vim.fn['firenvim#focus_page'] },
        },
        init = function()
            vim.g.firenvim_config = {
                globalSettings = {
                    alt = 'all',
                },
                localSettings = {
                    ['.*'] = {
                        cmdline = 'neovim',
                        content = 'text',
                        priority = 0,
                        selector = 'textarea:not([readonly]), div[role="textbox"]',
                        takeover = 'empty',
                    },
                }
            }

            if vim.fn.exists('g:started_by_firenvim') == 1 then
                vim.g.firenvim_timer_started = false
                vim.api.nvim_create_autocmd({"TextChanged"}, {
                    pattern = { "*" },
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
                    end,
                })
            end
        end,
    }
}
