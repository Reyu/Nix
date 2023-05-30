return {
    {
        "luc-tielen/telescope_hoogle",
        cond = not vim.g.started_by_firenvim,
        dependencies = {
            {
                "nvim-telescope/telescope.nvim",
                opts = function(opts)
                    require('telescope').load_extension('hoogle')
                end,
            },
        },
    },
    {
        "MrcJkb/telescope-manix",
        cond = not vim.g.started_by_firenvim,
        dependencies = {
            {
                "nvim-telescope/telescope.nvim",
                opts = function(opts)
                    require('telescope').load_extension('manix')
                end,
            },
        },
    },
}
