-- See `:help mini.*` for details on each
require('mini.ai').setup({})
require('mini.bufremove').setup({})
require('mini.comment').setup({})
require('mini.indentscope').setup({})
require('mini.pairs').setup({})
require('mini.surround').setup({})
require('mini.trailspace').setup({})

local mini_map = require('mini.map')
mini_map.setup({
    integrations = {
      mini_map.gen_integration.builtin_search(),
      mini_map.gen_integration.gitsigns(),
      mini_map.gen_integration.diagnostic(),
    },
    window = {
        winblend = 0,
        show_integration_count = false,
    }
})
vim.keymap.set('n', '<Leader>mc', MiniMap.close,
    { silent = true, noremap = true, desc = 'Close MiniMap'})
vim.keymap.set('n', '<Leader>mo', MiniMap.open,
    { silent = true, noremap = true, desc = 'Open Minimap'})
vim.keymap.set('n', '<Leader>mr', MiniMap.refresh,
    { silent = true, noremap = true, desc = 'Refresh Minimap'})
vim.keymap.set('n', '<Leader>ms', MiniMap.toggle_side,
    { silent = true, noremap = true, desc = 'Toggle MiniMap side'})
vim.keymap.set('n', '<Leader>mm', MiniMap.toggle,
    { silent = true, noremap = true, desc = 'Toggle MiniMap'})

local session_dir = vim.fn.stdpath("data") .. "/session"
if vim.fn.isdirectory(session_dir) == 0 then
    vim.pretty_print("Creating session dir!")
    vim.fn.mkdir(session_dir, "p")
end
require('mini.sessions').setup({
    directory = session_dir
})

local starter = require('mini.starter')
starter.setup({
    header = [[
    ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗
    ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║
    ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║
    ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║
    ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║
    ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝
    ]],
    items = {
        starter.sections.sessions(5, true),
        starter.sections.builtin_actions(),
        starter.sections.telescope(),
    },
    content_hooks = {
        starter.gen_hook.adding_bullet("• ", false),
        starter.gen_hook.aligning('center', 'center'),
    },
})
