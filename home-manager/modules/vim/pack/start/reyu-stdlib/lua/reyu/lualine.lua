local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
        return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed
        }
    end
end

local function searchCount()
    local search = vim.fn.searchcount({maxcount = 0}) -- maxcount = 0 makes the number not be capped at 99
    local searchCurrent = search.current
    local searchTotal = search.total
    if searchCurrent > 0 and vim.v.hlsearch ~= 0 then
        return "/"..vim.fn.getreg("/").." ["..searchCurrent.."/"..searchTotal.."]"
    else
        return ""
    end
end

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'NeoSolarized',
        component_separators = {left = '', right = ''},
        section_separators = {left = '', right = ''},
        disabled_filetypes = {},
        always_divide_middle = true,
        globalstatus = true
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = {
            {'FugitiveHead', icon = ''},
            {'diff', source = diff_source},
            'diagnostics'
        },
        lualine_c = {
            {
                "filename",
                file_status = function()
                    -- Don't bother showing file status if we have Git info
                    if vim.fn["FugitiveGitDir"]() == "" then
                        return true
                    else
                        return false
                    end
                end,
            },
        },
        lualine_x = { { searchCount }, 'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    tabline = {
        lualine_a = {'filename'},
        lualine_b = {'aerial'},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {'buffers'},
        lualine_z = {{ 'tabs', { mode = 1 } }}
    },
    extensions = {'nvim-tree'}
}
