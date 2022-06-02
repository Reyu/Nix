-- ############# --
-- NeoVim Config --
-- ############# --
require("impatient")

-- Plugin telescope-nvim {{{
require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<C-Down>"] = require("telescope.actions").cycle_history_next,
                ["<C-Up>"] = require("telescope.actions").cycle_history_prev
            }
        }
    }
})

require("which-key").register({
    t = {
        name = "Telescope",
        t = {"<cmd>Telescope<CR>", "Telescope prompt"},
        c = {
            function() require("telescope.builtin").colorscheme({}) end,
            "Available colorschemes"
        },
        b = {
            function() require("telescope.builtin").buffers({}) end,
            "Open buffers"
        },
        m = {
            function() require("telescope.builtin").marks({}) end,
            "Vim marks and their value"
        },
        r = {
            function() require("telescope.builtin").registers({}) end,
            "Vim registers"
        },
        q = {
            function() require("telescope.builtin").quickfix({}) end,
            "Items in the quickfix list"
        },
        l = {
            function() require("telescope.builtin").loclist({}) end,
            "Items from the current window's location list"
        },
        j = {
            function() require("telescope.builtin").jumplist({}) end,
            "Jump List entries"
        }
    },
    f = {
        name = "Find Files",
        f = {
            function()
                local ok = pcall(require("telescope.builtin").git_files)
                if not ok then
                    require("telescope.builtin").find_files()
                end
            end, "Files in your current working directory"
        },
        l = {
            function() require("telescope.builtin").live_grep({}) end,
            "Search for a string in current working directory"
        }
    },
    g = {
        name = "Git",
        c = {
            function() require("telescope.builtin").git_commits({}) end,
            "Lists git commits with diff preview"
        },
        d = {
            function() require("telescope.builtin").git_bcommits({}) end,
            "Lists buffer's git commits with diff"
        },
        b = {
            function() require("telescope.builtin").git_branches({}) end,
            "Lists all branches with log preview"
        },
        s = {"<CMD>Git<CR>", "Fugitive git status"},
        x = {
            function() require("telescope.builtin").git_stash({}) end,
            "Lists stash items in current repository"
        },
        ["<SPACE>"] = {":Git ", "Run Git command"}
    }
}, {mode = "n", prefix = "<leader>"})
-- }}}
-- Plugin: telescope-hoogle {{{
require('telescope').load_extension('hoogle')
-- }}}
-- Plugin: lualine-nvim {{{
require("reyu/lualine")

-- }}}
-- Plugin: dashboard-nvim {{{
require("which-key").register({
    s = {
        name = "Session",
        s = {"<cmd>SessionSave<cr>", "Save current session"},
        l = {"<cmd>SessionLoad<cr>", "Load last session"}
    }
}, {mode = "n", prefix = "<leader>"})

vim.g['dashboard_default_executive'] = 'telescope'
vim.g["dashboard_custom_header"] = {
    " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
    " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
    " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
    " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
    " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
    " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝"
}
vim.g["dashboard_custom_shortcut"] = {
    book_marks = "\\ t m",
    change_colorscheme = "\\ t c",
    find_file = "\\ f f",
    find_history = "\\ f h",
    find_word = "\\ f a",
    last_session = "\\ s l",
    new_file = "<N/A>"
}
-- }}}
-- Plugin: tmux-navigator {{{
vim.g["tmux_navigator_disable_when_zoomed"] = 1
vim.g["tmux_navigator_no_mappings"] = 1

-- Normal mode
require("which-key").register({
    ["<A-h>"] = {
        "<cmd>TmuxNavigateLeft<cr>",
        "Navigate left one window (vim) or pane (tmux)"
    },
    ["<A-l>"] = {
        "<cmd>TmuxNavigateRight<cr>",
        "Navigate right one window (vim) or pane (tmux)"
    },
    ["<A-j>"] = {
        "<cmd>TmuxNavigateDown<cr>",
        "Navigate down one window (vim) or pane (tmux)"
    },
    ["<A-k>"] = {
        "<cmd>TmuxNavigateUp<cr>", "Navigate up one window (vim) or pane (tmux)"
    },
    ["<A-p>"] = {
        "<cmd>TmuxNavigatePrevious<cr>",
        "Navigate to previous window (vim) or pane (tmux)"
    }
}, {mode = "n"})

-- Terminal Mode
require("which-key").register({
    ["<A-h>"] = {
        "<cmd>TmuxNavigateLeft<cr>",
        "Navigate left one window (vim) or pane (tmux)"
    },
    ["<A-l>"] = {
        "<cmd>TmuxNavigateRight<cr>",
        "Navigate right one window (vim) or pane (tmux)"
    },
    ["<A-j>"] = {
        "<cmd>TmuxNavigateDown<cr>",
        "Navigate down one window (vim) or pane (tmux)"
    },
    ["<A-k>"] = {
        "<cmd>TmuxNavigateUp<cr>", "Navigate up one window (vim) or pane (tmux)"
    }
}, {mode = "t"})
-- }}}
-- Plugin: FixCursorHold-nvim {{{
vim.g['cursorhold_updatetime'] = 100
-- }}}
-- Plugin: vim-lion {{{
vim.g["lion_squeeze_spaces"] = 1
-- }}}
-- Plugin: vimwiki {{{
vim.g['vimwiki_filetypes'] = {'markdown', 'pandoc'}
vim.g["vimwiki_list"] = {
    {
        path = "~/Notes",
        ext = ".md",
        syntax = "markdown",
        list_margin = 0,
        links_space_char = "_"
    }
}
-- }}}
-- Plugin: nvim-ts-context-commentstring {{{
require("nvim-treesitter.configs").setup({
    context_commentstring = {enable = true}
})
-- }}}
-- Plugin: neoscroll-nvim {{{
require("neoscroll").setup({easing_function = 'quadratic'})
-- }}}
-- Plugin: nvim-tree-lua {{{
vim.g['nvim_tree_git_hl'] = 1
require('nvim-tree').setup {}
-- }}}
-- Plugin: gitsigns-nvim {{{
require('gitsigns').setup()
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
                   :match("%s") == nil
end

local cmp = require("cmp")
cmp.setup({
    formatting = {format = require("lspkind").cmp_format()},
    snippet = {
        expand = function(args) require('luasnip').lsp_expand(args.body) end
    },
    mapping = {
        ["<C-n>"] = cmp.mapping({
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
                elseif require("luasnip").expand_or_locally_jumpable() then
                    require("luasnip").expand_or_jump()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end
        }),
        ["<C-p>"] = cmp.mapping({
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
                elseif require("luasnip").jumpable(-1) then
                    require("luasnip").jump(-1)
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
        ["<Tab>"] = cmp.mapping({
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
                if require("luasnip").expand_or_locally_jumpable() then
                    require("luasnip").expand_or_jump()
                else
                    fallback()
                end
            end
        }),
        ["<S-Tab>"] = cmp.mapping({
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
                if require("luasnip").jumpable(-1) then
                    require("luasnip").jump(-1)
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
        ['<Space>'] = cmp.mapping(cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false
        }), {'i', 'c'}),
        ['<CR>'] = cmp.mapping({
            i = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true
            }),
            c = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = false
            })
        })
    },
    sources = cmp.config.sources({
            {name = 'vim-dadbod-completion'},
            {name = 'nvim_lsp_signature_help'},
        }, {
            {name = 'calc'},
            {name = 'luasnip'},
            {name = 'nvim_lsp'},
            {name = 'latex_symbols'},
            {name = 'emoji'},
        }, {
            {name = 'treesitter'},
            {name = 'buffer'}
        }
        )
})
-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({{name = 'cmp_git'}}, {{name = 'buffer'}})
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
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.code_actions.gitrebase,
        null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.code_actions.proselint,
        null_ls.builtins.diagnostics.gitlint,
        null_ls.builtins.diagnostics.write_good,
        null_ls.builtins.formatting.trim_newlines,
        null_ls.builtins.formatting.trim_whitespace
    }
})
-- }}}
-- Plugin: luasnip {{{
require("luasnip.loaders.from_vscode").load()
require("luasnip.loaders.from_snipmate").load()
require("luasnip").config.setup({
    ext_opts = {
        [require("luasnip.util.types").choiceNode] = {
            active = {virt_text = {{"●", "GruvboxOrange"}}}
        },
        [require("luasnip.util.types").insertNode] = {
            active = {virt_text = {{"●", "GruvboxBlue"}}}
        }
    }
})

local current_nsid = vim.api
                         .nvim_create_namespace("LuaSnipChoiceListSelections")
local current_win = nil

local function window_for_choiceNode(choiceNode)
    local buf = vim.api.nvim_create_buf(false, true)
    local buf_text = {}
    local row_selection = 0
    local row_offset = 0
    local text
    for _, node in ipairs(choiceNode.choices) do
        text = node:get_docstring()
        -- find one that is currently showing
        if node == choiceNode.active_choice then
            -- current line is starter from buffer list which is length usually
            row_selection = #buf_text
            -- finding how many lines total within a choice selection
            row_offset = #text
        end
        vim.list_extend(buf_text, text)
    end

    vim.api.nvim_buf_set_text(buf, 0, 0, 0, 0, buf_text)
    local w, h = vim.lsp.util._make_floating_popup_size(buf_text)

    -- adding highlight so we can see which one is been selected.
    local extmark = vim.api.nvim_buf_set_extmark(buf, current_nsid,
                                                 row_selection, 0, {
        hl_group = 'incsearch',
        end_line = row_selection + row_offset
    })

    -- shows window at a beginning of choiceNode.
    local win = vim.api.nvim_open_win(buf, false, {
        relative = "win",
        width = w,
        height = h,
        bufpos = choiceNode.mark:pos_begin_end(),
        style = "minimal",
        border = 'rounded'
    })

    -- return with 3 main important so we can use them again
    return {win_id = win, extmark = extmark, buf = buf}
end

function choice_popup(choiceNode)
    -- build stack for nested choiceNodes.
    if current_win then
        vim.api.nvim_win_close(current_win.win_id, true)
        vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid,
                                     current_win.extmark)
    end
    local create_win = window_for_choiceNode(choiceNode)
    current_win = {
        win_id = create_win.win_id,
        prev = current_win,
        node = choiceNode,
        extmark = create_win.extmark,
        buf = create_win.buf
    }
end

function update_choice_popup(choiceNode)
    vim.api.nvim_win_close(current_win.win_id, true)
    vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid,
                                 current_win.extmark)
    local create_win = window_for_choiceNode(choiceNode)
    current_win.win_id = create_win.win_id
    current_win.extmark = create_win.extmark
    current_win.buf = create_win.buf
end

function choice_popup_close()
    vim.api.nvim_win_close(current_win.win_id, true)
    vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid,
                                 current_win.extmark)
    -- now we are checking if we still have previous choice we were in after exit nested choice
    current_win = current_win.prev
    if current_win then
        -- reopen window further down in the stack.
        local create_win = window_for_choiceNode(current_win.node)
        current_win.win_id = create_win.win_id
        current_win.extmark = create_win.extmark
        current_win.buf = create_win.buf
    end
end

vim.cmd([[
augroup choice_popup
au!
au User LuasnipChoiceNodeEnter lua choice_popup(require("luasnip").session.event_node)
au User LuasnipChoiceNodeLeave lua choice_popup_close()
au User LuasnipChangeChoice lua update_choice_popup(require("luasnip").session.event_node)
augroup END
]])
-- }}}

-- Filetypes
-- Plugin: nvim-dap {{{
require("reyu/dap")
require("which-key").register({
    ["<F2>"] = {function() require("dapui").toggle() end, "Toggle debug UI"},
    ["<F5>"] = {
        function() require("dap").continue() end, "Start/Continue debug session"
    },
    ["<F10>"] = {
        function() require("dap").step_over() end, "Run again for one step"
    },
    ["<F11>"] = {
        function() require("dap").step_into() end,
        "Step into a function or method"
    },
    ["<F12>"] = {
        function() require("dap").step_out() end,
        "Step out of a function or method"
    }
})
require("which-key").register({
    d = {
        name = "Debug",
        b = {
            function() require("dap").toggle_breakpoint() end,
            "Creates or removes a breakpoint"
        },
        B = {
            function()
                require("dap").set_breakpoint(vim.fn.input(
                                                  "Breakpoint condition: "))
            end, "Set breakpoint w/ condition"
        },
        e = {
            function() require("dap").set_exception_breakpoints() end,
            "Sets breakpoints on exceptions"
        },
        l = {
            function()
                require("dap").set_breakpoint(nil, nil, vim.fn
                                                  .input("Log point message: "))
            end, "Set LogPoint"
        },
        c = {
            function() require("dap").clear_breakpoints() end,
            "Clear all breakpoints"
        },
        r = {function() require("dap").repl.open() end, "Open a REPL"},
        R = {
            function() require("dap").run_last() end,
            "Re-runs the last debug-adapter/configuration"
        },
        s = {
            name = "Step",
            n = {
                function() require("dap").step_over() end,
                "Run again for one step"
            },
            i = {
                function() require("dap").step_into() end,
                "Step into a function or method"
            },
            o = {
                function() require("dap").step_out() end,
                "Step out of a function or method"
            },
            b = {
                function() require("dap").step_back() end, "Step one step back"
            }
        }
    }
}, {prefix = "<leader>"})
-- }}}
-- Plugin: nvim-dap-ui {{{
require("dapui").setup()
require("which-key").register({
    d = {u = {function() require("dapui").toggle() end, "Toggle DAP UI"}}
}, {prefix = "<leader>"})
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] =
    function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] =
    function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
-- }}}
-- Plugin: vim-ultest {{{
vim.g.ultest_use_pty = 1;
-- }}}
-- Plugin: vim-ledger {{{
vim.g.ledger_extra_options = '-s';
vim.g.ledger_maxwidth = 160;
vim.g.ledger_date_format = '%Y-%m-%d';

function init_ledger()
    require("which-key").register({
        t = {
            name = "Ledger Transaction",
            r = {
                function()
                    vim.call("ledger#transaction_state_set", vim.fn.line("."),
                             "*")
                end, "Reconcile transaction"
            },
            t = {
                function()
                    vim.call("ledger#transaction_state_toggle",
                             vim.fn.line('.'), ' *?!')
                end, "Toggle transaction state"
            },
            d = {
                name = "Set Transaction Date",
                p = {
                    function()
                        vim.call("ledger#transaction_date_set",
                                 vim.fn.line('.'), 'primary')
                    end, "Set today's data as primary tx date"
                },
                a = {
                    function()
                        vim.call("ledger#transaction_date_set",
                                 vim.fn.line('.'), 'auxiliary')
                    end, "Set today's data as auxiliary tx date"
                },
                u = {
                    function()
                        vim.call("ledger#transaction_date_set",
                                 vim.fn.line('.'), 'unshift')
                    end,
                    "Set current date to auxiliary, and set today as primary"
                }
            }
        },
        ["<Tab>"] = {
            function() vim.call("ledger#autocomplete_and_align") end,
            "Autocomplete or align transaction"
        }
    }, {buffer = vim.fn.bufnr()})
end
vim.cmd("autocmd BufEnter *.ldg lua init_ledger()")
-- }}}
-- Plugin: fidget-nvim {{{
require("fidget").setup {}
-- }}}
-- Plugin: octo-nvim {{{
require("octo").setup {}
-- }}}

-- General Options {{{
vim.opt.termguicolors = true
vim.cmd 'colorscheme solarized'

-- Don't use the mouse. Ever.
vim.opt.mouse = ""

-- Turn on mode lines
vim.opt.modeline = true
vim.opt.modelines = 3

-- Configure line numbers
vim.opt.number = true

-- Configure tab preferences
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0
vim.opt.expandtab = true

-- Ignore case in searching...
vim.opt.ignorecase = true
-- ...except if search string contains uppercase
vim.opt.smartcase = true

-- Split windows below, or to the right of, the current window
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Keep some context at screen edges
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5

-- Tell Vim which characters to show for expanded TABs,
-- trailing whitespace, and end-of-lines.
vim.opt.listchars = 'tab:> ,trail:-,extends:>,precedes:<,nbsp:+'
vim.opt.list = true -- Show problematic characters.

-- Also highlight all tabs and trailing whitespace characters.
vim.cmd([[
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$\|\t/
]])

-- Files, backups and undo
-- Keep backups in cache folder, so as not to clutter filesystem.

vim.opt.backup = true
vim.opt.writebackup = true
vim.opt.undofile = true
vim.opt.directory = vim.fn.stdpath("cache") .. "/other//,/tmp//"
vim.opt.backupdir = vim.fn.stdpath("cache") .. "/backups//,/tmp//"
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo//,/tmp//"
-- }}}
-- Autocommands {{{
function init_term()
    vim.cmd("setlocal nonumber norelativenumber")
    vim.cmd("setlocal signcolumn=no")
end
vim.cmd("autocmd TermOpen * lua init_term()")
-- }}}
