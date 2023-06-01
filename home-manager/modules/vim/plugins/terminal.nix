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
]
