-- ############# --
-- NeoVim Config --
-- ############# --
require('impatient')
-- Plugins
-- Plugin: NeoSolarized {{{
vim.g.NeoSolarized_italics = 1 -- 0 or 1
vim.g.NeoSolarized_visibility = 'normal' -- low, normal, high
vim.g.NeoSolarized_diffmode = 'normal' -- low, normal, high
vim.g.NeoSolarized_termtrans = 1 -- 0(default) or 1 -> Transparency
vim.g.NeoSolarized_lineNr = 0 -- 0 or 1 (default) -> To Show backgroung in LineNr
vim.cmd [[
    colorscheme NeoSolarized
    highlight FloatBorder guibg=NONE ctermbg=NONE  " Removes the border of float menu (LSP and Autocompletion uses it)
    highlight link NormalFloat Normal
    highlight NormalFloat ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
    highlight Pmenu ctermbg=NONE guibg=NONE
]]
-- }}}
-- Plugin: telescope-nvim {{{
require('telescope').setup({
    defaults = {
        mappings = {
            i = {
                ['<C-Down>'] = require('telescope.actions').cycle_history_next,
                ['<C-Up>'] = require('telescope.actions').cycle_history_prev
            }
        },
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
        }
    }
})

require('which-key').register({
    t = {
        name = 'Telescope',
        t = {'<cmd>Telescope<CR>', 'Telescope prompt'},
        c = {
            function() require('telescope.builtin').colorscheme({}) end,
            'Available colorschemes'
        },
        b = {
            function() require('telescope.builtin').buffers({}) end,
            'Open buffers'
        },
        m = {
            function() require('telescope.builtin').marks({}) end,
            'Vim marks and their value'
        },
        r = {
            function() require('telescope.builtin').registers({}) end,
            'Vim registers'
        },
        q = {
            function() require('telescope.builtin').quickfix({}) end,
            'Items in the quickfix list'
        },
        l = {
            function() require('telescope.builtin').loclist({}) end,
            'Items from the current window\'s location list'
        },
        j = {
            function() require('telescope.builtin').jumplist({}) end,
            'Jump List entries'
        }
    },
    f = {
        name = 'Find Files',
        f = {
            function()
                local ok = pcall(require('telescope.builtin').git_files)
                if not ok then
                    require('telescope.builtin').find_files()
                end
            end, 'Files in your current working directory'
        },
        l = {
            function() require('telescope.builtin').live_grep({}) end,
            'Search for a string in current working directory'
        }
    },
    g = {
        name = 'Git',
        c = {
            function() require('telescope.builtin').git_commits({}) end,
            'Lists git commits with diff preview'
        },
        d = {
            function() require('telescope.builtin').git_bcommits({}) end,
            'Lists buffer\'s git commits with diff'
        },
        b = {
            function() require('telescope.builtin').git_branches({}) end,
            'Lists all branches with log preview'
        },
        s = {'<CMD>Git<CR>', 'Fugitive git status'},
        x = {
            function() require('telescope.builtin').git_stash({}) end,
            'Lists stash items in current repository'
        },
        ['<SPACE>'] = {':Git ', 'Run Git command'}
    }
}, {mode = 'n', prefix = '<leader>'})
-- }}}
-- Plugin: telescope-hoogle {{{
require('telescope').load_extension('hoogle')
-- }}}
-- Plugin: treesitter {{{
require('nvim-treesitter.configs').setup({
    context_commentstring = {enable = true},
    endwise = {enable = true},
    highlight = {enable = true},
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = 'gnn',
            scope_incremental = 'grs',
            node_incremental = 'grn',
            node_decremental = 'grm'
        }
    },
    indent = {enable = true}
})
vim.api.nvim_set_option('foldmethod', 'expr')
vim.api.nvim_set_option('foldexpr', 'nvim_treesitter#foldexpr()')
-- }}}
-- Plugin: lualine-nvim {{{
require('reyu/lualine')

-- }}}
-- Plugin: dashboard-nvim {{{
local db = require('dashboard')
db.custom_header = {
        '███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
        '████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
        '██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
        '██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
        '██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
        '╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
    }
db.custom_center = {
      {icon = '  ',
      desc = 'Load lastest session           ',
      shortcut = '\\ s l',
      action ='SessionLoad'},
      {icon = '  ',
      desc = 'Recently opened files          ',
      action =  'DashboardFindHistory',
      shortcut = '\\ f h'},
      {icon = '  ',
      desc = 'Find  File                     ',
      action = 'Telescope find_files find_command=rg,--hidden,--files',
      shortcut = '\\ f f'},
      {icon = '  ',
      desc ='File Browser                    ',
      action =  'Telescope file_browser',
      shortcut = '\\ f b'},
      {icon = '  ',
      desc = 'Find  word                     ',
      action = 'Telescope live_grep',
      shortcut = '\\ f w'},
    }
vim.api.nvim_create_autocmd('FileType', {
    pattern = {'dashboard'},
    callback = function()
        vim.opt['list'] = false
        vim.cmd([[highlight clear ExtraWhitespace]])
    end
})
require('which-key').register({
    s = {
        name = 'Session',
        s = {'<cmd>SessionSave<cr>', 'Save current session'},
        l = {'<cmd>SessionLoad<cr>', 'Load last session'}
    }
}, {mode = 'n', prefix = '<leader>'})
-- }}}
-- Plugin: tmux-navigator {{{
vim.api.nvim_set_var('tmux_navigator_disable_when_zoomed', true)
vim.api.nvim_set_var('tmux_navigator_no_mappings', true)

-- Normal mode
require('which-key').register({
    ['<A-h>'] = {
        function() vim.api.nvim_cmd({cmd = 'TmuxNavigateLeft'}, {}) end,
        'Navigate left one window (vim) or pane (tmux)'
    },
    ['<A-l>'] = {
        function() vim.api.nvim_cmd({cmd = 'TmuxNavigateRight'}, {}) end,
        'Navigate right one window (vim) or pane (tmux)'
    },
    ['<A-j>'] = {
        function() vim.api.nvim_cmd({cmd = 'TmuxNavigateDown'}, {}) end,
        'Navigate down one window (vim) or pane (tmux)'
    },
    ['<A-k>'] = {
        function() vim.api.nvim_cmd({cmd = 'TmuxNavigateUp'}, {}) end,
        'Navigate up one window (vim) or pane (tmux)'
    },
    ['<A-p>'] = {
        function() vim.api.nvim_cmd({cmd = 'TmuxNavigatePrevious'}, {}) end,
        'Navigate to previous window (vim) or pane (tmux)'
    }
}, {mode = 'n'})

-- Terminal Mode
require('which-key').register({
    ['<A-h>'] = {
        function() vim.api.nvim_cmd({cmd = 'TmuxNavigateLeft'}, {}) end,
        'Navigate left one window (vim) or pane (tmux)'
    },
    ['<A-l>'] = {
        function() vim.api.nvim_cmd({cmd = 'TmuxNavigateRight'}, {}) end,
        'Navigate right one window (vim) or pane (tmux)'
    },
    ['<A-j>'] = {
        function() vim.api.nvim_cmd({cmd = 'TmuxNavigateDown'}, {}) end,
        'Navigate down one window (vim) or pane (tmux)'
    },
    ['<A-k>'] = {
        function() vim.api.nvim_cmd({cmd = 'TmuxNavigateUp'}, {}) end,
        'Navigate up one window (vim) or pane (tmux)'
    }
}, {mode = 't'})
-- }}}
-- Plugin: FixCursorHold-nvim {{{
vim.api.nvim_set_var('cursorhold_updatetime', 100)
-- }}}
-- Plugin: neoscroll-nvim {{{
require('neoscroll').setup({easing_function = 'quadratic'})
-- }}}
-- Plugin: nvim-tree-lua {{{
require('nvim-tree').setup({renderer = {highlight_git = true}})
-- }}}
-- Plugin: gitsigns-nvim {{{
require('gitsigns').setup()
-- }}}
-- Plugin: octo-nvim {{{
require('octo').setup()
-- }}}
-- Plugin: nvim-autopairs {{{
require('nvim-autopairs').setup()
-- }}}
-- Plugin: Goyo {{{
vim.api.nvim_set_var('goyo_width', 120)
require('which-key').register({
    ['g'] = {
        function() vim.api.nvim_cmd({cmd = 'Goyo'}, {}) end,
        'Toggle Goyo for distraction free editing'
    }
}, {prefix = '<leader>'})
vim.api.nvim_create_autocmd('User', {
    pattern = {'GoyoEnter'},
    callback = function()
        if vim.fn.exists('$TMUX') then
            vim.api.nvim_cmd({
                cmd = "!",
                args = {"tmux", "set", "status", "off"},
                mods = {silent = true}
            }, {})
        end
    end
})
vim.api.nvim_create_autocmd('User', {
    pattern = {'GoyoLeave'},
    callback = function()
        if vim.fn.exists('$TMUX') then
            vim.api.nvim_cmd({
                cmd = "!",
                args = {"tmux", "set", "status", "on"},
                mods = {silent = true}
            }, {})
        end
    end
})
-- }}}
-- Plugin: easy-align {{{
require('which-key').register({
    ga = {
        "<Plug>(EasyAlign)",
        "Start interactive EasyAlign in visual mode"
    }
}, {mode = 'n'})
require('which-key').register({
    ga = {
        "<Plug>(EasyAlign)",
        "Start interactive EasyAlign for a motion/text object"
    }
}, {mode = 'x'})
-- }}}
-- Plugin: netman {{{
require('netman')
-- }}}
-- Plugin: telescope-ui-select-nvim {{{
require("telescope").load_extension("ui-select")
-- }}}
-- Plugin: lsp_lines {{{
vim.diagnostic.config({ virtual_text = false })
require("lsp_lines").setup()
require("which-key").register({
    l = {
        function() require("lsp_lines").toggle() end,
        "Toggle lsp_lines"
    }
}, {prefix = "<space>"})
-- }}}

-- Completion
-- Plugin: nvim-lspconfig {{{
require('reyu/lsp_config')
-- }}}
-- Plugin: nvim-cmp {{{
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
               vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col,
                                                                          col)
                   :match('%s') == nil
end

local cmp = require('cmp')
cmp.setup({
    formatting = {format = require('lspkind').cmp_format()},
    snippet = {
        expand = function(args) require('luasnip').lsp_expand(args.body) end
    },
    mapping = {
        ['<C-n>'] = cmp.mapping({
            c = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({behavior = cmp.SelectBehavior.Insert})
                else
                    cmp.complete()
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({behavior = cmp.SelectBehavior.Insert})
                elseif require('luasnip').expand_or_locally_jumpable() then
                    require('luasnip').expand_or_jump()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end
        }),
        ['<C-p>'] = cmp.mapping({
            c = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item({behavior = cmp.SelectBehavior.Insert})
                else
                    cmp.complete()
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item({behavior = cmp.SelectBehavior.Insert})
                elseif require('luasnip').jumpable(-1) then
                    require('luasnip').jump(-1)
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end
        }),
        ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Select
        }), {'i'}),
        ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Select
        }), {'i'}),
        ['<Tab>'] = cmp.mapping({
            c = function()
                if cmp.visible() then
                    cmp.select_next_item({behavior = cmp.SelectBehavior.Select})
                else
                    vim.api.nvim_feedkeys(t('<Down>'), 'n', true)
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({behavior = cmp.SelectBehavior.Select})
                else
                    fallback()
                end
            end,
            s = function(fallback)
                if require('luasnip').expand_or_locally_jumpable() then
                    require('luasnip').expand_or_jump()
                else
                    fallback()
                end
            end
        }),
        ['<S-Tab>'] = cmp.mapping({
            c = function()
                if cmp.visible() then
                    cmp.select_prev_item({behavior = cmp.SelectBehavior.Select})
                else
                    vim.api.nvim_feedkeys(t('<Up>'), 'n', true)
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item({behavior = cmp.SelectBehavior.Select})
                else
                    fallback()
                end
            end,
            s = function(fallback)
                if require('luasnip').jumpable(-1) then
                    require('luasnip').jump(-1)
                else
                    fallback()
                end
            end
        }),
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close()
        }),
        ['<CR>'] = cmp.mapping(cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
        }), {'i'})
    },
    sources = cmp.config.sources({
        {name = 'vim-dadbod-completion'}, {name = 'nvim_lsp_signature_help'}
    }, {
        {name = 'calc'}, {name = 'luasnip'}, {name = 'nvim_lsp'},
        {name = 'latex_symbols'}, {name = 'emoji'}
    }, {{name = 'treesitter'}, {name = 'buffer'}})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources(
        {{name = 'cmp_git'}, {name = 'neorg'}},
        {{name = 'latex_symbols'}, {name = 'emoji'}, {name = 'calc'}, {name = 'buffer'}}
    )
})
-- Use buffer source for `/`
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {{name = 'buffer'}}
})

-- Use cmdline & path source for ':'
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline'}})
})

-- }}}
-- Plugin: null-ls-nvim {{{
local null_ls = require('null-ls')
null_ls.setup({
    sources = {
        null_ls.builtins.code_actions.gitrebase,
        null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.code_actions.proselint,
        null_ls.builtins.diagnostics.gitlint,
        null_ls.builtins.formatting.trim_newlines,
        null_ls.builtins.formatting.trim_whitespace
    }
})
-- }}}
-- Plugin: luasnip {{{
require('luasnip.loaders.from_vscode').load()
require('luasnip.loaders.from_snipmate').load()
require('luasnip').config.setup({})
-- }}}
-- Plugin: fidget-nvim {{{
require('fidget').setup()
-- }}}

-- Filetypes
-- Plugin: vim-ledger {{{
vim.api.nvim_set_var('ledger_extra_options', '-s')
vim.api.nvim_set_var('ledger_maxwidth', 160)
vim.api.nvim_set_var('ledger_date_format', '%Y-%m-%d')

vim.api.nvim_create_autocmd('BufEnter', {
    pattern = '*.ldg',
    callback = function()
        require('which-key').register({
            t = {
                name = 'Ledger Transaction',
                r = {
                    function()
                        vim.call('ledger#transaction_state_set',
                                 vim.fn.line('.'), '*')
                    end, 'Reconcile transaction'
                },
                t = {
                    function()
                        vim.call('ledger#transaction_state_toggle',
                                 vim.fn.line('.'), ' *?!')
                    end, 'Toggle transaction state'
                },
                d = {
                    name = 'Set Transaction Date',
                    p = {
                        function()
                            vim.call('ledger#transaction_date_set',
                                     vim.fn.line('.'), 'primary')
                        end, 'Set today\'s data as primary tx date'
                    },
                    a = {
                        function()
                            vim.call('ledger#transaction_date_set',
                                     vim.fn.line('.'), 'auxiliary')
                        end, 'Set today\'s data as auxiliary tx date'
                    },
                    u = {
                        function()
                            vim.call('ledger#transaction_date_set',
                                     vim.fn.line('.'), 'unshift')
                        end,
                        'Set current date to auxiliary, and set today as primary'
                    }
                }
            },
            ['<Tab>'] = {
                function()
                    vim.call('ledger#autocomplete_and_align')
                end, 'Autocomplete or align transaction'
            }
        }, {buffer = vim.fn.bufnr()})
    end
})
-- }}}
-- Plugin: vimwiki {{{
vim.api.nvim_set_var('vimwiki_filetypes', {'markdown', 'pandoc'})
vim.api.nvim_set_var('vimwiki_list', {
    {
        path = '~/Notes',
        ext = '.md',
        syntax = 'markdown',
        list_margin = 0,
        links_space_char = '_'
    }
})
-- }}}
-- Plugin: neorg {{{
require('neorg').setup {
    load = {
        ["core.defaults"] = {},
        ["core.export"] = {},
        ["core.export.markdown"] = {},
        ["core.norg.qol.todo_items"] = {},
        ["core.norg.concealer"] = {},
        ["core.norg.dirman"] = {
            config = {
                workspaces = {
                    home = "~/Notes",
                }
            }
        },
        ["core.integrations.nvim-cmp"] = {},
    }
}
-- }}}

-- Testing
-- Plugin: neotest {{{
require('neotest').setup({
    adapters = {
        require('neotest-python')({dap = {justMyCode = true}}),
        require('neotest-vim-test')(
            {ignore_file_types = {'python', 'vim', 'lua'}})
    }
})
-- }}}
-- Plugin: nvim-dap {{{
require('reyu/dap')
require('which-key').register({
    ['<F2>'] = {function() require('dapui').toggle() end, 'Toggle debug UI'},
    ['<F5>'] = {
        function() require('dap').continue() end, 'Start/Continue debug session'
    },
    ['<F10>'] = {
        function() require('dap').step_over() end, 'Run again for one step'
    },
    ['<F11>'] = {
        function() require('dap').step_into() end,
        'Step into a function or method'
    },
    ['<F12>'] = {
        function() require('dap').step_out() end,
        'Step out of a function or method'
    }
})
require('which-key').register({
    d = {
        name = 'Debug',
        b = {
            function() require('dap').toggle_breakpoint() end,
            'Creates or removes a breakpoint'
        },
        B = {
            function()
                require('dap').set_breakpoint(vim.fn.input(
                                                  'Breakpoint condition: '))
            end, 'Set breakpoint w/ condition'
        },
        e = {
            function() require('dap').set_exception_breakpoints() end,
            'Sets breakpoints on exceptions'
        },
        l = {
            function()
                require('dap').set_breakpoint(nil, nil, vim.fn
                                                  .input('Log point message: '))
            end, 'Set LogPoint'
        },
        c = {
            function() require('dap').clear_breakpoints() end,
            'Clear all breakpoints'
        },
        r = {function() require('dap').repl.open() end, 'Open a REPL'},
        R = {
            function() require('dap').run_last() end,
            'Re-runs the last debug-adapter/configuration'
        },
        s = {
            name = 'Step',
            n = {
                function() require('dap').step_over() end,
                'Run again for one step'
            },
            i = {
                function() require('dap').step_into() end,
                'Step into a function or method'
            },
            o = {
                function() require('dap').step_out() end,
                'Step out of a function or method'
            },
            b = {
                function() require('dap').step_back() end, 'Step one step back'
            }
        }
    }
}, {prefix = '<leader>'})
-- }}}
-- Plugin: nvim-dap-ui {{{
require('dapui').setup()
require('which-key').register({
    d = {u = {function() require('dapui').toggle() end, 'Toggle DAP UI'}}
}, {prefix = '<leader>'})
local dap, dapui = require('dap'), require('dapui')
dap.listeners.after.event_initialized['dapui_config'] =
    function() dapui.open() end
dap.listeners.before.event_terminated['dapui_config'] =
    function() dapui.close() end
dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end
-- }}}

-- General Options {{{

-- Don't use the mouse. Ever.
vim.api.nvim_set_option_value('mouse', '', {})

-- Turn on mode lines
vim.api.nvim_set_option_value('modeline', true, {})
vim.api.nvim_set_option_value('modelines', 3, {})

-- Show the first layer of folds by default
vim.api.nvim_set_option_value('foldlevel', 1, {})

-- Show the cursorline, so I don't get lost
vim.api.nvim_set_option_value('cursorline', true, {})

-- Configure line numbers
vim.api.nvim_set_option_value('number', true, {})

-- Configure tab preferences
vim.api.nvim_set_option_value('tabstop', 4, {})
vim.api.nvim_set_option_value('shiftwidth', 0, {})
vim.api.nvim_set_option_value('expandtab', true, {})

-- Ignore case in searching...
vim.api.nvim_set_option_value('ignorecase', true, {})
-- ...except if search string contains uppercase
vim.api.nvim_set_option_value('smartcase', true, {})

-- Split windows below, or to the right of, the current window
vim.api.nvim_set_option_value('splitbelow', true, {})
vim.api.nvim_set_option_value('splitright', true, {})

-- Keep some context at screen edges
vim.api.nvim_set_option_value('scrolloff', 5, {})
vim.api.nvim_set_option_value('sidescrolloff', 5, {})

-- Tell Vim which characters to show for expanded TABs,
-- trailing whitespace, and end-of-lines.
vim.api.nvim_set_option_value('listchars',
                              'tab:> ,trail:-,extends:>,precedes:<,nbsp:+', {})
vim.api.nvim_set_option_value('list', true, {}) -- Show problematic characters.

-- Some extra highlight commands
vim.cmd([[
    " Highlight all tabs and trailing whitespace characters.
    highlight ExtraWhitespace ctermbg=Darkgreen guibg=#004400
    match ExtraWhitespace /\s\+$\|\t/

    " Allow for transparent background
    highlight Normal ctermbg=NONE guibg=NONE
    highlight Terminal ctermbg=NONE guibg=NONE
]])

-- Files, backups and undo
-- Keep backups in cache folder, so as not to clutter filesystem.
vim.api.nvim_set_option_value('backup', true, {})
vim.api.nvim_set_option_value('writebackup', true, {})
vim.api.nvim_set_option_value('undofile', true, {})

local savePath = vim.fn.stdpath('state')
vim.api.nvim_set_option_value('directory', savePath .. '/other//,/tmp//', {})
vim.api.nvim_set_option_value('backupdir', savePath .. '/backups//,/tmp//', {})
vim.api.nvim_set_option_value('undodir', savePath .. '/undo//,/tmp//', {})
-- }}}
-- Autocommands {{{
vim.api.nvim_create_autocmd('TermOpen', {
    pattern = {'*'},
    callback = function()
        vim.api.nvim_buf_set_option(0, 'number', false)
        vim.api.nvim_buf_set_option(0, 'relativenumber', false)
    end
})
-- }}}

-- vim: foldmethod=marker
