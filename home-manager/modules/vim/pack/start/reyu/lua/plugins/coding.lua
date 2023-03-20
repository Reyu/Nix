return {
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            {
                "rafamadriz/friendly-snippets",
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                end
            }
        },
        opts = {history = true, delete_check_events = "TextChanged"},
        keys = {
            {
                "<tab>",
                function()
                    return require("luasnip").jumpable(1) and
                               "<Plug>luasnip-jump-next" or "<tab>"
                end,
                expr = true,
                silent = true,
                mode = "i"
            }, {"<tab>", function() require("luasnip").jump(1) end, mode = "s"},
            {
                "<s-tab>",
                function() require("luasnip").jump(-1) end,
                mode = {"i", "s"}
            }
        }
    }, {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        version = false,
        dependencies = {
            {"L3MON4D3/LuaSnip"}, {"andersevenrud/cmp-tmux"}, {
                "aspeddro/cmp-pandoc.nvim",
                dependencies = {"nvim-lua/plenary.nvim"},
                config = true
            }, {"davidsierradz/cmp-conventionalcommits"},
            {"hrsh7th/cmp-buffer"}, {"hrsh7th/cmp-calc"}, {"hrsh7th/cmp-emoji"},
            {"hrsh7th/cmp-latex-symbols"}, {"hrsh7th/cmp-nvim-lsp"},
            {"hrsh7th/cmp-nvim-lsp-document-symbol"}, {"hrsh7th/cmp-nvim-lua"},
            {"lukas-reineke/cmp-under-comparator"}, {"max397574/cmp-greek"},
            {"onsails/lspkind.nvim"}, {"petertriho/cmp-git"},
            {"ray-x/cmp-treesitter"}, {"uga-rosa/cmp-dictionary"}
        },
        opts = function()
            local cmp = require("cmp")
            return {
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                snippet = {
                    expand = function(args)
                        require("luansip").lsp_expand(args.body)
                    end
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documenation = cmp.config.window.bordered()
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete({}),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ["<C-n>"] = cmp.mapping.select_next_item({
                        behavior = cmp.SelectBehavior.Insert
                    }),
                    ["<C-p>"] = cmp.mapping.select_prev_item({
                        behavior = cmp.SelectBehavior.Insert
                    }),
                    ['<CR>'] = cmp.mapping.confirm({select = false}),
                    ["<S-CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true
                    })
                }),
                sources = cmp.config.sources({
                    {name = 'vim-dadbod-completion'}, {name = 'calc'}
                }, {
                    {name = 'neorg'}, {name = 'nvim_lsp'}, {name = 'luansip'},
                    {name = 'nvim_lua'}, {name = 'buffer'}, {name = 'tmux'},
                }, {{name = 'latex_symbols'}, {name = 'emoji'}}, {
                    {name = 'treesitter'}, {name = 'dictionary'},
                }),
                sorting = {
                    comparators = {
                        cmp.config.compare.offset, cmp.config.compare.exact,
                        cmp.config.compare.score,
                        require("cmp-under-comparator").under,
                        cmp.config.compare.sort_text, cmp.config.compare.kind,
                        cmp.config.compare.length, cmp.config.compare.order
                    }
                },
                view = {
                    entries = {name = 'custom', selection_order = 'near_cursor'}
                },
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
                experimental = {ghost_text = {hl_group = "LspCodeLens"}}
            }
        end
    }, {
        "echasnovski/mini.pairs",
        event = "VeryLazy",
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
        event = "VeryLazy",
        opts = {
            hooks = {
                pre = function()
                    require("ts_context_commentstring.internal").update_commentstring(
                        {})
                end
            }
        },
        config = function(_, opts) require("mini.comment").setup(opts) end
    }, {
        "echasnovski/mini.ai",
        event = "VeryLazy",
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
            for key, name in pairs({n = "Next", l = "Last"}) do
                i[key] = vim.tbl_extend("force", {
                    name = "Inside " .. name .. " textobject"
                }, ic)
                a[key] = vim.tbl_extend("force", {
                    name = "Around " .. name .. " textobject"
                }, ac)
            end
            require("which-key").register({mode = {"o", "x"}, i = i, a = a})
        end
    },
    {
        "tpope/vim-projectionist",
        lazy = false,
    },
}
