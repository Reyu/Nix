-- ############# --
-- NeoVim Config --
-- ############# --

-- Use GUI colors for terminal
vim.o.termguicolors = true

-- Set leader prefixes
vim.g.mapleader = '\\'
vim.g.maplocalleader = ' '

-- Don't use the mouse. Ever.
vim.o.mouse = ""

-- Turn on mode lines
vim.o.modeline = true
vim.o.modelines = 3

-- Show the first layer of folds by default
vim.o.foldlevel = 1

-- Show the cursorline, so I don't get lost
vim.o.cursorline = true

-- Configure line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Configure tab preferences
vim.o.tabstop = 4
vim.o.shiftwidth = 0
vim.o.expandtab = true

-- Ignore case in searching...
vim.o.ignorecase = true
-- ...except if search string contains uppercase
vim.o.smartcase = true

-- Split windows below, or to the right of, the current window
vim.o.splitbelow = true
vim.o.splitright = true

-- Keep some context at screen edges
vim.o.scrolloff = 5
vim.o.sidescrolloff = 5

-- Tell Vim which characters to show for expanded TABs,
-- trailing whitespace, and end-of-lines.
vim.o.listchars = "tab:> ,trail:-,extends:>,precedes:<,nbsp:+"
vim.o.list = true

-- Files, backups and undo
-- Keep backups in cache folder, so as not to clutter filesystem.
vim.o.backup = true
vim.o.writebackup = true
vim.o.undofile = true

vim.o.directory = vim.fn.stdpath("cache") .. "/swap//"
vim.o.backupdir = vim.fn.stdpath("cache") .. "/backups//"
vim.o.undodir = vim.fn.stdpath("state") .. "/undo//"

-- Autocommands
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = { "*" },
    callback = function()
        vim.wo.number = false
        vim.wo.relativenumber = false
    end,
})
