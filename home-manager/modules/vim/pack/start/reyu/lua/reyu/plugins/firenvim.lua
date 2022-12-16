vim.g.firenvim_config = {
    globalSettings = {
        alt = 'all',
     },
    localSettings = {
        ['.*'] = {
            cmdline = 'neovim',
            content = 'text',
            priority = 0,
            selector = 'textarea:not([readonly]), div[role="textbox"]',
            takeover = 'empty',
        },
    }
}

vim.keymap.set('n', '<Esc><Esc>', vim.fn['firenvim#focus_page'])

vim.g.firenvim_timer_started = false
vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI"}, {
    pattern = { "*" },
    callback = function()
        if vim.g.firenvim_timer_started then
            return
        else
            vim.g.firenvim_timer_started = true
            vim.fn.timer_start(1000, function()
                vim.g.firenvim_timer_started = false
                vim.cmd('write')
            end)
        end
    end,
})
