local which_key = require('which-key')
which_key.setup({
    plugins = {
        marks = true,
        registers = true,
        spelling = {
            enabled = true,
            suggestions = 20,
        },
    },
    window = {
        border = 'single',
        position = 'bottom',
        margin = { 1, 0, 1, 0 },
        padding = { 2, 2, 2, 2 },
        winblend = 0
    },
    disable = {
        buftypes = {},
        filetypes = { 'TelescopePrompt' },
    }
})
which_key.register({ ['<Leader>n'] = { name = 'Notifications' } })
which_key.register({ ['<Leader>m'] = { name = 'Minimap' } })
which_key.register({ ['<Leader>s'] = { name = 'Sessions' } })
which_key.register({ ['<Leader>t'] = { name = 'NeoTree' } })
which_key.register({ ['<Leader>f'] = { name = 'Find' } })

which_key.register({ ['<LocalLeader>t'] = { name = 'Project Tests' } })
which_key.register({ ['<LocalLeader>d'] = { name = 'Debug' } })
which_key.register({ ['<LocalLeader>x'] = { name = 'Trouble' } })
which_key.register({ ['<LocalLeader>g'] = { name = 'Goto' } })
which_key.register({ ['<LocalLeader>r'] = { name = 'Refactor' } }, { mode = "n" })
which_key.register({ ['<LocalLeader>r'] = { name = 'Refactor' } }, { mode = "v" })
