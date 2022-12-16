local refactoring = require('refactoring')
refactoring.setup({})

require('telescope').load_extension('refactoring')

vim.keymap.set('v', '<LocalLeader>rr', require('telescope').extensions.refactoring.refactors,
    { noremap = true, silent = true, desc = 'Refactoring Prompt' })

vim.keymap.set('n', '<LocalLeader>rp', refactoring.debug.printf,
    { noremap = true, silent = true, desc = 'Add debug print statment' })
vim.keymap.set({'n', 'v'}, '<LocalLeader>rv', refactoring.debug.print_var,
    { noremap = true, silent = true, desc = 'Add debug variable print' })
vim.keymap.set('n', '<LocalLeader>rc', refactoring.debug.cleanup,
    { noremap = true, silent = true, desc = 'Cleanup debug statments' })
