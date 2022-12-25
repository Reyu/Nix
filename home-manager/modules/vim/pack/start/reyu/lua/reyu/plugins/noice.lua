local noice = require('noice')
noice.setup({
    lsp = {
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
        },
    },
    presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
    },
    cmdline = {
        format = {
            cmdline = { icon = '>' },
            search_down = { icon = '🔍⌄' },
            search_up = { icon = '🔍⌃' },
            filter = { icon = '$' },
            lua = { icon = '☾' },
            help = { icon = '?' },
        },
    },
})

vim.keymap.set('n', '<Leader>nl', function() noice.cmd('last') end,
    { silent = true, desc = 'Last Notification' })
vim.keymap.set('n', '<Leader>nh', function() noice.cmd('history') end,
    { silent = true, desc = 'Notification History' })