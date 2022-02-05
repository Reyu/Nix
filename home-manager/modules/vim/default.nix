{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    withNodeJs = true;
    extraPython3Packages = ps: with ps; [ rope jedi ];
    plugins = with pkgs.vimPlugins; [
      # General
      impatient-nvim
      nvim-solarized-lua
      tmux-navigator
      telescope-nvim
      popup-nvim
      plenary-nvim
      FixCursorHold-nvim
      telescope-hoogle
      galaxyline-nvim
      nvim-web-devicons
      vimwiki
      mattn-calendar-vim
      nvim-ts-context-commentstring
      dashboard-nvim
      neoscroll-nvim
      vim-bbye
      nvim-tree-lua
      which-key-nvim
      gitsigns-nvim
      # symbols-outline-nvim

      # Must have T.Pope plugins
      vim-capslock
      vim-commentary
      vim-dispatch
      vim-eunuch
      vim-fugitive
      vim-obsession
      vim-projectionist
      vim-repeat
      vim-rhubarb
      vim-speeddating
      vim-surround
      vim-tbone
      vim-unimpaired

      # Completion
      cmp-buffer
      cmp-nvim-lsp
      cmp-path
      cmp_luasnip
      null-ls-nvim
      nvim-cmp
      nvim-lspconfig

      # Snippets
      luasnip
      friendly-snippets

      # Filetypes
      nvim-treesitter
      vim-polyglot
      vim-pandoc
      vim-pandoc-after
      vim-pandoc-syntax

      # Debugging
      nvim-dap
      nvim-dap-ui
      telescope-dap-nvim
      nvim-dap-virtual-text
    ];
    extraPackages = with pkgs; [
      # Language servers
      rnix-lsp
      terraform-ls
      nodePackages.bash-language-server
      nodePackages.vim-language-server
      nodePackages.yaml-language-server
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.vscode-html-languageserver-bin
      nodePackages.vscode-json-languageserver
      # Linters
      shellcheck
      yamllint
      ansible-lint
      nix-linter
      nixpkgs-lint
      sqlint
      # Formatters
      luaformatter
      nixfmt
      shfmt
      stylua
    ];
    extraConfig = ''
      lua require('reyu/init')
    '';
  };
  xdg.configFile = { "nvim/lua" = { source = ./lua; }; };
  home.file = {
    # We just want the directories, file contents doesn't matter.
    nvimBackup = {
      text = "";
      target = ".cache/nivm/backup/.keep";
    };
    nvimUndo = {
      text = "";
      target = ".cache/nivm/undo/.keep";
    };
    nvimSwap = {
      text = "";
      target = ".cache/nivm/swap/.keep";
    };
  };
}
