local smart_splits = require('smart-splits')

smart_splits.setup({
    ignored_filetypes = {
        'nofile',
        'quickfix',
        'prompt',
    },
    ignored_buftypes = {},
    default_amount = 3,
    wrap_at_edge = false,
    tmux_integration = true,
})

vim.keymap.set('n', '<S-A-h>', smart_splits.resize_left)
vim.keymap.set('n', '<S-A-j>', smart_splits.resize_down)
vim.keymap.set('n', '<S-A-k>', smart_splits.resize_up)
vim.keymap.set('n', '<S-A-l>', smart_splits.resize_right)

-- moving between splits
local returnToNormal = function()
    -- The key combo "<C-\><C-N>" is used to return to normal
    -- mode, regardless of the current mode.
    local keys = vim.api.nvim_replace_termcodes('<C-\\><C-N>', true, true, true)
    vim.api.nvim_feedkeys(keys, 'n', true)
end
vim.keymap.set({ 'n', 'i', 't' }, '<M-h>', function() returnToNormal() smart_splits.move_cursor_left() end)
vim.keymap.set({ 'n', 'i', 't' }, '<M-j>', function() returnToNormal() smart_splits.move_cursor_down() end)
vim.keymap.set({ 'n', 'i', 't' }, '<M-k>', function() returnToNormal() smart_splits.move_cursor_up() end)
vim.keymap.set({ 'n', 'i', 't' }, '<M-l>', function() returnToNormal() smart_splits.move_cursor_right() end)

local Hydra = require('hydra')
local cmd = require('hydra.keymap-util').cmd
local pcmd = require('hydra.keymap-util').pcmd

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
        { 'ol', function() vim.cmd('BufferOrderByLanguage') end, { desc = 'by language' } },
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

Hydra({
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
    body = '<C-W>',
    heads = {
        { 'h', '<C-w>h' },
        { 'j', '<C-w>j' },
        { 'k', pcmd('wincmd k', 'E11', 'close') },
        { 'l', '<C-w>l' },

        { 'H', cmd 'WinShift left' },
        { 'J', cmd 'WinShift down' },
        { 'K', cmd 'WinShift up' },
        { 'L', cmd 'WinShift right' },

        { '<C-h>', function() smart_splits.resize_left(2) end },
        { '<C-j>', function() smart_splits.resize_down(2) end },
        { '<C-k>', function() smart_splits.resize_up(2) end },
        { '<C-l>', function() smart_splits.resize_right(2) end },
        { '=', '<C-w>=', { desc = 'equalize' } },

        { 's', pcmd('split', 'E36') },
        { '<C-s>', pcmd('split', 'E36'), { desc = false } },
        { 'v', pcmd('vsplit', 'E36') },
        { '<C-v>', pcmd('vsplit', 'E36'), { desc = false } },

        { 'w', '<C-w>w', { exit = true, desc = false } },
        { '<C-w>', '<C-w>w', { exit = true, desc = false } },

        { 'z', cmd 'WindowsMaximaze', { exit = true, desc = 'maximize' } },
        { '<C-z>', cmd 'WindowsMaximaze', { exit = true, desc = false } },

        { 'o', '<C-w>o', { exit = true, desc = 'remain only' } },
        { '<C-o>', '<C-w>o', { exit = true, desc = false } },

        { 'b', choose_buffer, { exit = true, desc = 'choose buffer' } },

        { 'c', pcmd('close', 'E444') },
        { 'q', pcmd('close', 'E444'), { desc = 'close window' } },
        { '<C-c>', pcmd('close', 'E444'), { desc = false } },
        { '<C-q>', pcmd('close', 'E444'), { desc = false } },

        { '<Esc>', nil, { exit = true, desc = false } }
    }
})