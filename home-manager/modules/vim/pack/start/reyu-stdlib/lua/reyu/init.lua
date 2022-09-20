-- ############# --
-- NeoVim Config --
-- ############# --

-- Plugin: NeoSolarized {{{
vim.g.NeoSolarized_italics = 1 -- 0 or 1
vim.g.NeoSolarized_visibility = "normal" -- low, normal, high
vim.g.NeoSolarized_diffmode = "normal" -- low, normal, high
vim.g.NeoSolarized_termtrans = 1 -- 0(default) or 1 -> Transparency
vim.g.NeoSolarized_lineNr = 0 -- 0 or 1 (default) -> To Show backgroung in LineNr
vim.api.nvim_set_option_value("termguicolors", true, {})
vim.cmd([[
    colorscheme NeoSolarized
    " highlight FloatBorder guibg=NONE ctermbg=NONE
    " highlight NormalFloat ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
    highlight Pmenu ctermbg=NONE guibg=NONE
]])
-- }}}

-- Plugin: telescope-nvim {{{
require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<C-Down>"] = require("telescope.actions").cycle_history_next,
                ["<C-Up>"] = require("telescope.actions").cycle_history_prev,
            },
        },
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
        },
    },
})

require("which-key").register({
    t = {
        name = "Telescope",
        t = { "<cmd>Telescope<CR>", "Telescope prompt" },
        c = {
            function()
                require("telescope.builtin").colorscheme({})
            end,
            "Available colorschemes",
        },
        b = {
            function()
                require("telescope.builtin").buffers({})
            end,
            "Open buffers",
        },
        m = {
            function()
                require("telescope.builtin").marks({})
            end,
            "Vim marks and their value",
        },
        r = {
            function()
                require("telescope.builtin").registers({})
            end,
            "Vim registers",
        },
        q = {
            function()
                require("telescope.builtin").quickfix({})
            end,
            "Items in the quickfix list",
        },
        l = {
            function()
                require("telescope.builtin").loclist({})
            end,
            "Items from the current window's location list",
        },
        j = {
            function()
                require("telescope.builtin").jumplist({})
            end,
            "Jump List entries",
        },
        h = {
            function()
                require("telescope").extensions.hoogle.hoogle()
            end,
            "Live Hoogle Search",
        },
    },
    f = {
        name = "Find Files",
        f = {
            function()
                local ok = pcall(require("telescope.builtin").git_files)
                if not ok then
                    require("telescope.builtin").find_files()
                end
            end,
            "Files in your current working directory",
        },
        l = {
            function()
                require("telescope.builtin").live_grep({})
            end,
            "Search for a string in current working directory",
        },
    },
    g = {
        name = "Git",
        c = {
            function()
                require("telescope.builtin").git_commits({})
            end,
            "Lists git commits with diff preview",
        },
        d = {
            function()
                require("telescope.builtin").git_bcommits({})
            end,
            "Lists buffer's git commits with diff",
        },
        b = {
            function()
                require("telescope.builtin").git_branches({})
            end,
            "Lists all branches with log preview",
        },
        s = { "<CMD>Git<CR>", "Fugitive git status" },
        x = {
            function()
                require("telescope.builtin").git_stash({})
            end,
            "Lists stash items in current repository",
        },
        ["<SPACE>"] = { ":Git ", "Run Git command" },
    },
}, { mode = "n", prefix = "<leader>" })
-- }}}

-- Plugin: telescope-hoogle {{{
require("telescope").load_extension("hoogle")

-- }}}

-- Plugin: treesitter {{{
require("nvim-treesitter.configs").setup({
    context_commentstring = { enable = true },
    endwise = { enable = true },
    highlight = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            scope_incremental = "grs",
            node_incremental = "grn",
            node_decremental = "grm",
        },
    },
    indent = { enable = true },
})
vim.api.nvim_set_option("foldmethod", "expr")
vim.api.nvim_set_option("foldexpr", "nvim_treesitter#foldexpr()")
-- }}}

-- Plugin: lualine-nvim {{{
require("reyu/lualine")
-- }}}

-- Plugin: mini.nvim {{{
require("mini.ai").setup()
require("mini.bufremove").setup()
require("mini.comment").setup()
require("mini.jump").setup()
require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.trailspace").setup()

local session_dir = vim.fn.stdpath("data") .. "/session"
vim.pretty_print("Session dir is: " .. session_dir)
if vim.fn.isdirectory(session_dir) == 0 then
    vim.pretty_print("Creating session dir!")
    vim.fn.mkdir(session_dir, "p")
end
require("mini.sessions").setup({
    directory = session_dir
})

local starter = require("mini.starter")
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
        starter.sections.sessions(),
        starter.sections.builtin_actions(),
        starter.sections.telescope(),
    },
    content_hooks = {
        starter.gen_hook.adding_bullet(),
        starter.gen_hook.aligning("center", "center"),
    },
})


require("which-key").register({
    s = {
        name = "Sessions",
        s = {
            function() require("mini.sessions").select("read", {}) end,
            "Select Session"
        },
        w = {
            function()
                if vim.v.this_session == "" then
                    local name = vim.fn.input({
                        prompt = "Session name: "
                    })
                    require("mini.sessions").write(name, {verbose = false})
                else
                    require("mini.sessions").write(nil, {})
                end
            end,
            "Write session"
        },
    },
}, { mode = "n", prefix = "<Leader>" })
-- }}}

-- Plugin: tmux-navigator {{{
vim.api.nvim_set_var("tmux_navigator_disable_when_zoomed", true)
vim.api.nvim_set_var("tmux_navigator_no_mappings", true)

-- Normal mode
require("which-key").register({
    ["<A-h>"] = {
        function()
            vim.api.nvim_cmd({ cmd = "TmuxNavigateLeft" }, {})
        end,
        "Navigate left one window (vim) or pane (tmux)",
    },
    ["<A-l>"] = {
        function()
            vim.api.nvim_cmd({ cmd = "TmuxNavigateRight" }, {})
        end,
        "Navigate right one window (vim) or pane (tmux)",
    },
    ["<A-j>"] = {
        function()
            vim.api.nvim_cmd({ cmd = "TmuxNavigateDown" }, {})
        end,
        "Navigate down one window (vim) or pane (tmux)",
    },
    ["<A-k>"] = {
        function()
            vim.api.nvim_cmd({ cmd = "TmuxNavigateUp" }, {})
        end,
        "Navigate up one window (vim) or pane (tmux)",
    },
    ["<A-p>"] = {
        function()
            vim.api.nvim_cmd({ cmd = "TmuxNavigatePrevious" }, {})
        end,
        "Navigate to previous window (vim) or pane (tmux)",
    },
}, { mode = "n" })

-- Terminal Mode
require("which-key").register({
    ["<A-h>"] = {
        function()
            vim.api.nvim_cmd({ cmd = "TmuxNavigateLeft" }, {})
        end,
        "Navigate left one window (vim) or pane (tmux)",
    },
    ["<A-l>"] = {
        function()
            vim.api.nvim_cmd({ cmd = "TmuxNavigateRight" }, {})
        end,
        "Navigate right one window (vim) or pane (tmux)",
    },
    ["<A-j>"] = {
        function()
            vim.api.nvim_cmd({ cmd = "TmuxNavigateDown" }, {})
        end,
        "Navigate down one window (vim) or pane (tmux)",
    },
    ["<A-k>"] = {
        function()
            vim.api.nvim_cmd({ cmd = "TmuxNavigateUp" }, {})
        end,
        "Navigate up one window (vim) or pane (tmux)",
    },
}, { mode = "t" })
-- }}}

-- Plugin: FixCursorHold-nvim {{{
vim.api.nvim_set_var("cursorhold_updatetime", 100)
-- }}}

-- Plugin: neoscroll-nvim {{{
require("neoscroll").setup({ easing_function = "quadratic" })
-- }}}

-- Plugin: nvim-tree-lua {{{
require("nvim-tree").setup({ renderer = { highlight_git = true }, view = { width = 40 } })
require("which-key").register({
    n = { -- "t" is used by Telescope
        name = "NvimTree",
        n = {
            function() require("nvim-tree").toggle() end,
            "Toggle NvimTree"
        },
        o = {
            function() require("nvim-tree").open() end,
            "Open NvimTree"
        },
        f = {
            function() require("nvim-tree").focus() end,
            "Focus NvimTree"
        },
        h = {
            function() require("nvim-tree").find_file() end,
            'Find current file in tree'
        },
    },
}, {mode = "n", prefix = "<Leader>" })
-- }}}

-- Plugin: gitsigns-nvim {{{
require("gitsigns").setup()
-- }}}

-- Plugin: octo-nvim {{{
require("octo").setup()
-- }}}

-- Plugin: easy-align {{{
require("which-key").register({
    ga = {
        "<Plug>(EasyAlign)",
        "Start EasyAlign in visual mode",
    },
}, { mode = "n" })
require("which-key").register({
    ga = {
        "<Plug>(EasyAlign)",
        "Start EasyAlign for a motion/text object",
    },
}, { mode = "x" })
require("which-key").register({
    ["<CR>"] = {
        "<Plug>(LiveEasyAlign)",
        "Start interactive EasyAlign for a motion/text object",
    },
}, { mode = "v" })
-- }}}

-- Plugin: netman {{{
require("netman")
-- }}}

-- Plugin: telescope-ui-select-nvim {{{
require("telescope").load_extension("ui-select")
-- }}}

-- Plugin: lsp_lines {{{
vim.diagnostic.config({ virtual_text = false })
require("lsp_lines").setup()
require("which-key").register({
    l = {
        function()
            require("lsp_lines").toggle()
        end,
        "Toggle lsp_lines",
    },
}, { prefix = "<space>" })
-- }}}

-- Plugin: zen-mode {{{
require("zen-mode").setup({
    window = {
        backdrop = 1,
        width = 120, -- width of the Zen window
        height = 1, -- height of the Zen window
        options = {
            number = false, -- disable number column
            relativenumber = true, -- disable relative numbers
            cursorline = false, -- disable cursorline
            cursorcolumn = false, -- disable cursor column
        },
    },
})
vim.api.nvim_set_keymap("n", "<Leader>z", [[<CMD>lua require("zen-mode").toggle()<CR>]], { desc = "Zen Mode" })
-- }}}

-- Plugin: twilight-nvim {{{
require("twilight").setup({
    dimming = {
        alpha = 0.25,
        inactive = true,
    },
    context = 6,
    treesitter = true,
    expand = {
        "function",
        "method",
        "table",
        "if_statement",
    },
})
-- }}}

-- Plugin: trouble-nvim {{{
require("trouble").setup({
    auto_open = false,
    auto_close = true,
    use_diagnostic_signs = true,
})
require("which-key").register({
    x = {
        name = "Troubleshooting",
        a = {
            function() require("trouble").action() end,
            "Troubleshoot Action"
        },
        c = {
            function() require("trouble").close() end,
            "Close Trouble Window"
        },
        d = {
            "<CMD>Trouble document_diagnostics<CR>",
            "Document diagnostics"
        },
        n = {
            function() require("trouble").next() end,
            "Next Item"
        },
        o = {
            function() require("trouble").open() end,
            "Open Trouble Window"
        },
        p = {
            function() require("trouble").prev() end,
            "Previous Item"
        },
        r = {
            function() require("trouble").refresh() end,
            "Refresh Troubleshooting"
        },
        w = {
            "<CMD>Trouble workspace_diagnostics<CR>",
            "Workspace diagnostics"
        },
        x = {
            function() require("trouble").toggle() end,
            "Toggle Troubleshooting Window"
        },
    },
}, {mode = "n", prefix = "<Space>" })
-- }}}

-- Plugin: nvim-ufo {{{
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
-- vim.o.foldoptions = "nodigits"
vim.o.foldcolumn = "1"
require("ufo").setup({
    provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
    end,
})
-- }}}

-- Plugin: treesitter-context {{{
require("treesitter-context").setup()
-- }}}

-- Plugin: aerial-nvim {{{
require("aerial").setup()
-- }}}

-- Plugin: stickybuf-nvim {{{
require("stickybuf").setup()
-- }}}

-- Plugin: nvim-notify {{{
vim.notify = require("notify")
require("notify").setup({
  background_colour = "#000000",
})
-- }}}

-- Plugin: nvim-bqf {{{
function _G.qftf(info)
    local items
    local ret = {}
    if info.quickfix == 1 then
        items = vim.fn.getqflist({ id = info.id, items = 0 }).items
    else
        items = vim.fn.getloclist(info.winid, { id = info.id, items = 0 }).items
    end
    local limit = 31
    local fnameFmt1, fnameFmt2 = "%-" .. limit .. "s", "…%." .. (limit - 1) .. "s"
    local validFmt = "%s │%5d:%-3d│%s %s"
    for i = info.start_idx, info.end_idx do
        local e = items[i]
        local fname = ""
        local str
        if e.valid == 1 then
            if e.bufnr > 0 then
                fname = vim.fn.bufname(e.bufnr)
                if fname == "" then
                    fname = "[No Name]"
                else
                    fname = fname:gsub("^" .. vim.env.HOME, "~")
                end
                -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
                if #fname <= limit then
                    fname = fnameFmt1:format(fname)
                else
                    fname = fnameFmt2:format(fname:sub(1 - limit))
                end
            end
            local lnum = e.lnum > 99999 and -1 or e.lnum
            local col = e.col > 999 and -1 or e.col
            local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper()
            str = validFmt:format(fname, lnum, col, qtype, e.text)
        else
            str = e.text
        end
        table.insert(ret, str)
    end
    return ret
end

vim.o.qftf = "{info -> v:lua._G.qftf(info)}"

-- Adapt fzf's delimiter in nvim-bqf
require("bqf").setup({
    filter = {
        fzf = {
            extra_opts = { "--bind", "ctrl-o:toggle-all", "--delimiter", "│" },
        },
    },
})
-- }}}

-- Plugin: neogen {{{
require("neogen").setup({ snippet_engine = "luasnip" })
require("which-key").register({
    a = {
        name = "Annotate",
        a = {
            function()
                require("neogen").generate()
            end,
            "Automatic Annotaiton",
        },
        c = {
            function()
                require("neogen").generate({ type = "func" })
            end,
            "Annotate Class ",
        },
        f = {
            function()
                require("neogen").generate({ type = "class" })
            end,
            "Annotate Func",
        },
        t = {
            function()
                require("neogen").generate({ type = "type" })
            end,
            "Annotate Type",
        },
    },
}, { mode = "n", prefix = "<Leader>" })
-- }}}

-- Plugin: hydra-nvim {{{
require("reyu/hydra")
-- }}}

-- Completion

-- Plugin: nvim-lspconfig {{{
require("reyu/lsp_config")
-- }}}

-- Plugin: nvim-cmp {{{
local cmp = require("cmp")
local lsnip = require("luasnip")
cmp.setup({
    formatting = { format = require("lspkind").cmp_format() },
    snippet = {
        expand = function(args)
            lsnip.lsp_expand(args.body)
        end,
    },
    mapping = {
        ["<C-n>"] = cmp.mapping({
            c = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    cmp.complete()
                end
            end,
            i = function(fallback)
                if lsnip.choice_active() then
                    lsnip.change_choice(1)
                elseif cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    fallback()
                end
            end,
        }),
        ["<C-p>"] = cmp.mapping({
            c = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    cmp.complete()
                end
            end,
            i = function(fallback)
                if lsnip.choice_active() then
                    lsnip.change_choice(-1)
                elseif cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    fallback()
                end
            end,
        }),
        ["<C-u>"] = cmp.mapping(function(fallback)
            if lsnip.choice_active() then
                require("luasnip.extras.select_choice")
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<Tab>"] = cmp.mapping({
            c = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                else
                    fallback()
                end
            end,
            i = function(fallback)
                if require("luasnip").expand_or_locally_jumpable() then
                    require("luasnip").expand_or_jump()
                elseif cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
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
            end,
        }),
        ["<S-Tab>"] = cmp.mapping({
            c = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                else
                    fallback()
                end
            end,
            i = function(fallback)
                if require("luasnip").jumpable(-1) then
                    require("luasnip").jump(-1)
                elseif cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
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
            end,
        }),
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ["<CR>"] = cmp.mapping(
            cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = false,
            }),
            { "i" }
        ),
    },
    sources = cmp.config.sources({
        { name = "vim-dadbod-completion" },
        { name = "nvim_lsp_signature_help" },
    }, {
        { name = "calc" },
        { name = "emoji" },
        { name = "latex_symbols" },
    }, {
        { name = "luasnip" },
        { name = "nvim_lsp" },
    }, {
        { name = "treesitter" },
        { name = "buffer" },
    }),
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources(
        { { name = "conventionalcommits" }, { name = "cmp_git" } },
        { { name = "latex_symbols" }, { name = "emoji" }, { name = "calc" }, { name = "buffer" } }
    ),
})
-- Use buffer source for `/`
cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = "buffer" } },
})

-- Use cmdline & path source for ':'
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
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
        null_ls.builtins.formatting.trim_newlines,
        null_ls.builtins.formatting.trim_whitespace,
    },
})
-- }}}

-- Plugin: luasnip {{{
require("luasnip").config.setup({})
require("luasnip.loaders.from_lua").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load()
-- }}}

-- Plugin: fidget-nvim {{{
require("fidget").setup({
    window = {
        blend = 0,
    },
})
-- }}}

-- Filetypes

-- Plugin: vim-ledger {{{
vim.api.nvim_set_var("ledger_extra_options", "-s")
vim.api.nvim_set_var("ledger_maxwidth", 160)
vim.api.nvim_set_var("ledger_date_format", "%Y-%m-%d")

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.ldg",
    callback = function()
        require("which-key").register({
            t = {
                name = "Ledger Transaction",
                r = {
                    function()
                        vim.call("ledger#transaction_state_set", vim.fn.line("."), "*")
                    end,
                    "Reconcile transaction",
                },
                t = {
                    function()
                        vim.call("ledger#transaction_state_toggle", vim.fn.line("."), " *?!")
                    end,
                    "Toggle transaction state",
                },
                d = {
                    name = "Set Transaction Date",
                    p = {
                        function()
                            vim.call("ledger#transaction_date_set", vim.fn.line("."), "primary")
                        end,
                        "Set today's data as primary tx date",
                    },
                    a = {
                        function()
                            vim.call("ledger#transaction_date_set", vim.fn.line("."), "auxiliary")
                        end,
                        "Set today's data as auxiliary tx date",
                    },
                    u = {
                        function()
                            vim.call("ledger#transaction_date_set", vim.fn.line("."), "unshift")
                        end,
                        "Set current date to auxiliary, and set today as primary",
                    },
                },
            },
            ["<Tab>"] = {
                function()
                    vim.call("ledger#autocomplete_and_align")
                end,
                "Autocomplete or align transaction",
            },
        }, { buffer = vim.fn.bufnr() })
    end,
})
-- }}}

-- Testing

-- Plugin: neotest {{{
require("neotest").setup({
    adapters = {
        require("neotest-python")({ dap = { justMyCode = true } }),
        require("neotest-vim-test")({ ignore_file_types = { "python", "vim", "lua" } }),
    },
})
require("which-key").register({
    name = "Tests",
    ["a"] = {
        function()
            require("neotest").run.run({ suite = true })
        end,
        "Run entire test suite",
    },
    ["n"] = {
        function()
            require("neotest").run.run()
        end,
        "Run the nearest test",
    },
    ["f"] = {
        function()
            require("neotest").run.run(vim.fn.expand("%"))
        end,
        "Run the current file",
    },
    ["d"] = {
        function()
            require("neotest").run.run({ strategy = "dap" })
        end,
        "Debug the nearest test",
    },
    ["s"] = {
        function()
            require("neotest").run.stop()
        end,
        "Stop nearest test",
    },
    ["r"] = {
        function()
            require("neotest").run.run_last()
        end,
        "Re-run the last test",
    },
    ["o"] = {
        function()
            require("neotest").output.open()
        end,
        "Display test output",
    },
    ["t"] = {
        function()
            require("neotest").summary.toggle()
        end,
        "Toggle summary window",
    },
    ["m"] = {
        function()
            require("neotest").summary.run_marked()
        end,
        "Run marked tests in summary window",
    },
    ["<S-m>"] = {
        function()
            require("neotest").summary.run_marked()
        end,
        "Clear marked tests in summary window",
    },
}, { prefix = "<SPACE>t" })
require("which-key").register({
    ["]t"] = {
        function()
            require("neotest").jump.next({ status = "failed" })
        end,
        "Jump to next failing test",
    },
    ["[t"] = {
        function()
            require("neotest").jump.prev({ status = "failed" })
        end,
        "Jump to prev failing test",
    },
})
-- }}}

-- Plugin: nvim-dap {{{
require("reyu/dap")
require("which-key").register({
    ["<F2>"] = {
        function()
            require("dapui").toggle()
        end,
        "Toggle debug UI",
    },
    ["<F5>"] = {
        function()
            require("dap").continue()
        end,
        "Start/Continue debug session",
    },
    ["<F10>"] = {
        function()
            require("dap").step_over()
        end,
        "Run again for one step",
    },
    ["<F11>"] = {
        function()
            require("dap").step_into()
        end,
        "Step into a function or method",
    },
    ["<F12>"] = {
        function()
            require("dap").step_out()
        end,
        "Step out of a function or method",
    },
})
require("which-key").register({
    d = {
        name = "Debug",
        b = {
            function()
                require("dap").toggle_breakpoint()
            end,
            "Creates or removes a breakpoint",
        },
        B = {
            function()
                require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end,
            "Set breakpoint w/ condition",
        },
        e = {
            function()
                require("dap").set_exception_breakpoints()
            end,
            "Sets breakpoints on exceptions",
        },
        l = {
            function()
                require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
            end,
            "Set LogPoint",
        },
        c = {
            function()
                require("dap").clear_breakpoints()
            end,
            "Clear all breakpoints",
        },
        r = {
            function()
                require("dap").repl.open()
            end,
            "Open a REPL",
        },
        R = {
            function()
                require("dap").run_last()
            end,
            "Re-runs the last debug-adapter/configuration",
        },
        s = {
            name = "Step",
            n = {
                function()
                    require("dap").step_over()
                end,
                "Run again for one step",
            },
            i = {
                function()
                    require("dap").step_into()
                end,
                "Step into a function or method",
            },
            o = {
                function()
                    require("dap").step_out()
                end,
                "Step out of a function or method",
            },
            b = {
                function()
                    require("dap").step_back()
                end,
                "Step one step back",
            },
        },
    },
}, { prefix = "<leader>" })
-- }}}

-- Plugin: nvim-dap-ui {{{
require("dapui").setup()
require("which-key").register({
    d = { u = {
        function()
            require("dapui").toggle()
        end,
        "Toggle DAP UI",
    } },
}, { prefix = "<leader>" })
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end
-- }}}

-- Plugin: nvim-dap-virtual-text {{{
require("nvim-dap-virtual-text").setup()
-- }}}

-- Plugin: mind.nvim {{{
require("mind").setup()
-- }}}

-- Plugin: toggleterm.nvim {{{
require("toggleterm").setup({
    open_mapping = [[<C-\>]],
    direction = 'float',
    winbar = {
        enable = true,
    },
    float_opts = {
        border = 'curved',
    }
})
-- }}}

-- General Options {{{

-- Don't use the mouse. Ever.
vim.api.nvim_set_option_value("mouse", "", {})

-- Turn on mode lines
vim.api.nvim_set_option_value("modeline", true, {})
vim.api.nvim_set_option_value("modelines", 3, {})

-- Show the first layer of folds by default
vim.api.nvim_set_option_value("foldlevel", 1, {})

-- Show the cursorline, so I don't get lost
vim.api.nvim_set_option_value("cursorline", true, {})

-- Configure line numbers
vim.api.nvim_set_option_value("number", true, {})

-- Configure tab preferences
vim.api.nvim_set_option_value("tabstop", 4, {})
vim.api.nvim_set_option_value("shiftwidth", 0, {})
vim.api.nvim_set_option_value("expandtab", true, {})

-- Ignore case in searching...
vim.api.nvim_set_option_value("ignorecase", true, {})
-- ...except if search string contains uppercase
vim.api.nvim_set_option_value("smartcase", true, {})

-- Split windows below, or to the right of, the current window
vim.api.nvim_set_option_value("splitbelow", true, {})
vim.api.nvim_set_option_value("splitright", true, {})

-- Keep some context at screen edges
vim.api.nvim_set_option_value("scrolloff", 5, {})
vim.api.nvim_set_option_value("sidescrolloff", 5, {})

-- Tell Vim which characters to show for expanded TABs,
-- trailing whitespace, and end-of-lines.
vim.api.nvim_set_option_value("listchars", "tab:> ,trail:-,extends:>,precedes:<,nbsp:+", {})
vim.api.nvim_set_option_value("list", true, {}) -- Show problematic characters.

-- Files, backups and undo
-- Keep backups in cache folder, so as not to clutter filesystem.
vim.api.nvim_set_option_value("backup", true, {})
vim.api.nvim_set_option_value("writebackup", true, {})
vim.api.nvim_set_option_value("undofile", true, {})

vim.api.nvim_set_option_value("directory", vim.fn.stdpath("cache") .. "/swap//", {})
vim.api.nvim_set_option_value("backupdir", vim.fn.stdpath("cache") .. "/backups//", {})
vim.api.nvim_set_option_value("undodir", vim.fn.stdpath("state") .. "/undo//", {})
-- }}}
-- Autocommands {{{
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = { "*" },
    callback = function()
        vim.api.nvim_win_set_option(0, "number", false)
        vim.api.nvim_win_set_option(0, "relativenumber", false)
    end,
})
-- }}}
