local cmp = require('cmp')
local lsnip = require("luasnip")
require('cmp_pandoc').setup()

cmp.setup({
    snippet = {
        expand = function(args)
            lsnip.lsp_expand(args.body)
        end
    },
    window = {
        completion = cmp.config.window.bordered(),
        documenation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete({}),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif lsnip.expand_or_jumpable() then
                lsnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif lsnip.jumpable(-1) then
                lsnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' })
    }),
    sources = cmp.config.sources(
        {
            { name = 'vim-dadbod-completion' },
            { name = 'luansip' },
            { name = 'calc', },
        }, {
            { name = 'nvim_lsp' },
            { name = 'nvim_lua' },
            { name = 'buffer' },
            { name = 'tmux' },
        }, {
            { name = 'latex_symbols' },
            { name = 'emoji' },
        }, {
            { name = 'treesitter' },
            { name = 'dictionary' },
        }
    ),
    sorting = {
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            require("cmp-under-comparator").under,
            cmp.config.compare.sort_text,
            cmp.config.compare.kind,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
    view = {
        entries = { name = 'custom', selection_order = 'near_cursor' },
    },
    formatting = {
        format = function(entry, vim_item)
            if vim.tbl_contains({ 'path' }, entry.source.name) then
                local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
                if icon then
                    vim_item.kind = icon
                    vim_item.kind_hl_group = hl_group
                    return vim_item
                end
            end
            return require('lspkind').cmp_format({ with_text = true })(entry, vim_item)
        end
    }
})

cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'conventionalcommits' },
        { name = 'git' }
    }, {
        { name = 'latex_symbols' },
        { name = 'greek' },
        { name = 'emoji' },
        { name = 'calc' },
        { name = 'buffer' },
        { name = 'tmux' },
    }),
})

cmp.setup.filetype({ 'dap-repl', 'dapui_watches', 'dapui_hover' }, {
  sources = {
    { name = 'dap' },
  },
})

-- Use buffer source for `/`
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'nvim_lsp_document_symbol' }
    }, {
        { name = 'buffer' }
    },
})
