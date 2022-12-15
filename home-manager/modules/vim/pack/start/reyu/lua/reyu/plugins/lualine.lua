local noice = require('noice')

require("lualine").setup({
    options = {
        icons_enabled = true,
        theme = "NeoSolarized",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {},
        always_divide_middle = true,
        globalstatus = true,
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = {},
        lualine_c = {
            { 'FugitiveHead', icon = "" },
        },

        lualine_x = {
            {
                noice.api.status.command.get,
                cond = noice.api.status.command.has,
                color = { fg = "#ff9e64" },
            },
            {
                noice.api.status.mode.get,
                cond = noice.api.status.mode.has,
                color = { fg = "#ff9e64" },
            },
            {
                noice.api.status.search.get,
                cond = noice.api.status.search.has,
                color = { fg = "#ff9e64" },
            },
        },
        lualine_y = { 'progress', 'filesize' },
        lualine_z = { 'location' },
    },
    tabline = {
        lualine_a = { 'buffers' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { { 'tabs', { mode = 1 } } }
    },
    winbar = {
        lualine_a = { 'filename' },
        lualine_b = { 'aerial' },
        lualine_c = {
            { "FugitiveHead", icon = "" },
            { "diff" },
        },
        lualine_x = {
            'encoding',
            'fileformat',
            'filetype',
        },
        lualine_y = { "searchcount" },
        lualine_z = {
            "diagnostics",
        },
    },
    inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { "searchcount", 'diagnostics' },
        lualine_y = {},
        lualine_z = {},
    },
    extensions = {
        "man",
        "quickfix",
    },
})
