return {
    {
        "nvim-treesitter/nvim-treesitter",
        version = false, -- last release is way too old and doesn't work on Windows
        event = {"BufReadPost", "BufNewFile"},
        main = "nvim-treesitter.configs",
        dependencies = {
            {"nvim-treesitter/nvim-treesitter-textobjects"},
            {"RRethy/nvim-treesitter-endwise"}, {
                "nvim-treesitter/nvim-treesitter-context",
                opts = {
                    enabled = true,
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
            highlight = {enabled = true},
            indent = {enabled = true, disable = {"python"}},
            context_commentstring = {enabled = true, enable_autocmd = false},
            endwise = {enabled = true},
            incremental_selection = {
                enabled = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = "<M-space>",
                    node_decremental = "<bs>"
                }
            },
            textobjects = {
                swap = {
                    enabled = true,
                    swap_previous = {["<leader>A"] = "@parameter.inner"},
                    swap_next = {["<leader>a"] = "@parameter.inner"}
                },
                lsp_interop = {
                    enabled = true,
                    border = 'rounded',
                    peek_definition_code = {
                        ['<localleader>p'] = '@function.outer',
                        ['<localleader>P'] = '@class.outer'
                    }
                },
                select = {
                    enabled = true,
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
                enabled = true,
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
            }
        }
    }
}
