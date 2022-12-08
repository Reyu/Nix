require('zen-mode').setup({
    window = {
        backdrop = 1,
        width = 120,
        height = 1,
        options = {
            number = false,
            relativenumber = true,
            cursorline = false,
            cursorcolumn = false,
        },
    },
})
vim.keymap.set('n', '<Leader>z', require('zen-mode').toggle, { desc = 'Zen Mode' })
