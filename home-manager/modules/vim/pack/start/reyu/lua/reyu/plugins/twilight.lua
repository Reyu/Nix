require('twilight').setup({
    dimming = {
        alpha = 0.25,
        inactive = true,
    },
    context = 6,
    treesitter = true,
    expand = {
        'function',
        'method',
        'table',
        'if_statement',
    },
})
