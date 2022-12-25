local trouble = require('trouble')

trouble.setup({
    auto_preview = true,
    use_diagnostic_signs = true,
    auto_open = true,
    auto_close = true,
    auto_fold = false,
})

vim.keymap.set('n', '<LocalLeader>xw', '<Cmd>Trouble workspace_diagnostics<CR>',
    { silent = true, noremap = true, desc = 'Workspace Diagnostics' })

vim.keymap.set('n', '<LocalLeader>xd', '<Cmd>Trouble document_diagnostics<CR>',
    { silent = true, noremap = true, desc = 'Document Diagnostics' })

vim.keymap.set('n', '<LocalLeader>xq', '<Cmd>Trouble quickfix<CR>',
    { silent = true, noremap = true, desc = 'Quickfix Items' })

vim.keymap.set('n', '<LocalLeader>xl', '<Cmd>Trouble loclist<CR>',
    { silent = true, noremap = true, desc = 'Location List Items' })

vim.keymap.set('n', '<LocalLeader>xo', trouble.open,
    { silent = true, noremap = true, desc = 'Open Troubleshooting Window' })

vim.keymap.set('n', '<LocalLeader>xc', trouble.close,
    { silent = true, noremap = true, desc = 'Close Trouble Window' })

vim.keymap.set('n', '<LocalLeader>xx', trouble.toggle,
    { silent = true, noremap = true, desc = 'Toggle Troubleshooting Window' })

vim.keymap.set('n', '<LocalLeader>xr', trouble.refresh,
    { silent = true, noremap = true, desc = 'Refresh Troubleshooting Information' })

vim.keymap.set('n', '<LocalLeader>xn', function() trouble.next({}) end,
    { silent = true, noremap = true, desc = 'Next Troubleshooting Item' })

vim.keymap.set('n', ']x', function() trouble.next({jump = true}) end,
    { silent = true, noremap = true, desc = 'Next Troubleshooting Item' })

vim.keymap.set('n', '<LocalLeader>xp', function() trouble.previous({}) end,
    { silent = true, noremap = true, desc = 'Previous Troubleshooting Item' })

vim.keymap.set('n', '[x', function() trouble.previous({jump = true}) end,
    { silent = true, noremap = true, desc = 'Previous Troubleshooting Item' })