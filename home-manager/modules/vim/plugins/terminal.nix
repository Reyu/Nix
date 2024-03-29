{ pkgs, ... }: with pkgs.vimPlugins; [
  {
    plugin = nvterm;
    type = "lua";
    config = ''
      if not vim.g.started_by_firenvim then
          require('nvterm').setup({behaviour = {autoclose_on_quit = {enabled = true}}})
      end
    '';
  }
  {
    plugin = nvim-terminal-lua;
    type = "lua";
    config = ''
      if not vim.g.started_by_firenvim then
        require('terminal').setup()
      end
    '';
  }
  {
    plugin = toggleterm-nvim;
    type = "lua";
    optional = true;
    config = ''
      if not vim.g.started_by_firenvim then
          vim.api.nvim_command('packadd toggleterm.nvim')
          require("toggleterm").setup({
              open_mapping = [[<c-\>]],
              start_in_insert = true,
              terminal_mappings = true,
              persist_mode = true,
              direction = 'horizontal',
              close_on_exit = true,
              auto_scroll = true
          })
          vim.keymap.set('t', '<esc><esc>', [[<C-\><C-n>]], {buffer = 0})
          vim.keymap.set('n', '<LocalLeader>sl', "<CMD>ToggleTermSendCurrentLine<CR>", { desc = "Send line to terminal", silent = true })
          vim.keymap.set('v', '<LocalLeader>sl', "<CMD>ToggleTermSendVisualLines<CR>", { desc = "Send line to terminal", silent = true })
          vim.keymap.set('v', '<LocalLeader>ss', "<CMD>ToggleTermSendVisualSelection<CR>", { desc = "Send selection to terminal", silent = true })
      end
    '';
  }
]
