return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        cond = not vim.g.started_by_firenvim,
        dependencies = {
            {"nvim-lua/plenary.nvim"}, {"MunifTanjim/nui.nvim"},
            {"s1n7ax/nvim-window-picker"}, {'nvim-tree/nvim-web-devicons'}
        },
        init = function()
            vim.g.neo_tree_remove_legacy_commands = 1
            vim.fn.sign_define('DiagnosticSignError',
                               {text = '', texthl = 'DiagnosticSignError'})
            vim.fn.sign_define('DiagnosticSignWarn',
                               {text = '', texthl = 'DiagnosticSignWarn'})
            vim.fn.sign_define('DiagnosticSignInfo',
                               {text = '', texthl = 'DiagnosticSignInfo'})
            vim.fn.sign_define('DiagnosticSignHint',
                               {text = '', texthl = 'DiagnosticSignHint'})
        end,
        opts = {
            close_if_last_window = false,
            popup_border_style = 'rounded',
            enable_git_status = true,
            enable_diagnostics = true,
            sort_case_insensitive = true,
            filesystem = {
                filtered_items = {
                    hide_by_name = {
                        "__init__.py",
                    },
                    never_show = {
                        ".devenv",
                        ".direnv",
                        "__pycache__",
                    },
                },
            },
        },
        keys = {
            {'<Leader>t', desc = '+NeoTree'},
            {
                '<Leader>tt',
                '<Cmd>Neotree action=show source=filesystem toggle=true reveal=true position=left<CR>',
                silent = true,
                noremap = true,
                desc = 'Toggle NeoTree'
            }, {
                '<Leader>tb',
                '<Cmd>Neotree action=show source=buffers toggle=true position=right<CR>',
                silent = true,
                noremap = true,
                desc = 'Toggle buffer list'
            }, {
                '<Leader>ts',
                '<Cmd>Neotree action=focus source=git_status position=float<CR>',
                silent = true,
                noremap = true,
                desc = 'Show Git Status'
            }
        }
    }, {
        "karb94/neoscroll.nvim",
        event = "VeryLazy",
        opts = {easing_function = 'quadratic', respect_scrolloff = true}
    }, {
        "kevinhwang91/nvim-ufo",
        event = "VeryLazy",
        dependencies = {{"kevinhwang91/promise-async"}},
        init = function()
            vim.o.foldcolumn = "1"
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
            vim.o.foldcolumn = "1"
        end,
        keys = {
            {'zR', function() require('ufo').openAllFolds() end},
            {'zM', function() require('ufo').closeAllFolds() end},
            {'zr', function() require('ufo').openFoldsExceptKinds() end},
            {'zm', function() require('ufo').closeFoldsWith() end}
        },
        opts = function(_, opts)
            opts.provider_selector = function(_, _, _)
                return {'treesitter', 'indent'}
            end

            opts.fold_virt_text_handler =
                function(virtText, lnum, endLnum, width, truncate, _)
                    local newVirtText = {}
                    local suffix = (' 󰁂 %d '):format(endLnum - lnum)
                    local sufWidth = vim.fn.strdisplaywidth(suffix)
                    local targetWidth = width - sufWidth
                    local curWidth = 0
                    for _, chunk in ipairs(virtText) do
                        local chunkText = chunk[1]
                        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        if targetWidth > curWidth + chunkWidth then
                            table.insert(newVirtText, chunk)
                        else
                            chunkText =
                                truncate(chunkText, targetWidth - curWidth)
                            local hlGroup = chunk[2]
                            table.insert(newVirtText, {chunkText, hlGroup})
                            chunkWidth = vim.fn.strdisplaywidth(chunkText)
                            if curWidth + chunkWidth < targetWidth then
                                suffix = suffix ..
                                             (' '):rep(
                                                 targetWidth - curWidth -
                                                     chunkWidth)
                            end
                            break
                        end
                        curWidth = curWidth + chunkWidth
                    end
                    table.insert(newVirtText, {suffix, 'MoreMsg'})
                    return newVirtText
                end
        end
    }, {
        "nvim-telescope/telescope.nvim",
        cond = not vim.g.started_by_firenvim,
        dependencies = {
            {"nvim-lua/plenary.nvim"},
            {
                "nvim-telescope/telescope-dap.nvim",
                dependencies = {"mfussenegger/nvim-dap"}
            }, {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'},
            {"nvim-telescope/telescope-ui-select.nvim"}
        },
        opts = function()
            return {
                defaults = {
                    mappings = {
                        i = {
                            ['<C-Down>'] = require('telescope.actions').cycle_history_next,
                            ['<C-Up>'] = require('telescope.actions').cycle_history_prev
                        }
                    },
                    layout_config = {vertical = {width = 0.5}}
                },
                pickers = {
                    find_files = {theme = 'dropdown'},
                    git_files = {theme = 'dropdown'},
                    frecency = {theme = 'dropdown'}
                },
                extensions = {
                    frecency = {
                        default_workspace = 'CWD',
                        workspaces = {
                            ['conf'] = vim.fn.expand('~') .. '/.config',
                            ['data'] = vim.fn.expand('~') .. '/.local/share',
                            ['nixos'] = '/etc/nixos'
                        }
                    },
                    ['ui-select'] = {
                        require('telescope.themes').get_dropdown({})
                    }
                }
            }
        end,
        cmd = "Telescope",
        keys = {
            {"<Leader>f", desc = "+Find"},
            {"<leader>ff", desc = "File Picker"}, {
                '<Leader>fb',
                function() require("telescope.builtin").buffers() end,
                silent = true,
                noremap = true,
                desc = 'Buffer Picker'
            }, {
                '<Leader>fg',
                function()
                    require("telescope.builtin").live_grep()
                end,
                silent = true,
                noremap = true,
                desc = 'Live Grep'
            }, {
                '<Leader>fh',
                function()
                    require("telescope.builtin").help_tags()
                end,
                silent = true,
                noremap = true,
                desc = 'Search Help Tags'
            }, {
                '<Leader>fo',
                function()
                    require("telescope.builtin").oldfiles()
                end,
                silent = true,
                noremap = true,
                desc = 'Find Old Files'
            }, {
                '<Leader>fm',
                function() require("telescope.builtin").marks() end,
                silent = true,
                noremap = true,
                desc = 'Vim Marks'
            }
        },
        config = function(_, opts)
            require('telescope').setup(opts)

            local function filesOrGit()
                local is_worktree = vim.api.nvim_cmd({
                    cmd = '!',
                    args = {'git', 'rev-parse', '--is-inside-work-tree'}
                }, {output = true})
                if string.match(is_worktree, 'true') then
                    return require("telescope.builtin").git_files()
                else
                    return require("telescope.builtin").find_files()
                end
            end

            vim.keymap.set('n', '<Leader>ff', filesOrGit, {
                silent = true,
                noremap = true,
                desc = 'File Picker'
            })
        end
    }, {
        "folke/trouble.nvim",
        cond = not vim.g.started_by_firenvim,
        cmd = {"TroubleToggle", "Trouble"},
        opts = {use_diagnostic_signs = true},
        keys = {
            {'<LocalLeader>x', desc = '+Trouble'},
            {
                "<LocalLeader>xx",
                "<cmd>TroubleToggle document_diagnostics<cr>",
                desc = "Document Diagnostics (Trouble)"
            }, {
                "<LocalLeader>xX",
                "<cmd>TroubleToggle workspace_diagnostics<cr>",
                desc = "Workspace Diagnostics (Trouble)"
            }, {
                "<LocalLeader>xL",
                "<cmd>TroubleToggle loclist<cr>",
                desc = "Location List (Trouble)"
            }, {
                "<LocalLeader>xQ",
                "<cmd>TroubleToggle quickfix<cr>",
                desc = "Quickfix List (Trouble)"
            }, {
                "[q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").previous({
                            skip_groups = true,
                            jump = true
                        })
                    else
                        vim.cmd.cprev()
                    end
                end,
                desc = "Previous trouble/quickfix item"
            }, {
                "]q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").next({
                            skip_groups = true,
                            jump = true
                        })
                    else
                        vim.cmd.cnext()
                    end
                end,
                desc = "Next trouble/quickfix item"
            }
        }
    }, {
        "folke/todo-comments.nvim",
        cmd = {"TodoTrouble", "TodoTelescope"},
        event = {"BufReadPost", "BufNewFile"},
        config = true,
        keys = {
            {
                "]t",
                function() require("todo-comments").jump_next() end,
                desc = "Next todo comment"
            }, {
                "[t",
                function() require("todo-comments").jump_prev() end,
                desc = "Previous todo comment"
            }, {"<LocalLeader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)"},
            {
                "<LocalLeader>xT",
                "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",
                desc = "Todo/Fix/Fixme (Trouble)"
            }, {"<Leader>ft", "<cmd>TodoTelescope<cr>", desc = "Todo"}
        }
    }, {
        "tpope/vim-projectionist",
        lazy = false,
    }, {
        "NoahTheDuke/vim-just",
        lazy = false,
    }
}
