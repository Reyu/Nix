local trouble = require('trouble')

trouble.setup({
    auto_preview = true,
    use_diagnostic_signs = true,
    auto_open = true,
    auto_close = true,
    auto_fold = true,
})

vim.keymap.set('n', '<LocalLeader>xw', '<Cmd>Trouble workspace_diagnostics<CR>',
    { silent = true, noremap = true, desc = 'Workspace Diagnostics' })

vim.keymap.set('n', '<LocalLeader>xd', '<Cmd>Trouble document_diagnostics<CR>',
    { silent = true, noremap = true, desc = 'Document Diagnostics' })

vim.keymap.set('n', '<LocalLeader>xa', trouble.action,
    { silent = true, noremap = true, desc = 'Troubleshoot Action' })

vim.keymap.set('n', '<LocalLeader>xo', trouble.open,
    { silent = true, noremap = true, desc = 'Open Troubleshooting Window' })

vim.keymap.set('n', '<LocalLeader>xc', trouble.close,
    { silent = true, noremap = true, desc = 'Close Trouble Window' })

vim.keymap.set('n', '<LocalLeader>xx', trouble.toggle,
    { silent = true, noremap = true, desc = 'Toggle Troubleshooting Window' })

vim.keymap.set('n', '<LocalLeader>xr', trouble.refresh,
    { silent = true, noremap = true, desc = 'Refresh Troubleshooting Information' })

vim.keymap.set('n', '<LocalLeader>xn', trouble.next,
    { silent = true, noremap = true, desc = 'Next Troubleshooting Item' })

vim.keymap.set('n', ']x', trouble.next,
    { silent = true, noremap = true, desc = 'Next Troubleshooting Item' })

vim.keymap.set('n', '<LocalLeader>xp', trouble.previous,
    { silent = true, noremap = true, desc = 'Previous Troubleshooting Item' })

vim.keymap.set('n', '[x', trouble.previous,
    { silent = true, noremap = true, desc = 'Previous Troubleshooting Item' })
