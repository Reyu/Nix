local smart_splits = require('smart-splits')

smart_splits.setup({
    ignored_filetypes = {
        'nofile',
        'quickfix',
        'prompt',
    },
    ignored_buftypes = { },
    default_amount = 3,
    wrap_at_edge = true,
    tmux_integration = true,
})
