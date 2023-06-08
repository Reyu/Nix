{ pkgs, ... }: with pkgs.vimPlugins; [
  { plugin = direnv-vim; }
  { plugin = vimtex;
    type = "vim";
    config = ''
      let g:vimtex_view_method = 'zathura'
    '';
  }
  {
    plugin = firenvim;
    optional = true;
    type = "lua";
    config = ''
      vim.g.firenvim_config = {
          globalSettings = {alt = 'all'},
          localSettings = {
              ['.*'] = {
                  cmdline = 'firenvim',
                  content = 'text',
                  priority = 0,
                  selector = 'textarea:not([readonly]), div[role="textbox"]',
                  takeover = 'empty'
              }
          }
      }
      vim.api.nvim_create_autocmd({'UIEnter'}, {
          callback = function(event)
              local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
              if client ~= nil and client.name == "Firenvim" then
                  vim.keymap.set('n', '<Esc><Esc>', vim.fn['firenvim#focus_page'])
                  vim.g.firenvim_timer_started = false
                  vim.api.nvim_create_autocmd({"TextChanged"}, {
                      pattern = {"*"},
                      nested = true,
                      callback = function()
                          if vim.g.firenvim_timer_started then
                              return
                          else
                              vim.g.firenvim_timer_started = true
                              vim.fn.timer_start(1000, function()
                                  vim.g.firenvim_timer_started = false
                                  vim.cmd('write')
                              end)
                          end
                      end
                  })
              end
          end
      })
    '';
  }
  nvim-ts-context-commentstring
  {
    plugin = mini-nvim;
    type = "lua";
    config = ''
      require('mini.indentscope').setup({
          symbol = "│",
          options = {try_as_border = false}
      })
      vim.api.nvim_create_autocmd("FileType", {
          pattern = {
              "help", "alpha", "dashboard", "neo-tree", "Trouble"
          },
          callback = function() vim.b.miniindentscope_disable = true end
      })
      require('mini.pairs').setup({
          mappings = {
              ['"'] = {
                  action = 'closeopen',
                  pair = '""',
                  neigh_pattern = '[^\\"].',
                  register = {cr = false}
              }
          }
      })
      require('mini.surround').setup()
      require('mini.comment').setup({
        hooks = {
          pre = function()
            require('ts_context_commentstring.internal').update_commentstring({})
          end
        }
      })
      require('mini.align').setup()
      require('mini.bracketed').setup()
      require('mini.bufremove').setup()
      vim.keymap.set('n', '<C-w>q', require('mini.bufremove').delete, {desc = 'Remove buffer'})
      require('mini.misc').setup()
    '' + builtins.readFile ./mini-ai.lua;
  }
  {
    plugin = neorg;
    optional = true;
    type = "lua";
    config = ''
      if not vim.g.started_by_firenvim then
          vim.api.nvim_command('packadd neorg')
          require('neorg').setup({
              load = {
                  ['core.defaults'] = {},
                  ['core.promo'] = {},
                  ['core.dirman'] = {
                      config = {workspaces = {home = '~/Notes'}},
                      index = 'main.norg'
                  },
                  ['core.concealer'] = {},
                  ['core.qol.todo_items'] = {},
                  ['core.integrations.zen_mode'] = {}
              }
          })
      end
    '';
  }
  {
    plugin = project-nvim;
    optional = true;
    type = "lua";
    config = ''
      if not vim.g.started_by_firenvim then
        vim.api.nvim_command('packadd project.nvim')
        require('project_nvim').setup()
        require('telescope').load_extension('projects')
        vim.keymap.set('n', '<Leader>fp', require('telescope').extensions.projects.projects, {desc = 'Projects'})
      end
    '';
  }
]
