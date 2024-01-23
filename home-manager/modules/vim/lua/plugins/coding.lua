return {
{
        "L3MON4D3/LuaSnip",
        dependencies = {
            "rafamadriz/friendly-snippets",
            config = function()
                require("luasnip.loaders.from_lua").lazy_load()
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },
        opts = {
            history = true,
            enable_autosnippets = true,
        },
    },
    {
        "hrsh7th/nvim-cmp",
        version = false,
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-calc",
            "hrsh7th/cmp-emoji",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-omni",
            "rcarriga/cmp-dap",
            "lukas-reineke/cmp-under-comparator",
            "onsails/lspkind.nvim",
            "saadparwaiz1/cmp_luasnip",
        },
        opts = function()
            local cmp = require("cmp")
            require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
                sources = {
                    { name = "dap" },
                }
            })
            return {
                enabled = function()
                    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
                        or require("cmp_dap").is_dap_buffer()
                end,
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = { border = 'rounded' },
                    documenation = { border = 'rounded' },
                },
                mapping = cmp.mapping.preset.insert({
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if require('luasnip').expand_or_locally_jumpable() then
                            require('luasnip').expand_or_jump()
                        else
                            fallback()
                        end
                    end, {'i', 's'}),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if require('luasnip').locally_jumpable(-1) then
                            require('luasnip').jump(-1)
                        else
                            fallback()
                        end
                    end, {'i', 's'}),
                    ['<C-b>'] = cmp.mapping(function(fallback)
                        if require('luasnip').choice_active() then
                            require('luasnip').change_choice(-1)
                        elseif cmp.visible() then
                            cmp.mapping.scroll_docs(-4)
                        else
                            fallback()
                        end
                    end, {'i', 's'}),
                    ['<C-f>'] = cmp.mapping(function(fallback)
                        if require('luasnip').choice_active() then
                            require('luasnip').change_choice(1)
                        elseif cmp.visible() then
                            cmp.mapping.scroll_docs(4)
                        else
                            fallback()
                        end
                    end, {'i', 's'}),
                    ['<C-Space>'] = cmp.mapping.complete({}),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ["<C-n>"] = cmp.mapping.select_next_item({
                        behavior = cmp.SelectBehavior.Insert
                    }),
                    ['<C-p>'] = cmp.mapping.select_prev_item({
                        behavior = cmp.SelectBehavior.Insert
                    }),
                    ['<CR>'] = cmp.mapping.confirm({select = false})
                }),
                sources = cmp.config.sources({
                    {name = 'luasnip'},
                    {name = 'nvim_lsp'},
                    {name = 'buffer'},
                    {name = 'path'},
                },{
                    {name = 'neorg'},
                    {name = 'calc'},
                    {name = 'emoji'},
                }),
                formatting = {
                    format = function(entry, vim_item)
                        if vim.tbl_contains({'path'}, entry.source.name) then
                            local icon, hl_group =
                            require('nvim-web-devicons').get_icon(
                                entry:get_completion_item().label)
                            if icon then
                                vim_item.kind = icon
                                vim_item.kind_hl_group = hl_group
                                return vim_item
                            end
                        end
                        return
                        require('lspkind').cmp_format({with_text = true})(
                            entry, vim_item)
                    end
                },
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
                    entries = {name = 'custom', selection_order = 'near_cursor'}
                },
                experimental = {
                    ghost_text = {
                        hl_group = "LspCodeLens",
                    },
                },
            }
        end,
    }, {
        "echasnovski/mini.align",
        event = {"BufReadPost", "BufNewFile"},
        config = true;
    }, {
        "echasnovski/mini.bracketed",
        event = {"BufReadPost", "BufNewFile"},
        config = true;
    }, {
        "echasnovski/mini.bufremove",
        event = {"BufReadPost", "BufNewFile"},
        config = true;
    }, {
        "echasnovski/mini.pairs",
        event = {"BufReadPost", "BufNewFile"},
        opts = {
            mappings = {
                ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\"].', register = { cr = false } },
                ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = "[^\\'].", register = { cr = false } },
            },
        },
        config = function(_, opts) require("mini.pairs").setup(opts) end
    }, {
        "echasnovski/mini.surround",
        keys = function(_, keys)
            -- Populate the keys based on options
            local plugin =
            require("lazy.core.config").spec.plugins["mini.surround"]
            local opts = require("lazy.core.plugin").values(plugin, "opts",
                false)
            local mappings = {
                {opts.mappings.add, desc = "Add surrounding", mode = {"n", "v"}},
                {opts.mappings.delete, desc = "Delete surrounding"},
                {opts.mappings.find, desc = "Find right surrounding"},
                {opts.mappings.find_left, desc = "Find left surrounding"},
                {opts.mappings.highlight, desc = "Highlight surrounding"},
                {opts.mappings.replace, desc = "Replace surrounding"},
                {
                    opts.mappings.update_n_lines,
                    desc = "Update `MiniSurround.config.n_lines`"
                }
            }
            mappings = vim.tbl_filter(function(m)
                return m[1] and #m[1] > 0
            end, mappings)
            return vim.list_extend(mappings, keys)
        end,
        opts = {
            mappings = {
                add = "sa", -- Add surrounding in Normal and Visual modes
                delete = "sd", -- Delete surrounding
                find = "sf", -- Find surrounding (to the right)
                find_left = "sF", -- Find surrounding (to the left)
                highlight = "sh", -- Highlight surrounding
                replace = "sr", -- Replace surrounding
                update_n_lines = "sn" -- Update `n_lines`
            }
        },
        config = function(_, opts) require("mini.surround").setup(opts) end
    }, {
        "echasnovski/mini.comment",
        event = {"BufReadPost", "BufNewFile"},
        opts = {
            hooks = {
                pre = function()
                    require("ts_context_commentstring.internal").update_commentstring({})
                end
            }
        },
        config = function(_, opts) require("mini.comment").setup(opts) end
    }, {
        "echasnovski/mini.ai",
        event = {"BufReadPost", "BufNewFile"},
        dependencies = {"nvim-treesitter-textobjects"},
        opts = function()
            local ai = require("mini.ai")
            return {
                n_lines = 500,
                custom_textobjects = {
                    o = ai.gen_spec.treesitter({
                        a = {
                            "@block.outer", "@conditional.outer", "@loop.outer"
                        },
                        i = {
                            "@block.inner", "@conditional.inner", "@loop.inner"
                        }
                    }, {}),
                    f = ai.gen_spec.treesitter({
                        a = "@function.outer",
                        i = "@function.inner"
                    }, {}),
                    c = ai.gen_spec.treesitter({
                        a = "@class.outer",
                        i = "@class.inner"
                    }, {})
                }
            }
        end,
        config = function(_, opts)
            require("mini.ai").setup(opts)
            if not vim.g.started_by_firenvim then
                -- register all text objects with which-key
                local i = {
                    [" "] = "Whitespace",
                    ['"'] = 'Balanced "',
                    ["'"] = "Balanced '",
                    ["`"] = "Balanced `",
                    ["("] = "Balanced (",
                    [")"] = "Balanced ) including white-space",
                    [">"] = "Balanced > including white-space",
                    ["<lt>"] = "Balanced <",
                    ["]"] = "Balanced ] including white-space",
                    ["["] = "Balanced [",
                    ["}"] = "Balanced } including white-space",
                    ["{"] = "Balanced {",
                    ["?"] = "User Prompt",
                    _ = "Underscore",
                    a = "Argument",
                    b = "Balanced ), ], }",
                    c = "Class",
                    f = "Function",
                    o = "Block, conditional, loop",
                    q = "Quote `, \", '",
                    t = "Tag"
                }
                local a = vim.deepcopy(i)
                for k, v in pairs(a) do a[k] = v:gsub(" including.*", "") end

                local ic = vim.deepcopy(i)
                local ac = vim.deepcopy(a)
                local _i = {}
                local _a = {}
                for key, name in pairs({n = "Next", l = "Last"}) do
                    _i[key] = vim.tbl_extend("force", {
                        name = "Inside " .. name .. " textobject"
                    }, ic)
                    _a[key] = vim.tbl_extend("force", {
                        name = "Around " .. name .. " textobject"
                    }, ac)
                end
                if not vim.g.started_by_firenvim then
                    require("which-key").register({mode = {"o", "x"}, i = _i, a = _a})
                end
            end
        end
    },
    {
        "danymat/neogen",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
                opts = function(_, opts)
                    local ei = opts.ensure_installed or {}
                    vim.list_extend(ei, {'neogen'})
                    opts.ensure_installed = ei
                    return opts
                end
        },
        cond = not vim.g.started_by_firenvim,
        opts = { snippet_engine = "luasnip" },
        keys = {
            {"<LocalLeader>n", desc = "+NeoGen"},
            {"<LocalLeader>nn", function () require("neogen").generate({}) end, silent = true, desc = "Generate Annotation"},
            {"<LocalLeader>nc", function () require("neogen").generate({type = "class"}) end, silent = true, desc = "Generate Class Annotation"},
            {"<LocalLeader>nf", function () require("neogen").generate({type = "func"}) end, silent = true, desc = "Generate Function Annotation"},
        }
    },
}
