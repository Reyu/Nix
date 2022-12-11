local neotest = require('neotest')

neotest.setup({
    adapters = {
        require('neotest-python')({ dap = { justMyCode = false } }),
        require('neotest-vim-test')({ ignore_file_types = { 'python', 'vim', 'lua' } }),
    },
    icons = {
        child_indent = '│',
        child_prefix = '├',
        collapsed = '─',
        expanded = '╮',
        failed = '✖',
        final_child_indent = ' ',
        final_child_prefix = '╰',
        non_collapsible = '─',
        passed = '✔',
        running = '⊙',
        running_animated = { '/', '|', '\\', '-', '/', '|', '\\', '-' },
        skipped = 'ﰸ',
        unknown = '?',
    },
})

require('which-key').register({ ['<LocalLeader>t'] = { name = 'Project Tests' }})
vim.keymap.set('n', '<LocalLeader>tt', function() neotest.run.run({ suite = true }) end,
    { silent = true, noremap = true, desc = 'Run entire test suite' })
vim.keymap.set('n', '<LocalLeader>tn', neotest.run.run,
    { silent = true, noremap = true, desc = 'Run nearest test' })
vim.keymap.set('n', '<LocalLeader>tf', function() neotest.run.run(vim.fn.expand("%")) end,
    { silent = true, noremap = true, desc = 'Run current file' })
vim.keymap.set('n', '<LocalLeader>td', function() neotest.run.run({ strategy = "dap" }) end,
    { silent = true, noremap = true, desc = 'Debug nearest test' })
vim.keymap.set('n', '<LocalLeader>ts', neotest.run.stop,
    { silent = true, noremap = true, desc = 'Stop nearest test' })
vim.keymap.set('n', '<LocalLeader>tr', neotest.run.run_last,
    { silent = true, noremap = true, desc = 'Re-run previous test' })
vim.keymap.set('n', '<LocalLeader>to', neotest.output_panel.open,
    { silent = true, noremap = true, desc = 'Display test output' })
vim.keymap.set('n', '<LocalLeader>tt', neotest.summary.toggle,
    { silent = true, noremap = true, desc = 'Toggle summary window' })
vim.keymap.set('n', '<LocalLeader>tm', neotest.summary.run_marked,
    { silent = true, noremap = true, desc = 'Run marked tests' })
vim.keymap.set('n', '<LocalLeader>t<S-m>', neotest.summary.clear_marked,
    { silent = true, noremap = true, desc = 'Clear marked tests in summary window' })
vim.keymap.set('n', ']t', function() neotest.jump.next({ status = "failed" }) end,
    { silent = true, noremap = true, desc = 'Jump to next failing test' })
vim.keymap.set('n', '[t', function() neotest.jump.prev({ status = "failed" }) end,
    { silent = true, noremap = true, desc = 'Jump to previous failing test' })
