require('notify').setup({ background_colour = '#000000', })

vim.keymap.set('n', '<Leader>nd', require('notify').dismiss,
    { silent = true, desc = 'Dismiss notifications' })
