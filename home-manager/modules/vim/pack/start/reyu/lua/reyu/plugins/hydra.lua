local Hydra = require("hydra")
local cmd = require('hydra.keymap-util').cmd
local pcmd = require('hydra.keymap-util').pcmd


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
        hint = {
            position = 'bottom',
            border = 'rounded'
        },
    },
    name = 'dap',
    mode = {'n','x'},
    body = '<leader>dh',
    heads = {
        { 'n', dap.step_over, { silent = true } },
        { 'i', dap.step_into, { silent = true } },
        { 'o', dap.step_out, { silent = true } },
        { 'c', dap.run_to_cursor, { silent = true } },
        { 's', dap.continue, { silent = true } },
        { 'p', dap.pause, { silent = true } },
        { 'q', ":lua require'dap'.disconnect({ terminateDebuggee = false })<CR>", {exit=true, silent = true } },
        { 'C', ":lua require('dapui').close()<cr>:DapVirtualTextForceRefresh<CR>", { silent = true } },
        { 'b', dap.toggle_breakpoint, { silent = true } },
        { 'K', ":lua require('dap.ui.widgets').hover()<CR>", { silent = true } },
        { '<Esc>', nil, { exit = true, nowait = true } },
    }
})


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

local options_hydra = Hydra({
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
        { 't', function()
            if vim.diagnostic.config().virtual_text then
                vim.diagnostic.config({ virtual_text = false })
            else
                vim.diagnostic.config({ virtual_text = true })
            end
        end},
        { 'q', nil, { exit = true } },
        { '<Esc>', nil, { exit = true } },
    },
})

local splits = require('smart-splits')
local buffer_hydra = Hydra({
    name = 'Barbar',
    config = {
        on_key = function()
            -- Preserve animation
            vim.wait(200, function() vim.cmd 'redraw' end, 30, false)
        end
    },
    heads = {
        { 'h', function() vim.cmd('BufferPrevious') end, { on_key = false } },
        { 'l', function() vim.cmd('BufferNext') end, { desc = 'choose', on_key = false } },

        { 'H', function() vim.cmd('BufferMovePrevious') end },
        { 'L', function() vim.cmd('BufferMoveNext') end, { desc = 'move' } },

        { 'p', function() vim.cmd('BufferPin') end, { desc = 'pin' } },

        { 'd', function() vim.cmd('BufferClose') end, { desc = 'close' } },
        { 'c', function() vim.cmd('BufferClose') end, { desc = false } },
        { 'q', function() vim.cmd('BufferClose') end, { desc = false } },

        { 'od', function() vim.cmd('BufferOrderByDirectory') end, { desc = 'by directory' } },
        { 'ol', function() vim.cmd('BufferOrderByLanguage') end,  { desc = 'by language' } },
        { '<Esc>', nil, { exit = true } }
    }
})

local function choose_buffer()
    if #vim.fn.getbufinfo({ buflisted = true }) > 1 then
        buffer_hydra:activate()
    end
end

vim.keymap.set('n', 'gb', choose_buffer)

local window_hint = [[
^^^^^^^^^^^^     Move      ^^    Size   ^^   ^^     Split
^^^^^^^^^^^^-------------  ^^-----------^^   ^^---------------
^ ^ _k_ ^ ^  ^ ^ _K_ ^ ^   ^   _<C-k>_   ^   _s_: horizontally
_h_ ^ ^ _l_  _H_ ^ ^ _L_   _<C-h>_ _<C-l>_   _v_: vertically
^ ^ _j_ ^ ^  ^ ^ _J_ ^ ^   ^   _<C-j>_   ^   _q_, _c_: close
focus^^^^^^  window^^^^^^  ^_=_: equalize^   _z_: maximize
^ ^ ^ ^ ^ ^  ^ ^ ^ ^ ^ ^   ^^ ^          ^   _o_: remain only
_b_: choose buffer
]]

local window_hydra = Hydra({
    name = 'Windows',
    hint = window_hint,
    config = {
        invoke_on_body = true,
        hint = {
            border = 'rounded',
            offset = -1
        }
    },
    mode = 'n',
    body = '<C-w>',
    heads = {
        { 'h', '<C-w>h' },
        { 'j', '<C-w>j' },
        { 'k', pcmd('wincmd k', 'E11', 'close') },
        { 'l', '<C-w>l' },

        { 'H', cmd 'WinShift left' },
        { 'J', cmd 'WinShift down' },
        { 'K', cmd 'WinShift up' },
        { 'L', cmd 'WinShift right' },

        { '<C-h>', function() splits.resize_left(2)  end },
        { '<C-j>', function() splits.resize_down(2)  end },
        { '<C-k>', function() splits.resize_up(2)    end },
        { '<C-l>', function() splits.resize_right(2) end },
        { '=', '<C-w>=', { desc = 'equalize'} },

        { 's',     pcmd('split', 'E36') },
        { '<C-s>', pcmd('split', 'E36'), { desc = false } },
        { 'v',     pcmd('vsplit', 'E36') },
        { '<C-v>', pcmd('vsplit', 'E36'), { desc = false } },

        { 'w',     '<C-w>w', { exit = true, desc = false } },
        { '<C-w>', '<C-w>w', { exit = true, desc = false } },

        { 'z',     cmd 'WindowsMaximaze', { exit = true, desc = 'maximize' } },
        { '<C-z>', cmd 'WindowsMaximaze', { exit = true, desc = false } },

        { 'o',     '<C-w>o', { exit = true, desc = 'remain only' } },
        { '<C-o>', '<C-w>o', { exit = true, desc = false } },

        { 'b', choose_buffer, { exit = true, desc = 'choose buffer' } },

        { 'c',     pcmd('close', 'E444') },
        { 'q',     pcmd('close', 'E444'), { desc = 'close window' } },
        { '<C-c>', pcmd('close', 'E444'), { desc = false } },
        { '<C-q>', pcmd('close', 'E444'), { desc = false } },

        { '<Esc>', nil,  { exit = true, desc = false }}
    }
})
vim.keymap.set('n', '<C-w>', function() window_hydra:activate() end,
    { silent = true, noremap = true })

Hydra.spawn = function(head)
    if head == 'dap' then
        dap_hydra:activate()
    elseif head == 'options' then
        options_hydra:activate()
    elseif head == 'window' then
        window_hydra:activate()
    elseif head == 'buffer' then
        buffer_hydra:activate()
    end
end
