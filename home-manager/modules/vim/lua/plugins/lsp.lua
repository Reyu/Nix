local map = function(mode, lhs, rhs, extra_opts, bufnr)
    local _opts = vim.tbl_extend('keep', extra_opts or {}, {
        buffer = bufnr,
        noremap = true,
        silent = true
    })
    vim.keymap.set(mode, lhs, rhs, _opts)
end

local function preview_location_callback(_, result)
    if result == nil or vim.tbl_isempty(result) then return nil end
    vim.lsp.util.preview_location(result[1], {border = "rounded"})
end

local function peekDefinition(bufnr)
    local params = vim.lsp.util.make_position_params(0, 'utf-16')
    return vim.lsp.buf_request(bufnr, 'textDocument/definition', params,
                               preview_location_callback)
end

return {
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            {'neovim/nvim-lspconfig'}, {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-nvim-lsp'}, {'L3MON4D3/LuaSnip'}
        },
        config = function()
            local lsp = require("lsp-zero").preset({
                name = "system-lsp",
                manage_nvim_cmp = false,
            })

            lsp.on_attach(function(_, bufnr)
                lsp.default_keymaps({buffer = bufnr, omit = {'K'}})

                map({'n', 'x'}, 'gq', function()
                    vim.lsp.buf.format({async = false, timeout_ms = 10000})
                end, {desc = 'Format Buffer/Selection'}, bufnr)
                map('i', 'K', function()
                    local winid = require('ufo').peekFoldedLinesUnderCursor()
                    if not winid then vim.lsp.buf.hover() end
                end, {desc = 'Show hover menu'}, bufnr)
                map('i', '<LocalLeader>p', peekDefinition,
                    {desc = 'Peek definition'}, bufnr)
                map('i', '<LocalLeader>h', function()
                    require('haskell-tools').hoogle.hoogle_signature()
                end, {desc = 'Hoogle Signature'}, bufnr)
                map('i', '<LocalLeader>ca', vim.lsp.buf.code_action,
                    {desc = 'Run code actions'}, bufnr)
                map('i', '<LocalLeader>cl', vim.lsp.codelens.run,
                    {desc = 'Run Codelens'}, bufnr)

                require('which-key').register({
                    ['<LocalLeader>c'] = {name = "+code"}
                }, {buffer = bufnr})
            end)

            lsp.set_server_config({
                capabilities = {
                    textDocument = {
                        foldingRange = {
                            dynamicRegistration = false,
                            lineFoldingOnly = true
                        }
                    }
                }
            })

            lsp.setup_servers({
                "bashls", "dockerls", "jsonls", "yamlls", "rnix",
                "terraform_lsp"
            })
            require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

            lsp.setup()
        end
    }, {
        "jose-elias-alvarez/null-ls.nvim",
        event = {"BufReadPre", "BufNewFile"},
        opts = function()
            local nls = require("null-ls")
            return {
                sources = {
                    nls.builtins.code_actions.gitsigns,
                    nls.builtins.code_actions.refactoring,
                    nls.builtins.diagnostics.commitlint,
                    nls.builtins.diagnostics.dotenv_linter,
                    nls.builtins.hover.dictionary
                }
            }
        end
    }, {
        "mrcjkb/haskell-tools.nvim",
        dependencies = {
            'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim',
            'VonHeikemen/lsp-zero.nvim'
        },
        event = {"BufReadPre", "BufNewFile"},
        opts = {
            tools = {
                hover = {stylize_markdown = true},
                definition = {hoogle_signature_fallback = true}
            }
        },
        setup = function(opts)
            local haskell_tools = require('haskell-tools')
            local hls_lsp = require('lsp-zero').build_options('hls', {})

            local hls_config = vim.tbl_extend("keep", {
                hls = {
                    capabilities = hls_lsp.capabilities,
                    on_attach = function(_, bufnr)
                        map('n', '<leader>ca', vim.lsp.codelens.run,
                            {desc = "Run Codelens"}, bufnr)
                        map('n', '<leader>hs',
                            haskell_tools.hoogle.hoogle_signature,
                            {desc = "Hoogle Signature"}, bufnr)
                        map('n', '<leader>ea', haskell_tools.lsp.buf_eval_all,
                            {desc = "Evaluate Buffer"}, bufnr)
                    end
                }
            }, opts)

            local hls_augroup = vim.api.nvim_create_augroup('haskell-lsp',
                                                            {clear = true})
            vim.api.nvim_create_autocmd('FileType', {
                group = hls_augroup,
                pattern = {'haskell'},
                callback = function(ev)
                    haskell_tools.start_or_attach(hls_config)
                    haskell_tools.dap.discover_configurations(ev.buf)
                    map('n', '<leader>rr', haskell_tools.repl.toggle,
                        {desc = 'Open REPL for package'}, ev.buf)
                    map('n', '<leader>rf', function()
                        haskell_tools.repl.toggle(vim.api.nvim_buf_get_name(0))
                    end, {desc = 'Toggle REPL for buffer'}, ev.buf)
                    map('n', '<leader>rq', haskell_tools.repl.quit,
                        {desc = 'Quit REPL'}, ev.buf)
                end
            })
        end
    }
}
