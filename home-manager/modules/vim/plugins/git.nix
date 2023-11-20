{ pkgs, ... }: with pkgs.vimPlugins; [
  {
    plugin = gitsigns-nvim;
    optional = true;
    type = "lua";
    config = ''
      if not vim.g.started_by_firenvim then
          vim.api.nvim_command('packadd gitsigns.nvim')
          local gs = require('gitsigns')
          gs.setup({
              current_line_blame = true,
              on_attach = function(bufnr)
                  vim.keymap.set('n', ']c', gs.next_hunk, {desc = 'Next Git hunk'})
                  vim.keymap
                      .set('n', '[c', gs.prev_hunk, {desc = 'Previous Git hunk'})
              end
          })
      end
    '';
  }
  {
    plugin = vim-fugitive;
    optional = true;
    type = "lua";
    config = ''
      if not vim.g.started_by_firenvim then
          vim.api.nvim_command('packadd vim-fugitive')
          vim.keymap.set('n', '<Leader>gs', '<CMD>Git<CR>', {desc = 'Git Status'})
      end
    '';
  }
  {
    plugin = neogit;
    optional = true;
    type = "lua";
    config = ''
      if not vim.g.started_by_firenvim then
          vim.api.nvim_command('packadd neogit')
          require('neogit').setup({
              disable_commit_confirmation = true,
              integrations = {diffview = true}
          })
          vim.keymap.set('n', '<Leader>gn', require('neogit').open,
                         {desc = 'Open NeoGit'})
      end
    '';
  }
  {
    plugin = octo-nvim;
    optional = true;
    type = "lua";
    config = ''
      if not vim.g.started_by_firenvim then
          vim.api.nvim_command('packadd octo.nvim')
          vim.api.nvim_set_hl(0, 'OctoEditable', {bg = "#073642"})
          require('octo').setup()
          -- require('which_key').register({
          --     i = {name = "Issue"},
          --     c = {name = "Coment"},
          --     a = {name = "Assignee"},
          --     g = {name = "GoTo"},
          --     l = {name = "Label"},
          --     p = {name = "PR"},
          --     r = {name = "Reaction"},
          --     s = {name = "Suggestion"},
          --     v = {name = "Reviewer"}
          -- }, {prefix = "<LocalLeader>"})
      end
    '';
  }
]
