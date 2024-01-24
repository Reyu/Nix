-- moving between splits
local returnToNormal = function()
    -- The key combo "<C-\><C-N>" is used to return to normal
    -- mode, regardless of the current mode.
    local keys = vim.api.nvim_replace_termcodes([[<C-\><C-N>]], true, true, true)
    vim.api.nvim_feedkeys(keys, 'n', true)
end

return {
    {
        "Tsuzat/NeoSolarized.nvim",
        cond = not vim.g.started_by_firenvim,
        opts = {
            style = 'dark',
            transparent = true,
            terminal_colors = true,
            enable_italics = true,
            styles = {
                comments = {italic = true},
                keywords = {italic = true},
                functions = {bold = true},
                variables = {},
                string = {italic = true},
                underline = true,
                undercurl = true
            }
        }
    }, {
        "projekt0n/github-nvim-theme",
        lazy = false,
        priority = 1000,
        opts = {options = {transparent = true}},
        config = function(_, opts)
            require('github-theme').setup(opts)
            vim.cmd([[ colorscheme github_dark ]])
        end
    }, {
        "folke/zen-mode.nvim",
        cond = not vim.g.started_by_firenvim,
        cmd = "ZenMode",
        keys = {
            {'<Leader>z', desc = '+ZenMode'},
            {
                "<Leader>zz",
                function() require("zen-mode").toggle() end,
                desc = "Toggle ZenMode"
            }
        },
        opts = {
            window = {
                backdrop = 1,
                width = 160,
                height = 1,
                options = {
                    number = false,
                    relativenumber = false,
                    cursorline = false,
                    cursorcolumn = false,
                    foldcolumn = "0",
                },
            },
            plugins = {
                tmux = { enabled = true },
                kitty = {
                    enabled = true,
                    font = "+8", -- font size increment
                },
                alacritty = {
                    enabled = true,
                    font = "14", -- font size
                },
            }
        }
    }, {
        "folke/twilight.nvim",
        cond = not vim.g.started_by_firenvim,
        cmd = {"Twilight", "TwilightEnable"},
        keys = {
            {
                "<Leader>zt",
                function() require("twilight").toggle() end,
                desc = "Toggle Twilight"
            }
        },
        opts = {dimming = {inactive = true}, context = 6}
    }, {
        "rcarriga/nvim-notify",
        cond = not vim.g.started_by_firenvim,
        keys = {
            {
                "<leader>nd",
                function()
                    require("notify").dismiss({silent = true, pending = true})
                end,
                desc = "Delete all Notifications"
            }
        },
        opts = {
            background_colour = '#000000',
            timeout = 3000,
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.75)
            end
        }
    }, {
        "folke/noice.nvim",
        cond = not vim.g.started_by_firenvim,
        event = "VeryLazy",
        dependencies = {{"MunifTanjim/nui.nvim"}},
        keys = {
            {
                '<Leader>n',
                desc = "+Noice",
            },
            {
                '<Leader>nl',
                function() require("noice").cmd('last') end,
                silent = true,
                desc = 'Last Notification'
            }, {
                '<Leader>nh',
                function() require("noice").cmd('history') end,
                silent = true,
                desc = 'Notification History'
            },
            {
                "<leader>na",
                function() require("noice").cmd("all") end,
                desc = "Noice All"
            }, {
                "<S-Enter>",
                function()
                    require("noice").redirect(vim.fn.getcmdline())
                end,
                mode = "c",
                desc = "Redirect Cmdline"
            }, {
                "<c-f>",
                function()
                    if not require("noice.lsp").scroll(4) then
                        return "<c-f>"
                    end
                end,
                silent = true,
                expr = true,
                desc = "Scroll forward",
                mode = {"i", "n", "s"}
            }, {
                "<c-b>",
                function()
                    if not require("noice.lsp").scroll(-4) then
                        return "<c-b>"
                    end
                end,
                silent = true,
                expr = true,
                desc = "Scroll backward",
                mode = {"i", "n", "s"}
            }
        },
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true
                }
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                lsp_doc_border = true
            },
            cmdline = {
                format = {
                    cmdline = {icon = '>'},
                    search_down = {icon = '🔍⌄'},
                    search_up = {icon = '🔍⌃'},
                    filter = {icon = '$'},
                    lua = {icon = '☾'},
                    help = {icon = '?'}
                }
            }
        }
    }, {
        "anuvyklack/windows.nvim",
        dependencies = {"anuvyklack/middleclass", "anuvyklack/animation.nvim"},
        keys = {
            {'<C-w>z', '<cmd>WindowsMaximize<cr>', desc = "Maximize window"}, {
                '<C-w>_',
                '<cmd>WindowsMaximizeVertically<cr>',
                desc = "Maximize window vertically"
            }, {
                '<C-w>|',
                '<cmd>WindowsMaximizeHorizontally<cr>',
                desc = "Maximize window horizontally"
            }, {'<C-w>=', '<cmd>WindowsEqualize<cr>', desc = "Equalize windows"}
        },
        cmd = {
            "WindowsMaximize", "WindowsMaximizeVertically",
            "WindowsMaximizeHorizontally", "WindowsEqualize",
            "WindowsEnableAutowidth", "WindowsDisableAutowidth",
            "WindowsToggleAutowidth"
        },
        init = function()
            vim.o.winwidth = 10
            vim.o.winminwidth = 10
            vim.o.equalalways = false
        end,
        config = true
    }, {
        "mrjones2014/smart-splits.nvim",
        dependencies = {
            {
                'jlanzarotta/bufexplorer',
                keys = {
                    {'<Leader>b', desc = '+BufExplorer'},
                },
            }, {'sindrets/winshift.nvim', config = true}
        },
        opts = {
            ignored_filetypes = {'nofile', 'quickfix', 'prompt'},
            ignored_buftypes = {},
            default_amount = 3,
            at_edge = 'wrap',
            multiplexer_integration = 'tmux'
        },
        keys = {
            {'<C-w>', desc = "+Manage Windows"},
            {'gb', desc = "Choose Buffer"},
            {'<S-A-h>', function()
                require('smart-splits').resize_left()
            end},
            {'<S-A-j>', function()
                require('smart-splits').resize_down()
            end},
            {'<S-A-k>', function()
                require('smart-splits').resize_up()
            end},
            {'<S-A-l>', function()
                require('smart-splits').resize_right()
            end}, {
                '<M-h>',
                function()
                    returnToNormal()
                    require('smart-splits').move_cursor_left()
                end,
                mode = {'n', 'i', 't'}
            }, {
                '<M-j>',
                function()
                    returnToNormal()
                    require('smart-splits').move_cursor_down()
                end,
                mode = {'n', 'i', 't'}
            }, {
                '<M-k>',
                function()
                    returnToNormal()
                    require('smart-splits').move_cursor_up()
                end,
                mode = {'n', 'i', 't'}
            }, {
                '<M-l>',
                function()
                    returnToNormal()
                    require('smart-splits').move_cursor_right()
                end,
                mode = {'n', 'i', 't'}
            }
        },
        config = function(_, opts)
            local smart_splits = require('smart-splits')
            smart_splits.setup(opts)
        end
    }, {
        "goolord/alpha-nvim",
        cond = not vim.g.started_by_firenvim,
        event = "VimEnter",
        opts = function()
            local dashboard = require("alpha.themes.dashboard")
            local logo = [[
       ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗
       ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║
       ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║
       ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║
       ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║
       ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝
      ]]

            dashboard.section.header.val = vim.split(logo, "\n")
            dashboard.section.buttons.val = {
                dashboard.button("f", " " .. " Find file",
                                 ":Telescope find_files <CR>"),
                dashboard.button("n", " " .. " New file",
                                 ":ene <BAR> startinsert <CR>"),
                dashboard.button("r", " " .. " Recent files",
                                 ":Telescope oldfiles <CR>"),
                dashboard.button("g", " " .. " Find text",
                                 ":Telescope live_grep <CR>"),
                dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
                dashboard.button("s", " " .. " Restore Session",
                                 [[:lua require("persistence").load() <cr>]]),
                dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
                dashboard.button("q", " " .. " Quit", ":qa<CR>")
            }
            for _, button in ipairs(dashboard.section.buttons.val) do
                button.opts.hl = "AlphaButtons"
                button.opts.hl_shortcut = "AlphaShortcut"
            end
            dashboard.section.footer.opts.hl = "Type"
            dashboard.section.header.opts.hl = "AlphaHeader"
            dashboard.section.buttons.opts.hl = "AlphaButtons"
            dashboard.opts.layout[1].val = 8
            return dashboard
        end,
        config = function(_, dashboard)
            -- close Lazy and re-open when the dashboard is ready
            if vim.o.filetype == "lazy" then
                vim.cmd.close()
                vim.api.nvim_create_autocmd("User", {
                    pattern = "AlphaReady",
                    callback = function()
                        require("lazy").show()
                    end
                })
            end

            require("alpha").setup(dashboard.opts)

            vim.api.nvim_create_autocmd("User", {
                pattern = "LazyVimStarted",
                callback = function()
                    local stats = require("lazy").stats()
                    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                    dashboard.section.footer.val =
                        "⚡ Neovim loaded " .. stats.count .. " plugins in " ..
                            ms .. "ms"
                    pcall(vim.cmd.AlphaRedraw)
                end
            })
        end
    }, {
        "lukas-reineke/indent-blankline.nvim",
        event = {"BufReadPost", "BufNewFile"},
        main = "ibl",
        opts = {
            indent = {
                char = "│",
            },
            exclude = {
                filetypes = {
                    "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy",
                    "gitcommit", "TelescopePrompt", "TelescopeResults"
                },
            },
        }
    }, {
        "echasnovski/mini.indentscope",
        version = false,
        event = {"BufReadPre", "BufNewFile"},
        opts = {symbol = "│", options = {try_as_border = false}},
        main = "mini.indentscope",
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy",
                    "mason"
                },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end
            })
        end
    }, {
        "nvim-lualine/lualine.nvim",
        cond = not vim.g.started_by_firenvim,
        event = "VeryLazy",
        opts = function()
            return {
                options = {
                    icons_enabled = true,
                    component_separators = {left = "", right = ""},
                    section_separators = {left = "", right = ""},
                    disabled_filetypes = {"dashboard", "lazy"},
                    always_divide_middle = true,
                    globalstatus = true
                },
                sections = {
                    lualine_a = {'mode'},
                    lualine_b = {{'FugitiveHead', icon = ''}, 'diff', 'diagnostics'},
                    lualine_c = {'%S'},
                    lualine_x = {
                        {
                            require("noice").api.status.message.get_hl,
                            cond = require("noice").api.status.message.has
                        }, {
                            require('noice').api.status.command.get,
                            cond = require('noice').api.status.command.has,
                            color = {fg = "#ff9e64"}
                        }, {
                            require('noice').api.status.search.get,
                            cond = require('noice').api.status.search.has,
                            color = {fg = "#ff9e64"}
                        }
                    },
                    lualine_y = {
                        {
                            require('noice').api.status.ruler.get,
                            cond = require('noice').api.status.ruler.has
                        }, '%a'
                    },
                    lualine_z = {'hostname'}
                },
                tabline = {
                    lualine_a = {},
                    lualine_b = {{'tabs', mode = 2}},
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {{'buffers', mode = 4}}
                },
                winbar = {
                    lualine_a = {{'filetype', icon_only = true}, {'filename', path = 1}},
                    lualine_b = {'filesize', '%r'},
                    lualine_c = {'%w', 'searchcount'},
                    lualine_x = {'diagnostics'},
                    lualine_y = {'encoding', 'fileformat', {'filetype', icon = ""}},
                    lualine_z = {'%P', 'location'},
                },
                inactive_winbar = {
                    lualine_a = {{'filetype', icon_only = true}, {'filename', path = 1}},
                    lualine_b = {'filesize', '%r'},
                    lualine_c = {'%w', 'searchcount'},
                    lualine_x = {'diagnostics'},
                    lualine_y = {'encoding', 'fileformat', 'filetype'},
                    lualine_z = {'%P', 'location'},
                },
                extensions = {
                    "man", "quickfix", "trouble", "toggleterm", "fugitive", "neo-tree",
                    "nvim-dap-ui"
                }
            }
        end
    }, {"nvim-tree/nvim-web-devicons", lazy = true},
    {
        "folke/edgy.nvim",
        cond = not vim.g.started_by_firenvim,
        event = "VeryLazy",
        keys = {
            {"<Leader>e", desc = "+Edgy"},
            {"<Leader>ee", function() require('edgy').toggle() end, desc = "Toggle Edgy pinned views", silent = true},
            {"<Leader>em", function() require('edgy').goto_main() end, desc = "Goto Main window", silent = true},
            {"<Leader>es", function() require('edgy').select() end, desc = "Select window in edgebar", silent = true},
        },
        opts = function()
            local opts = {
                bottom = {
                    {
                        ft = "toggleterm",
                        size = { height = 0.4 },
                        filter = function(_, win)
                            return vim.api.nvim_win_get_config(win).relative == ""
                        end,
                    },
                    {
                        ft = "noice",
                        size = { height = 0.4 },
                        filter = function(_, win)
                            return vim.api.nvim_win_get_config(win).relative == ""
                        end,
                    },
                    {
                        ft = "lazyterm",
                        title = "LazyTerm",
                        size = { height = 0.4 },
                        filter = function(buf)
                            return not vim.b[buf].lazyterm_cmd
                        end,
                    },
                    "Trouble",
                    { ft = "qf", title = "QuickFix" },
                    {
                        ft = "help",
                        size = { height = 20 },
                        -- don't open help files in edgy that we're editing
                        filter = function(buf)
                            return vim.bo[buf].buftype == "help"
                        end,
                    },
                    { ft = "spectre_panel", size = { height = 0.4 } },
                    { title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
                },
                right = {
                    { title = "Neotest Summary", ft = "neotest-summary" },
                },
                left = {
                    {
                        title = "Neo-Tree",
                        ft = "neo-tree",
                        filter = function(buf)
                            return vim.b[buf].neo_tree_source == "filesystem"
                        end,
                        pinned = true,
                        open = function()
                            vim.api.nvim_input("<esc><space>e")
                        end,
                        size = { height = 0.5 },
                    },
                    {
                        title = "Neo-Tree Git",
                        ft = "neo-tree",
                        filter = function(buf)
                            return vim.b[buf].neo_tree_source == "git_status"
                        end,
                        pinned = true,
                        open = "Neotree left git_status",
                    },
                    {
                        title = "Neo-Tree Buffers",
                        ft = "neo-tree",
                        filter = function(buf)
                            return vim.b[buf].neo_tree_source == "buffers"
                        end,
                        pinned = true,
                        open = "Neotree top buffers",
                    },
                    "neo-tree",
                },
                keys = {
                    -- increase width
                    ["<c-Right>"] = function(win)
                        win:resize("width", 2)
                    end,
                    -- decrease width
                    ["<c-Left>"] = function(win)
                        win:resize("width", -2)
                    end,
                    -- increase height
                    ["<c-Up>"] = function(win)
                        win:resize("height", 2)
                    end,
                    -- decrease height
                    ["<c-Down>"] = function(win)
                        win:resize("height", -2)
                    end,
                },
            }
            return opts
        end,
    },
    {
        'akinsho/toggleterm.nvim',
        version = "v2.*",
        cond = not vim.g.started_by_firenvim,
        opts =  {
            open_mapping = [[<C-\>]],
            direction = "float",
        },
        init = function ()
            vim.api.nvim_create_autocmd("TermOpen", {
                callback = function()
                    local opts = {buffer = 0}
                    vim.keymap.set('t', '<esc><esc>', returnToNormal, opts)
                end
            })
        end,
        keys = {
            {[[<C-\>]], desc = "Toggle Term"},
            {"<LocalLeader>s", desc = "+Send to term"},
            {"<LocalLeader>sl", "<CMD>ToggleTermSendCurentLine<CR>", desc = "Send line to terminal"},
            {"<LocalLeader>sl", "<CMD>ToggleTermSendVisualLines<CR>", mode = 'v', desc = "Send lines to terminal"},
            {"<LocalLeader>ss", "<CMD>ToggleTermSendVisualSelection<CR>", mode = 'v', desc = "Send selection to terminal"},
        },
        commands = {
            "ToggleTerm",
            "ToggleTermSendCurrentLine",
            "ToggleTermSendVisualLines",
            "ToggleTermSendVisualSelection",
            "ToggleTermSetName",
            "ToggleTermToggleAll",
        },
    }, {
        "folke/flash.nvim",
        enabled = false,
        event = "VeryLazy",
        opts = {},
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash", },
            { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter", },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash", },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Flash Treesitter Search", },
            { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search", },
        },
    },
    {"luukvbaal/statuscol.nvim", config = true, },
}
