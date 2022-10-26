local Hydra = require("hydra")

local dap = require('dap')
local dap_hydra = Hydra({
    hint = [[
 _n_: step over   _s_: Continue/Start
 _i_: step into   _b_: Breakpoint
 _o_: step out    _K_: Eval
 _c_: to cursor   _C_: Close UI
 _p_: pause       ^ ^
 _<Esc>_: exit    _q_: Quit
]],
    config = {
        color = 'pink',
        invoke_on_body = true,
        hint = {position = 'bottom', border = 'rounded'}
    },
    name = 'dap',
    mode = {'n', 'x'},
    body = '<leader>dh',
    heads = {
        {'n', dap.step_over, {silent = true}},
        {'i', dap.step_into, {silent = true}},
        {'o', dap.step_out, {silent = true}},
        {'c', dap.run_to_cursor, {silent = true}},
        {'s', dap.continue, {silent = true}}, {'p', dap.pause, {silent = true}},
        {
            'q',
            ":lua require'dap'.disconnect({ terminateDebuggee = false })<CR>",
            {exit = true, silent = true}
        }, {
            'C',
            ":lua require('dapui').close()<cr>:DapVirtualTextForceRefresh<CR>",
            {silent = true}
        }, {'b', dap.toggle_breakpoint, {silent = true}},
        {'K', ":lua require('dap.ui.widgets').hover()<CR>", {silent = true}},
        {'<Esc>', nil, {exit = true, nowait = true}}
    }
})

Hydra.spawn = function(head) if head == 'dap' then dap_hydra:activate() end end

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
        {'n', toggleOpt('number')}, {'r', toggleOpt('relativenumber')},
        {'s', toggleOpt('spell')}, {'v', toggleOpt('virtualedit', "all", "")},
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
