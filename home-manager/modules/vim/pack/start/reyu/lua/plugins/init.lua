-- Helper functions for Hydra
local toggleOpt = function(opt, trueVal, falseVal)
    local _trueVal = trueVal or true
    local _falseVal = falseVal or false
    return function()
        if vim.o[opt] == _trueVal then
            vim.o[opt] = _falseVal
        else
            vim.o[opt] = _trueVal
        end
    end
end

local displayOpt = function(opt, trueVal)
    local _trueVal = trueVal or true
    return function()
        if vim.o[opt] == _trueVal then
            return "[x]"
        else
            return "[ ]"
        end
    end
end

return {
    {
        "Tsuzat/NeoSolarized.nvim",
        priority = 1000,
        lazy = false,
        init = function()
            vim.o.termguicolors = true
            vim.cmd([[colorscheme NeoSolarized]])
        end,
        opts = {
            style = 'dark',
            transparent = true,
            terminal_colors = true,
            enable_italics = true,
            styles = {
                comments = {italic = true},
                keywords = {italic = true},
                functions = {bold = true},
                variables = {},
                string = {italic = true},
                underline = true,
                undercurl = true
            }
        }
    }, {
        "folke/twilight.nvim",
        cond = vim.fn.exists('g:started_by_firenvim') == 0,
        cmd = {"Twilight", "TwilightEnable"},
        opts = {dimming = {inactive = true}, context = 6}
    }, {
        "folke/zen-mode.nvim",
        lazy = true,
        opts = {
            window = {
                backdrop = 1,
                width = 120,
                height = 1,
                options = {
                    number = false,
                    relativenumber = true,
                    cursorline = false,
                    cursorcolumn = false
                }
            }
        }
    }, {
        "folke/which-key.nvim",
        cond = vim.fn.exists('g:started_by_firenvim') == 0,
        opts = {
            plugins = {spelling = {enabled = true}},
            window = {
                border = 'single',
                margin = {5, 10, 5, 10},
                padding = {1, 2, 1, 2}
            }
        }
    }, {
        "anuvyklack/hydra.nvim",
        cond = vim.fn.exists('g:started_by_firenvim') == 0,
        keys = {{"<Leader>o", mode = {"n", "x"}, desc = "Options Hydra"}},
        config = function()
            local Hydra = require("hydra")

            Hydra({
                name = 'Options',
                hint = [[
^ ^      Options
^
_c_ %{c} cursor line
_i_ %{i} invisible characters
_n_ %{n} number
_r_ %{r} relative number
_s_ %{s} spell
_v_ %{v} virtual edit
_w_ %{w} wrap
_t_ %{t} diagnostic virtual text
^
^ ^ _<Esc>_ or _q_ to quit
]],
                config = {
                    color = 'amaranth',
                    invoke_on_body = true,
                    hint = {
                        position = "middle",
                        border = "single",
                        funcs = {
                            c = displayOpt('cursorline'),
                            i = displayOpt('list'),
                            n = displayOpt('number'),
                            r = displayOpt('relativenumber'),
                            s = displayOpt('spell'),
                            v = displayOpt('virtualedit', "all"),
                            w = displayOpt('wrap'),
                            t = function()
                                if vim.diagnostic.config().virtual_text then
                                    return "[x]"
                                else
                                    return "[ ]"
                                end
                            end
                        }
                    }
                },
                mode = {"n", "x"},
                body = "<Leader>o",
                heads = {
                    {'c', toggleOpt('cursorline')}, {'i', toggleOpt('list')},
                    {'n', toggleOpt('number')},
                    {'r', toggleOpt('relativenumber')},
                    {'s', toggleOpt('spell')},
                    {'v', toggleOpt('virtualedit', "all", "")},
                    {'w', toggleOpt('wrap')}, {
                        't', function()
                            if vim.diagnostic.config().virtual_text then
                                vim.diagnostic.config({virtual_text = false})
                            else
                                vim.diagnostic.config({virtual_text = true})
                            end
                        end
                    }, {'q', nil, {exit = true}}, {'<Esc>', nil, {exit = true}}
                }
            })
        end
    }
}

-- which_key.register({ ['<Leader>n'] = { name = 'Notifications' } })
-- which_key.register({ ['<Leader>m'] = { name = 'Minimap' } })
-- which_key.register({ ['<Leader>s'] = { name = 'Sessions' } })
-- which_key.register({ ['<Leader>t'] = { name = 'NeoTree' } })
-- which_key.register({ ['<Leader>f'] = { name = 'Find' } })

-- which_key.register({ ['<LocalLeader>t'] = { name = 'Project Tests' } })
-- which_key.register({ ['<LocalLeader>x'] = { name = 'Trouble' } })
-- which_key.register({ ['<LocalLeader>g'] = { name = 'Goto' } })
-- which_key.register({ ['<LocalLeader>r'] = { name = 'Refactor' } }, { mode = "n" })
-- which_key.register({ ['<LocalLeader>r'] = { name = 'Refactor' } }, { mode = "v" })

