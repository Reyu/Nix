vim.cmd('packadd noice.nvim')
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
            {
                require('noice').api.status.message.get,
                cond = require('noice').api.status.message.has,
                color = { fg = "#ff9e64" },
            },
        },

        lualine_x = {
            {
                require('noice').api.status.command.get,
                cond = require('noice').api.status.command.has,
                color = { fg = "#ff9e64" },
            },
            {
                require('noice').api.status.search.get,
                cond = require('noice').api.status.search.has,
                color = { fg = "#ff9e64" },
            },
        },
        lualine_y = {
            {
                require('noice').api.status.ruler.get,
                cond = require('noice').api.status.ruler.has,
            },
            'progress',
            'filesize'
        },
        lualine_z = {
            'location',
        },
    },
    tabline = {
        lualine_a = { { 'tabs', mode = 2 } },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { { 'buffers', mode = 4 } }
    },
    winbar = {
        lualine_a = {
            { 'filetype', icon_only = true },
            { 'filename', path = 1 },
        },
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
        lualine_c = {
            { 'filetype', icon_only = true },
            { 'filename', path = 0 },
        },
        lualine_x = { "searchcount", 'diagnostics' },
        lualine_y = {},
        lualine_z = {},
    },
    extensions = {
        "man",
        "quickfix",
    },
})
