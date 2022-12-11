require('notify').setup({ background_colour = '#000000', })

require('which-key').register({ ['<Leader>n'] = { name = 'Notifications' }})
vim.keymap.set('n', '<Leader>nd', require('notify').dismiss,
    { silent = true, desc = 'Dismiss notifications' })
