return {
    {
        "nvim-treesitter/nvim-treesitter",
        version = false, -- last release is way too old and doesn't work on Windows
        build = ":TSUpdate",
        event = {"BufReadPost", "BufNewFile"},
        dependencies = {
            {"nvim-treesitter/nvim-treesitter-textobjects"},
            {"RRethy/nvim-treesitter-endwise"}, {
                "nvim-treesitter/nvim-treesitter-context",
                opts = {
                    enable = true,
                    max_lines = 0,
                    trim_scope = 'outer',
                    patterns = {
                        default = {
                            'class', 'function', 'method', 'for', 'while', 'if',
                            'switch', 'case'
                        }
                    }
                }
            }, {"JoosepAlviste/nvim-ts-context-commentstring"},
            {"nvim-treesitter/playground"}
        },
        keys = {
            {"<c-space>", desc = "Increment selection"},
            {"<bs>", desc = "Decrement selection", mode = "x"}
        },
        opts = {
            highlight = {enable = true},
            indent = {enable = true, disable = {"python"}},
            context_commentstring = {enable = true, enable_autocmd = false},
            endwise = {enable = true},
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = "<nop>",
                    node_decremental = "<bs>"
                }
            },
            textobjects = {
                swap = {
                    enable = true,
                    swap_next = {["<leader>a"] = "@parameter.inner"},
                    swap_previous = {["<leader>A"] = "@parameter.inner"}
                },
                lsp_interop = {
                    enable = true,
                    border = 'none',
                    peek_definition_code = {
                        ['<localleader>df'] = '@function.outer',
                        ['<localleader>dF'] = '@class.outer'
                    }
                },
                select = {
                    enable = true,
                    keymaps = {
                        ['af'] = '@function.outer',
                        ['if'] = '@function.inner',
                        ['ac'] = '@class.outer',
                        ['ic'] = '@class.inner'
                    },
                    include_surrounding_whitespace = true
                }
            },
            playground = {
                enable = true,
                disable = {},
                updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
                persist_queries = true, -- Whether the query persists across vim sessions
                keybindings = {
                    toggle_query_editor = "o",
                    toggle_hl_groups = "i",
                    toggle_injected_languages = "t",
                    toggle_anonymous_nodes = "a",
                    toggle_language_display = "I",
                    focus_language = "f",
                    unfocus_language = "F",
                    update = "R",
                    goto_node = "<cr>",
                    show_help = "?",
                },
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end
    }
}
