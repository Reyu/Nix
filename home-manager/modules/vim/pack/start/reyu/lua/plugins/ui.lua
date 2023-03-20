local window_hint = [[
^^^^^^^^^^^^     Move      ^^    Size   ^^   ^^     Split
^^^^^^^^^^^^-------------  ^^-----------^^   ^^---------------
^ ^ _k_ ^ ^  ^ ^ _K_ ^ ^   ^   _<C-k>_   ^   _s_: horizontally
_h_ ^ ^ _l_  _H_ ^ ^ _L_   _<C-h>_ _<C-l>_   _v_: vertically
^ ^ _j_ ^ ^  ^ ^ _J_ ^ ^   ^   _<C-j>_   ^   _q_, _c_: close
focus^^^^^^  window^^^^^^  ^_=_: equalize^   _z_: maximize
^ ^ ^ ^ ^ ^  ^ ^ ^ ^ ^ ^   ^^ ^          ^   _o_: remain only
_b_: choose buffer
]]

-- moving between splits
local returnToNormal = function()
    -- The key combo "<C-\><C-N>" is used to return to normal
    -- mode, regardless of the current mode.
    local keys = vim.api.nvim_replace_termcodes('<C-\\><C-N>', true, true, true)
    vim.api.nvim_feedkeys(keys, 'n', true)
end

return {
    {
        "Tsuzat/NeoSolarized.nvim",
        priority = 1000,
        lazy = false,
        config = function() vim.cmd([[colorscheme NeoSolarized]]) end,
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
        "folke/twilight.nvim",
        cmd = {"Twilight", "TwilightEnable"},
        keys = {
            {"<Leader>zt", function() require("twilight").toggle() end, "Toggle Twilight"},
        },
        opts = {dimming = {inactive = true}, context = 6}
    }, {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        keys = {
            {"<Leader>zz", function() require("zen-mode").toggle() end, "Toggle Twilight"},
        },
        opts = {
            window = {
                backdrop = 1,
                width = 120,
                height = 1,
                options = {
                    number = false,
                    relativenumber = true,
                    cursorline = false,
                    cursorcolumn = false
                }
            }
        }
    }, {
        "rcarriga/nvim-notify",
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
        event = "VeryLazy",
        dependencies = {{"MunifTanjim/nui.nvim"}},
        keys = {
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
                'romgrk/barbar.nvim',
                dependencies = {'nvim-tree/nvim-web-devicons'}
            }, {'jlanzarotta/bufexplorer'},
            {'sindrets/winshift.nvim', config = true}
        },
        opts = {
            ignored_filetypes = {'nofile', 'quickfix', 'prompt'},
            ignored_buftypes = {},
            default_amount = 3,
            wrap_at_edge = false,
            tmux_integration = true
        },
        keys = {
            {'<C-w>', desc = "Manage Windows"}, {'gb', desc = "Choose Buffer"},
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

            local Hydra = require('hydra')
            local cmd = require('hydra.keymap-util').cmd
            local pcmd = require('hydra.keymap-util').pcmd

            local buffer_hydra = Hydra({
                name = 'Barbar',
                config = {
                    on_key = function()
                        vim.wait(200, function()
                            vim.cmd.redraw()
                            return true
                        end, 30, false)
                    end
                },
                heads = {
                    {
                        'h', function()
                            vim.cmd('BufferPrevious')
                        end, {on_key = false}
                    },
                    {
                        'l', function()
                            vim.cmd('BufferNext')
                        end, {desc = 'choose', on_key = false}
                    }, {'H', function()
                        vim.cmd('BufferMovePrevious')
                    end},
                    {
                        'L', function()
                            vim.cmd('BufferMoveNext')
                        end, {desc = 'move'}
                    },

                    {'p', function() vim.cmd('BufferPin') end, {desc = 'pin'}},

                    {
                        'd', function()
                            vim.cmd('BufferClose')
                        end, {desc = 'close'}
                    },
                    {'c', function() vim.cmd('BufferClose') end, {desc = false}},
                    {'q', function() vim.cmd('BufferClose') end, {desc = false}},

                    {
                        'od', function()
                            vim.cmd('BufferOrderByDirectory')
                        end, {desc = 'by directory'}
                    },
                    {
                        'ol', function()
                            vim.cmd('BufferOrderByLanguage')
                        end, {desc = 'by language'}
                    }, {'<Esc>', nil, {exit = true}}
                }
            })

            local function choose_buffer()
                if #vim.fn.getbufinfo({buflisted = true}) > 1 then
                    buffer_hydra:activate()
                end
            end
            vim.keymap.set('n', 'gb', choose_buffer)

            Hydra({
                name = 'Windows',
                hint = window_hint,
                config = {
                    invoke_on_body = true,
                    hint = {border = 'rounded', offset = -1}
                },
                mode = 'n',
                body = '<C-W>',
                heads = {
                    {'h', '<C-w>h'}, {'j', '<C-w>j'},
                    {'k', pcmd('wincmd k', 'E11', 'close')}, {'l', '<C-w>l'},

                    {'H', cmd 'WinShift left'}, {'J', cmd 'WinShift down'},
                    {'K', cmd 'WinShift up'}, {'L', cmd 'WinShift right'},

                    {'<C-h>', function()
                        smart_splits.resize_left(2)
                    end}, {'<C-j>', function()
                        smart_splits.resize_down(2)
                    end}, {'<C-k>', function()
                        smart_splits.resize_up(2)
                    end},
                    {'<C-l>', function()
                        smart_splits.resize_right(2)
                    end}, {'=', '<C-w>=', {desc = 'equalize'}},

                    {'s', pcmd('split', 'E36')},
                    {'<C-s>', pcmd('split', 'E36'), {desc = false}},
                    {'v', pcmd('vsplit', 'E36')},
                    {'<C-v>', pcmd('vsplit', 'E36'), {desc = false}},

                    {'w', '<C-w>w', {exit = true, desc = false}},
                    {'<C-w>', '<C-w>w', {exit = true, desc = false}},

                    {
                        'z', cmd 'WindowsMaximaze',
                        {exit = true, desc = 'maximize'}
                    },
                    {
                        '<C-z>', cmd 'WindowsMaximaze',
                        {exit = true, desc = false}
                    }, {'o', '<C-w>o', {exit = true, desc = 'remain only'}},
                    {'<C-o>', '<C-w>o', {exit = true, desc = false}},

                    {'b', choose_buffer, {exit = true, desc = 'choose buffer'}},

                    {'c', pcmd('close', 'E444')},
                    {'q', pcmd('close', 'E444'), {desc = 'close window'}},
                    {'<C-c>', pcmd('close', 'E444'), {desc = false}},
                    {'<C-q>', pcmd('close', 'E444'), {desc = false}},

                    {'<Esc>', nil, {exit = true, desc = false}}
                }
            })
        end
    }, {
        "goolord/alpha-nvim",
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
        opts = {
            char = "│",
            filetype_exclude = {
                "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy"
            },
            show_trailing_blankline_indent = false,
            show_current_context = false
        }
    }, {
        "echasnovski/mini.indentscope",
        version = false,
        event = {"BufReadPre", "BufNewFile"},
        opts = {symbol = "│", options = {try_as_border = true}},
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
        end,
        config = function(_, opts)
            require("mini.indentscope").setup(opts)
        end
    }, {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function()
            return {
                options = {
                    icons_enabled = true,
                    theme = "NeoSolarized",
                    component_separators = {left = "", right = ""},
                    section_separators = {left = "", right = ""},
                    disabled_filetypes = {"dashboard", "lazy"},
                    always_divide_middle = true,
                    globalstatus = true
                },
                sections = {
                    lualine_a = {'mode'},
                    lualine_b = {},
                    lualine_c = {
                        {
                            require('noice').api.status.message.get,
                            cond = require('noice').api.status.message.has,
                            color = {fg = "#ff9e64"}
                        }
                    },

                    lualine_x = {
                        {
                            require("lazy.status").updates,
                            cond = require("lazy.status").has_updates,
                            color = { fg = "#ff9e64" },
                        },
                        {
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
                        }, 'progress', 'filesize'
                    },
                    lualine_z = {'location'}
                },
                tabline = {
                    lualine_a = {{'tabs', mode = 2}},
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {{'buffers', mode = 4}}
                },
                winbar = {
                    lualine_a = {
                        {'filetype', icon_only = true}, {'filename', path = 1}
                    },
                    lualine_b = {'aerial'},
                    lualine_c = {{"FugitiveHead", icon = ""}, {"diff"}},
                    lualine_x = {'encoding', 'fileformat', 'filetype'},
                    lualine_y = {"searchcount"},
                    lualine_z = {"diagnostics"}
                },
                inactive_winbar = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {
                        {'filetype', icon_only = true}, {'filename', path = 0}
                    },
                    lualine_x = {"searchcount", 'diagnostics'},
                    lualine_y = {},
                    lualine_z = {}
                },
                extensions = {"man", "quickfix"}
            }
        end
    }, {"nvim-tree/nvim-web-devicons", lazy = true}
}
