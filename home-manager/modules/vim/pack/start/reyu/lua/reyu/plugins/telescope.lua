require('which-key').register({ ['<Leader>f'] = { name = 'Find' }})

require('telescope').setup({
    defaults = {
        mappings = {
            i = {
                ['<C-Down>'] = require('telescope.actions').cycle_history_next,
                ['<C-Up>'] = require('telescope.actions').cycle_history_prev,
                ['<C-t>'] = require('trouble.providers.telescope').open_with_trouble,
            },
            n = {
                ['<C-t>'] = require('trouble.providers.telescope').open_with_trouble,
            },
        },
        layout_config = {
            vertical = { width = 0.5 }
        },
    },
    pickers = {
        find_files = { theme = 'dropdown' },
        git_files = { theme = 'dropdown' },
        frecency = { theme = 'dropdown' },
    },
    extensions = {
        frecency = {
            default_workspace = 'CWD',
            workspaces = {
                ['conf']  = vim.fn.expand('~') .. '/.config',
                ['data']  = vim.fn.expand('~') .. '/.local/share',
                ['nixos'] = '/etc/nixos',
            },
        },
        ['ui-select'] = {
            require('telescope.themes').get_dropdown({})
        },
    },
})

require('telescope').load_extension('frecency')
require('telescope').load_extension('ui-select')

local ts_builtin = require('telescope.builtin')

local function filesOrGit()
    local is_worktree = vim.api.nvim_cmd({ cmd = '!', args = { 'git', 'rev-parse', '--is-inside-work-tree' } },
        { output = true })
    if string.match(is_worktree, 'true') then
        return ts_builtin.git_files()
    else
        return require('telescope').extensions.frecency.frecency()
    end
end

vim.keymap.set('n', '<Leader>ff', filesOrGit,
    { silent = true, noremap = true, desc = 'File Picker' })
vim.keymap.set('n', '<Leader>fb', ts_builtin.buffers,
    { silent = true, noremap = true, desc = 'Buffer Picker' })
vim.keymap.set('n', '<Leader>fg', ts_builtin.live_grep,
    { silent = true, noremap = true, desc = 'Live Grep' })
vim.keymap.set('n', '<Leader>fh', ts_builtin.help_tags,
    { silent = true, noremap = true, desc = 'Search Help Tags' })
vim.keymap.set('n', '<Leader>fo', ts_builtin.oldfiles,
    { silent = true, noremap = true, desc = 'Find Old Files' })
vim.keymap.set('n', '<Leader>fm', ts_builtin.marks,
    { silent = true, noremap = true, desc = 'Vim Marks' })
