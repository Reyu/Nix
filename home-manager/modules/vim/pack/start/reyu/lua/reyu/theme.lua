require('NeoSolarized').setup {
    style = 'dark',
    transparent = true,
    terminal_colors = true,
    enable_italics = true,
    styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = { bold = true },
        variables = {},
        string = { italic = true },
        underline = true,
        undercurl = true,
    },
}
vim.o.termguicolors = true
vim.cmd('colorscheme NeoSolarized')
