-- #############
-- NeoVim Config
-- #############
require("impatient")

local wk = require("which-key")
local mappings = {}

-- Plugin telescope-nvim {{{
require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<C-Down>"] = require("telescope.actions").cycle_history_next,
                ["<C-Up>"] = require("telescope.actions").cycle_history_prev,
            },
        },
    },
})

local tb = require("telescope.builtin")
wk.register({
    t = {
        name = "Telescope",
        t = { "<cmd>Telescope<space>", "Telescope prompt" },
        c = {
            function()
                tb.colorscheme({})
            end,
            "Available colorschemes",
        },
        b = {
            function()
                tb.buffers({})
            end,
            "Open buffers",
        },
        m = {
            function()
                tb.marks({})
            end,
            "Vim marks and their value",
        },
        r = {
            function()
                tb.registers({})
            end,
            "Vim registers",
        },
        q = {
            function()
                tb.quickfix({})
            end,
            "Items in the quickfix list",
        },
        l = {
            function()
                tb.loclist({})
            end,
            "Items from the current window's location list",
        },
        j = {
            function()
                tb.jumplist({})
            end,
            "Jump List entries",
        },
    },
    f = {
        name = "Find Files",
        f = {
            function()
              local ok = pcall(tb.git_files)
              if not ok then
                tb.find_files()
              end
            end,
            "Files in your current working directory",
        },
        l = {
            function()
                tb.live_grep({})
            end,
            "Search for a string in current working directory",
        },
    },
    g = {
        name = "Git",
        c = {
            function()
                tb.git_commits({})
            end,
            "Lists git commits with diff preview",
        },
        d = {
            function()
                tb.git_bcommits({})
            end,
            "Lists buffer's git commits with diff",
        },
        b = {
            function()
                tb.git_branches({})
            end,
            "Lists all branches with log preview",
        },
        s = {
            function()
                tb.git_status({})
            end,
            "Lists current changes per file with diff preview",
        },
        x = {
            function()
                tb.git_stash({})
            end,
            "Lists stash items in current repository",
        },
    },
}, { mode = "n", prefix = "<leader>" })
-- }}}
-- Plugin: telescope-hoogle {{{
require('telescope').load_extension('hoogle')
-- }}}
-- Plugin: galaxyline-nvim {{{
require("reyu/galaxyline")

-- }}}
-- Plugin: dashboard-nvim {{{
wk.register({
    s = {
      name = "Session",
      s = { "<cmd>SessionSave<cr>", "Save current session" },
      l = { "<cmd>SessionLoad<cr>", "Load last session" },
    },
}, { mode = "n", prefix = "<leader>" })

vim.g['dashboard_default_executive'] = 'telescope'
vim.g["dashboard_custom_header"] = {
    " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
    " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
    " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
    " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
    " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
    " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
}
vim.g["dashboard_custom_shortcut"] = {
    book_marks = "\\ t m",
    change_colorscheme = "\\ t c",
    find_file = "\\ f f",
    find_history = "\\ f h",
    find_word = "\\ f a",
    last_session = "\\ s l",
    new_file = "     ",
}
-- }}}
-- Plugin: tmux-navigator {{{
vim.g["tmux_navigator_disable_when_zoomed"] = 1
vim.g["tmux_navigator_no_mappings"] = 1

-- Normal mode
wk.register({
    ["<A-h>"] = { "<cmd>TmuxNavigateLeft<cr>", "Navigate left one window (vim) or pane (tmux)" },
    ["<A-l>"] = { "<cmd>TmuxNavigateRight<cr>", "Navigate right one window (vim) or pane (tmux)" },
    ["<A-j>"] = { "<cmd>TmuxNavigateDown<cr>", "Navigate down one window (vim) or pane (tmux)" },
    ["<A-k>"] = { "<cmd>TmuxNavigateUp<cr>", "Navigate up one window (vim) or pane (tmux)" },
    ["<A-p>"] = { "<cmd>TmuxNavigatePrevious<cr>", "Navigate to previous window (vim) or pane (tmux)" },
}, { mode = "n" })

-- Terminal Mode
wk.register({
    ["<A-h>"] = { "<cmd>TmuxNavigateLeft<cr>", "Navigate left one window (vim) or pane (tmux)" },
    ["<A-l>"] = { "<cmd>TmuxNavigateRight<cr>", "Navigate right one window (vim) or pane (tmux)" },
    ["<A-j>"] = { "<cmd>TmuxNavigateDown<cr>", "Navigate down one window (vim) or pane (tmux)" },
    ["<A-k>"] = { "<cmd>TmuxNavigateUp<cr>", "Navigate up one window (vim) or pane (tmux)" },
}, { mode = "t" })
-- }}}
-- Plugin: FixCursorHold-nvim {{{
vim.g['cursorhold_updatetime'] = 100
-- }}}
-- Plugin: vim-lion {{{
vim.g["lion_squeeze_spaces"] = 1
-- }}}
-- Plugin: vimwiki {{{
vim.g['vimwiki_filetypes'] = { 'markdown', 'pandoc' }
vim.g["vimwiki_list"] = {
  { path = "~/Notes", ext = ".md", syntax = "markdown", list_margin = 0, links_space_char = "_" },
}
-- }}}
-- Plugin: nvim-ts-context-commentstring {{{
require("nvim-treesitter.configs").setup({
    context_commentstring = {
        enable = true,
    },
})
-- }}}
-- Plugin: neoscroll-nvim {{{
require("neoscroll").setup({ easing_function = 'quadratic' })
-- }}}
-- Plugin: nvim-tree-lua {{{
vim.g['nvim_tree_git_hl'] = 1
require('nvim-tree').setup{}
-- }}}
-- Plugin: gitsigns-nvim {{{
require('gitsigns').setup()
-- }}}

-- Completion
-- Plugin: nvim-lspconfig {{{
require('reyu/lsp_config')
-- }}}
-- Plugin: nvim-cmp {{{
local cmp = require("cmp")
cmp.setup({
    formatting = {
        format = require("lspkind").cmp_format(),
    },
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = {
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = false }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = 'luasnip' },
    },
    completion = {
        completeopt = "menu,menuone,noinsert,noselect",
    },
})

-- Use buffer source for `/`
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})
-- Use cmdline & path source for ':'
-- cmp.setup.cmdline(':', {
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--     { name = 'cmdline' }
--   })
-- })
-- }}}
-- Plugin: null-ls-nvim {{{
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.code_actions.gitrebase,
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.code_actions.proselint,
    null_ls.builtins.code_actions.statix,
    null_ls.builtins.completion.luasnip,
    null_ls.builtins.diagnostics.editorconfig_checker,
    null_ls.builtins.diagnostics.gitlint,
    null_ls.builtins.diagnostics.write_good,
    null_ls.builtins.formatting.nixfmt,
    null_ls.builtins.formatting.nixpkgs_fmt,
    null_ls.builtins.formatting.trim_newlines,
    null_ls.builtins.formatting.trim_whitespace,
    null_ls.builtins.hover.dictionary,
  },
})
-- }}}

-- Filetypes
-- Plugin: nvim-dap {{{
require("reyu/dap")
local dap = require("dap")
wk.register({
    ["<F5>"] = { function() dap.continue() end, "Start/Continue debug session" },
    ["<F10>"] = { function() dap.step_over() end, "Run again for one step" },
    ["<F11>"] = { function() dap.step_into() end, "Step into a function or method" },
    ["<F11>"] = { function() dap.step_out() end, "Step out of a function or method" },
})
wk.register({
    d = {
      name = "Debug",
      b = { function() dap.toggle_breakpoint() end, "Creates or removes a breakpoint" },
      B = { function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, "Set breakpoint w/ condition" },
      e = { function() dap.set_exception_breakpoints() end, "Sets breakpoints on exceptions" },
      l = { function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, "Set LogPoint" },
      c = { function() dap.clear_breakpoints() end, "Clear all breakpoints" },
      r = { function() dap.repl.open() end, "Open a REPL" },
      R = { function() dap.run_last() end, "Re-runs the last debug-adapter/configuration" },
      s = {
        name = "Step",
        n = { function() dap.step_over() end, "Run again for one step" },
        i = { function() dap.step_into() end, "Step into a function or method" },
        o = { function() dap.step_out() end, "Step out of a function or method" },
        b = { function() dap.step_back() end, "Step one step back" },
      },
    },
}, { prefix = "<leader>" })
-- }}}
-- Plugin: nvim-dap-ui {{{
require("dapui").setup()
wk.register({ d = { u = { function() require("dapui").toggle() end, "Toggle DAP UI" } } }, { prefix = "<leader>" })
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
-- trailing whitespace, and end-of-lines. VERY useful!
-- vim.opt.listchars = 'tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+'
-- vim.opt.list = true -- Show problematic characters.

-- Also highlight all tabs and trailing whitespace characters.
--    highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
-- match ExtraWhitespace /\s\+$\|\t/

-- Files, backups and undo
-- Keep backups in cache folder, so as not to clutter filesystem.
vim.opt.directory = "~/.cache/nvim/other,~/.cache/vim/other,."
vim.opt.backupdir = "~/.cache/nvim/backup,~/.cache/vim/backup,."
vim.opt.undodir = "~/.cache/nvim/undo,~/.cache/vim/undo,."

--    autocmd BufWritePost package.yaml call Hpack()
--    function Hpack()
--      let err = system('hpack ' . expand('%'))
--      if v:shell_error
--        echo err
--      endif
--    endfunction
--}}}
-- Autocommands {{{
function init_term()
    vim.cmd("setlocal nonumber norelativenumber")
    vim.cmd("setlocal signcolumn=no")
end

-- vim.tbl_map(function(c) vim.cmd(fmt('autocmd %s', c)) end, {
-- 'FileType * set formatoptions-=o',
-- 'TermOpen * lua init_term()',
-- 'BufRead,BufEnter /var/tmp/* setlocal nobackup noundofile nowritebackup'
-- })
-- }}}
