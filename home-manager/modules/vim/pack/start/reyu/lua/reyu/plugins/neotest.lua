require('which-key').register({ ['<LocalLeader>t'] = { name = 'Project Tests' }})

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

vim.keymap.set('n', '<LocalLeader>t', function() neotest.run.run({ suite = true }) end,
    { silent = true, noremap = true, desc = 'Run entire test suite' })
vim.keymap.set('n', '<LocalLeader>n', neotest.run.run,
    { silent = true, noremap = true, desc = 'Run nearest test' })
vim.keymap.set('n', '<LocalLeader>f', function() neotest.run.run(vim.fn.expand("%")) end,
    { silent = true, noremap = true, desc = 'Run current file' })
vim.keymap.set('n', '<LocalLeader>d', function() neotest.run.run({ strategy = "dap" }) end,
    { silent = true, noremap = true, desc = 'Debug nearest test' })
vim.keymap.set('n', '<LocalLeader>s', neotest.run.stop,
    { silent = true, noremap = true, desc = 'Stop nearest test' })
vim.keymap.set('n', '<LocalLeader>r', neotest.run.run_last,
    { silent = true, noremap = true, desc = 'Re-run previous test' })
vim.keymap.set('n', '<LocalLeader>o', neotest.output_panel.open,
    { silent = true, noremap = true, desc = 'Display test output' })
vim.keymap.set('n', '<LocalLeader>t', neotest.summary.toggle,
    { silent = true, noremap = true, desc = 'Toggle summary window' })
vim.keymap.set('n', '<LocalLeader>m', neotest.summary.run_marked,
    { silent = true, noremap = true, desc = 'Run marked tests' })
vim.keymap.set('n', '<LocalLeader><S-m>', neotest.summary.clear_marked,
    { silent = true, noremap = true, desc = 'Clear marked tests in summary window' })
vim.keymap.set('n', ']t', function() neotest.jump.next({ status = "failed" }) end,
    { silent = true, noremap = true, desc = 'Jump to next failing test' })
vim.keymap.set('n', '[t', function() neotest.jump.prev({ status = "failed" }) end,
    { silent = true, noremap = true, desc = 'Jump to previous failing test' })
