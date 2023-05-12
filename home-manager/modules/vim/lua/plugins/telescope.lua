return {
    {
        "luc-tielen/telescope_hoogle",
        enabled = false,
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
        enabled = false,
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
