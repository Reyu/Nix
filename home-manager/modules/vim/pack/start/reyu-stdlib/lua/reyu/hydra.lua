local Hydra = require("hydra")

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
            },
        },
    },
    mode = { "n", "x" },
    body = "<Leader>o",
    heads = {
        { 'c', toggleOpt('cursorline') },
        { 'i', toggleOpt('list') },
        { 'n', toggleOpt('number') },
        { 'r', toggleOpt('relativenumber') },
        { 's', toggleOpt('spell') },
        { 'v', toggleOpt('virtualedit', "all", "") },
        { 'w', toggleOpt('wrap') },
        { 'q', nil, { exit = true } },
        { '<Esc>', nil, { exit = true } },
    },
})
