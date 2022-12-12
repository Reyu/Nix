local smart_splits = require('smart-splits')

smart_splits.setup({
    ignored_filetypes = {
        'nofile',
        'quickfix',
        'prompt',
    },
    ignored_buftypes = { },
    default_amount = 3,
    wrap_at_edge = false,
    tmux_integration = true,
})

vim.keymap.set('n', '<S-A-h>', require('smart-splits').resize_left)
vim.keymap.set('n', '<S-A-j>', require('smart-splits').resize_down)
vim.keymap.set('n', '<S-A-k>', require('smart-splits').resize_up)
vim.keymap.set('n', '<S-A-l>', require('smart-splits').resize_right)

-- moving between splits
vim.keymap.set('n', '<M-h>', require('smart-splits').move_cursor_left)
vim.keymap.set('n', '<M-j>', require('smart-splits').move_cursor_down)
vim.keymap.set('n', '<M-k>', require('smart-splits').move_cursor_up)
vim.keymap.set('n', '<M-l>', require('smart-splits').move_cursor_right)
