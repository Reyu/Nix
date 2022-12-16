vim.g.neo_tree_remove_legacy_commands = 1

vim.fn.sign_define('DiagnosticSignError',
    { text = ' ', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn',
    { text = ' ', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignInfo',
    { text = ' ', texthl = 'DiagnosticSignInfo' })
vim.fn.sign_define('DiagnosticSignHint',
    { text = '', texthl = 'DiagnosticSignHint' })

require('neo-tree').setup({
    close_if_last_window = false,
    popup_border_style = 'rounded',
    enable_git_status = true,
    enable_diagnostics = true,
    sort_case_insensitive = true,
})

vim.keymap.set('n', '|', '<Cmd>Neotree action=focus source=filesystem reveal=true<CR>',
    { silent = true, noremap = true, desc = 'Toggle NeoTree'})

vim.keymap.set('n', '<Leader>tt', '<Cmd>Neotree action=show source=filesystem toggle=true reveal=true position=left<CR>',
    { silent = true, noremap = true, desc = 'Toggle NeoTree'})
vim.keymap.set('n', '<Leader>tb', '<Cmd>Neotree action=show source=buffers toggle=true position=right<CR>',
    { silent = true, noremap = true, desc = 'Toggle buffer list'})
vim.keymap.set('n', '<Leader>ts', '<Cmd>Neotree action=focus source=git_status position=float<CR>',
    { silent = true, noremap = true, desc = 'Show Git Status'})
