{ pkgs, ... }: with pkgs.vimPlugins; [
  {
    plugin = telescope-nvim;
    optional = true;
    type = "lua";
    config = ''
      if not vim.g.started_by_firenvim then
          vim.api.nvim_command('packadd telescope.nvim')
          require('telescope').setup({
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
                  git_files = {theme = 'dropdown'}
              },
              extensions = {
                  ['ui-select'] = {require('telescope.themes').get_dropdown({})}
              }
          })
          require("which-key").register({["<Leader>f"] = {name = "Find"}})

          local ts_builtin = require('telescope.builtin')
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

          vim.keymap.set('n', '<Leader>ff', filesOrGit, {desc = 'File Picker'})
          vim.keymap.set('n', '<Leader>fb', ts_builtin.buffers,
                         {desc = 'Buffer Picker'})
          vim.keymap
              .set('n', '<Leader>fg', ts_builtin.live_grep, {desc = 'Live Grep'})
          vim.keymap.set('n', '<Leader>fh', ts_builtin.help_tags,
                         {desc = 'Help Tags Picker'})
          vim.keymap.set('n', '<Leader>fo', ts_builtin.oldfiles,
                         {desc = 'Old Files Picker'})
          vim.keymap.set('n', '<Leader>fm', ts_builtin.marks, {desc = 'Marks Picker'})
      end
    '';
  }
  {
    plugin = telescope-dap-nvim;
    optional = true;
    type = "lua";
    config = ''
      if not vim.g.started_by_firenvim then
          vim.api.nvim_command('packadd telescope-dap.nvim')
          require('telescope').load_extension('dap')
      end
    '';
  }
  {
    plugin = telescope-manix;
    optional = true;
    type = "lua";
    config = ''
      if not vim.g.started_by_firenvim then
          vim.api.nvim_command('packadd telescope-manix')
          require('telescope').load_extension('manix')
      end
    '';
  }
  {
    plugin = telescope-undo-nvim;
    optional = true;
    type = "lua";
    config = ''
      if not vim.g.started_by_firenvim then
          vim.api.nvim_command('packadd telescope-undo.nvim')
          require('telescope').load_extension('undo')
      end
    '';
  }
  {
    plugin = telescope_hoogle;
    optional = true;
    type = "lua";
    config = ''
      if not vim.g.started_by_firenvim then
          vim.api.nvim_command('packadd telescope_hoogle')
          require('telescope').load_extension('hoogle')
      end
    '';
  }
  {
    plugin = telescope-ui-select-nvim;
    optional = true;
    type = "lua";
    config = ''
      if not vim.g.started_by_firenvim then
          vim.api.nvim_command('packadd telescope-ui-select.nvim')
          require('telescope').load_extension('ui-select')
      end
    '';
  }
]
