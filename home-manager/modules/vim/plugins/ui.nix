{ pkgs, ... }: with pkgs.vimPlugins; [
  {
    plugin = zen-mode-nvim;
    type = "lua";
    optional = true;
    config = ''
      if not vim.g.started_by_firenvim then
          vim.api.nvim_command('packadd zen-mode.nvim')
          require('zen-mode').setup({
              window = {
                  backdrop = 1,
                  width = 120,
                  height = 1,
                  options = {
                      number = false,
                      relativenumber = false,
                      cursorline = false,
                      cursorcolumn = false,
                      foldcolumn = 0
                  }
              }
          })
          vim.keymap.set('n', '<LocalLeader>zz', require('zen-mode').toggle,
                         {desc = 'Toggle ZenMode'})
      end
    '';
  }
  {
    plugin = twilight-nvim;
    type = "lua";
    optional = true;
    config = ''
      if not vim.g.started_by_firenvim then
          vim.api.nvim_command('packadd twilight.nvim')
          require('twilight').setup({dimming = {inactive = true}, context = 6})
          vim.keymap.set('n', '<LocalLeader>zt', require('twilight').toggle,
                         {desc = 'Toggle Twilight'})
      end
    '';
  }
  {
    plugin = nvim-notify;
    type = "lua";
    optional = true;
    config = ''
      if not vim.g.started_by_firenvim then
          vim.api.nvim_command('packadd nvim-notify')
          require('notify').setup({
              background_colour = '#000000',
              timeout = 3000,
              max_height = function() return math.floor(vim.o.lines * 0.75) end,
              max_width = function() return math.floor(vim.o.columns * 0.75) end
          })
      end
    '';
  }
  {
    plugin = noice-nvim;
    type = "lua";
    optional = true;
    config = ''
      if not vim.g.started_by_firenvim then
          vim.api.nvim_command('packadd noice.nvim')
          local noice = require('noice')
          noice.setup({
              lsp = {
                  override = {
                      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                      ["vim.lsp.util.stylize_markdown"] = true,
                      ["cmp.entry.get_documentation"] = true
                  },
                  hover = {enabled = true, silent = true},
                  signature = {enabled = true}
              },
              presets = {
                  command_palette = true,
                  long_message_to_split = true,
                  lsp_doc_border = true
              },
              -- popupmenu = {
              --   backend = 'cmp'
              -- },
              routes = {
                  {view = "split", filter = {event = "msg_show", min_height = 20}}
              }
          })

          local has_telescope, telescope = pcall(require, 'telescope')
          if has_telescope then telescope.load_extension('noice') end

          vim.keymap.set('n', '<Leader>al', function() noice.cmd('last') end,
                         {desc = 'Last notification'})
          vim.keymap.set('n', '<Leader>ah', function() noice.cmd('history') end,
                         {desc = 'Notification history'})
          vim.keymap.set('n', '<Leader>ad', function() noice.cmd('dismiss') end,
                         {desc = 'Dismiss notifications'})
      end
    '';
  }
  { plugin = bufresize-nvim; optional = true; }
  {
    plugin = smart-splits-nvim;
    type = "lua";
    optional = true;
    config = ''
      if not vim.g.started_by_firenvim then
          vim.api.nvim_command('packadd bufresize.nvim')
          vim.api.nvim_command('packadd smart-splits.nvim')
          local smart_splits = require('smart-splits')
          smart_splits.setup({
              ignored_filetypes = {'nofile', 'quickfix', 'prompt'},
              ignored_buftypes = {'NvimTree'},
              default_amount = 3,
              at_edge = 'wrap'
          })

          local returnToNormal = function()
              -- The key combo "<C-\><C-N>" is used to return to normal
              -- mode, regardless of the current mode.
              local keys = vim.api.nvim_replace_termcodes('<C-\\><C-N>', true, true,
                                                          true)
              vim.api.nvim_feedkeys(keys, 'n', true)
          end
          local map = function(lhs, rhs, desc)
              vim.keymap.set({'n', 'i'}, lhs, rhs, {desc = desc})
              vim.keymap.set('t', lhs, function()
                  returnToNormal()
                  rhs()
              end, {desc = desc})
          end
          map('<M-h>', smart_splits.move_cursor_left, 'Select window to left')
          map('<M-l>', smart_splits.move_cursor_right, 'Select window to right')
          map('<M-j>', smart_splits.move_cursor_down, 'Select window below')
          map('<M-k>', smart_splits.move_cursor_up, 'Select window above')
          map('<S-A-h>', smart_splits.resize_left, 'Resize window to left')
          map('<S-A-l>', smart_splits.resize_right, 'Resize window to right')
          map('<S-A-j>', smart_splits.resize_down, 'Resize window to down')
          map('<S-A-k>', smart_splits.resize_up, 'Resize window to up')
          vim.keymap.set('n', '<Leader><Leader>h', smart_splits.swap_buf_left,
                         {desc = 'Swap window to left'})
          vim.keymap.set('n', '<Leader><Leader>l', smart_splits.swap_buf_right,
                         {desc = 'Swap window to right'})
          vim.keymap.set('n', '<Leader><Leader>j', smart_splits.swap_buf_down,
                         {desc = 'Swap window below'})
          vim.keymap.set('n', '<Leader><Leader>k', smart_splits.swap_buf_up,
                         {desc = 'Swap window above'})
      end
    '';
  }
  {
    plugin = alpha-nvim;
    type = "lua";
    optional = true;
    config = ''
      if not vim.g.started_by_firenvim then
          vim.api.nvim_command('packadd alpha-nvim')
          local alpha = require('alpha')
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
              dashboard.button("q", " " .. " Quit", ":qa<CR>")
          }
          dashboard.config.opts.noautocmd = true
          alpha.setup(dashboard.config)
      end
    '';
  }
  {
    plugin = indent-blankline-nvim;
    type = "lua";
    config = ''
      require('ibl').setup({
          indent = {
              char = "│",
          },
          exclude = {
              filetypes = {
                  "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy",
                  "gitcommit", "TelescopePrompt", "TelescopeResults"
              },
          },
      })
    '';
  }
  {
    plugin = lualine-nvim;
    type = "lua";
    config = ''
      local noiceLeft, noiceRight
      if not vim.g.started_by_firenvim then
          noiceLeft = {
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
          }
          noiceRight = {
              require('noice').api.status.ruler.get,
              cond = require('noice').api.status.ruler.has
          }
      end
      require('lualine').setup({
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
              lualine_x = noiceLeft,
              lualine_y = {noiceRight, '%a'},
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
              lualine_z = {'%P', 'location'}
          },
          inactive_winbar = {
              lualine_a = {{'filetype', icon_only = true}, {'filename', path = 1}},
              lualine_b = {'filesize', '%r'},
              lualine_c = {'%w', 'searchcount'},
              lualine_x = {'diagnostics'},
              lualine_y = {'encoding', 'fileformat', 'filetype'},
              lualine_z = {'%P', 'location'}
          },
          extensions = {
              "man", "quickfix", "trouble", "toggleterm", "fugitive", "neo-tree",
              "nvim-dap-ui"
          }
      })
    '';
  }
  {
    plugin = edgy-nvim;
    type = "lua";
    config = ''
      vim.opt.splitkeep = "screen"
      require('edgy').setup({
          bottom = {
              {
                  ft = "toggleterm",
                  size = {height = 0.3},
                  filter = function(buf, win)
                      return vim.api.nvim_win_get_config(win).relative == ""
                  end
              }, "Trouble", {
                  ft = "help",
                  size = {height = 20},
                  filter = function(buf)
                      return vim.bo[buf].buftype == "help"
                  end
              }, {title = "[dap-repl]", ft = "dap-repl"},
              {title = "DAP Console", ft = "dapui_console"}
          },
          left = {
              {
                  title = "Neo-Tree",
                  ft = "neo-tree",
                  filter = function(buf)
                      return vim.b[buf].neo_tree_source == "filesystem"
                  end,
                  size = {height = 0.5}
              }, {
                  title = "Neo-Tree Git",
                  ft = "neo-tree",
                  filter = function(buf)
                      return vim.b[buf].neo_tree_source == "git_status"
                  end,
                  pinned = true,
                  open = "Neotree position=right git_status"
              }, {
                  title = "Neo-Tree Buffers",
                  ft = "neo-tree",
                  filter = function(buf)
                      return vim.b[buf].neo_tree_source == "buffers"
                  end,
                  pinned = true,
                  open = "Neotree position=top buffers"
              }, "neo-tree", {title = "DAP Scopes", ft = "dapui_scopes"},
              {title = "DAP Breakpoints", ft = "dapui_breakpoints"},
              {title = "DAP Stacks", ft = "dapui_stacks"},
              {title = "DAP Watches", ft = "dapui_watches"}
          }
      })
    '';
  }
]
