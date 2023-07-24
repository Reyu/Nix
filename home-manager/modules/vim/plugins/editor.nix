{ pkgs, ... }: with pkgs.vimPlugins; [
  {
    plugin = neo-tree-nvim;
    type = "lua";
    optional = true;
    config = ''
      if not vim.g.started_by_firenvim then
          vim.api.nvim_command('packadd neo-tree.nvim')
          local neo_tree = require('neo-tree')

          vim.g.neo_tree_remove_legacy_commands = 1
          neo_tree.setup({
              close_if_last_window = false,
              open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "edgy" },
              popup_border_style = 'rounded',
              enable_git_status = true,
              enable_diagnostics = true,
              sort_case_insensitive = true,
              filesystem = {
                  filtered_items = {
                      hide_by_name = {"__init__.py"},
                      never_show = {".devenv", ".direnv", "__pycache__"}
                  }
              },
              source_selector = {winbar = true},
              default_component_configs = {
                  diagnostics = {
                      symbols = {
                          hint = '',
                          info = '',
                          warn = '',
                          error = ''
                      },
                      highlights = {
                          hint = 'DiagnosticSignHint',
                          info = 'DiagnosticSignInfo',
                          warn = 'DiagnosticSignWarn',
                          error = 'DiagnosticSignError'
                      }
                  }
              }
          })

        vim.keymap.set('n', '<Leader>tt', '<CMD>Neotree<CR>',
                       {silent = true, desc = 'Toggle NeoTree'})
        vim.keymap.set('n', '<Leader>tT', '<CMD>Neotree show<CR>',
                       {silent = true, desc = 'Show NeoTree'})
        vim.keymap.set('n', '<Leader>tb', '<Cmd>Neotree position=top buffers<CR>',
                       {silent = true, desc = 'Toggle buffer list'})
        vim.keymap.set('n', '<Leader>tB', '<Cmd>Neotree position=top buffers show<CR>',
                       {silent = true, desc = 'Show buffer list'})
        vim.keymap.set('n', '<Leader>ts', '<Cmd>Neotree position=right git_status<CR>',
                       {silent = true, desc = 'Show Git Status'})
        vim.keymap.set('n', '<Leader>tS',
                       '<Cmd>Neotree position=right git_status show<CR>',
                       {silent = true, desc = 'Show Git Status'})
      end
    '';
  }
  {
    plugin = neoscroll-nvim;
    type = "lua";
    config = ''
      require('neoscroll').setup({easing_function = 'quadratic', respect_scrolloff = true})
    '';
  }
  {
    plugin = nvim-ufo;
    type = "lua";
    config = ''
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.o.foldcolumn = "1"
      require('ufo').setup()
    '';
  }
  {
    plugin = todo-comments-nvim;
    type = "lua";
    config = ''
      local todo_comments = require('todo-comments')
      todo_comments.setup()
      vim.keymap.set('n', ']t', todo_comments.jump_next, {desc = 'Next TODO comment'})
      vim.keymap.set('n', '[t', todo_comments.jump_prev, {desc = 'Previous TODO comment'})
    '';
  }
]
