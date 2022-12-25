local mind = require('mind')
mind.setup({
    edit = {
        data_extension = '.rst',
        copy_link_format = '`<%s>`_'
    }
})

vim.keymap.set('n', '<Leader>mo',      mind.open_main,          {silent = true, noremap = true, desc = "Open Mind"})
vim.keymap.set('n', '<Leader>mc',      mind.close,              {silent = true, noremap = true, desc = "Close Mind"})
vim.keymap.set('n', '<Leader>mr',      mind.reload_state,       {silent = true, noremap = true, desc = "Reload Mind State"})
vim.keymap.set('n', '<LocalLeader>mo', mind.open_smart_project, {silent = true, noremap = true, desc = "Open Mind"})
