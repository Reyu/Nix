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
      FixCursorHold-nvim
      dashboard-nvim
      direnv-vim
      fidget-nvim
      gitsigns-nvim
      impatient-nvim
      lualine-nvim
      mattn-calendar-vim
      neoscroll-nvim
      nvim-solarized-lua
      nvim-tree-lua
      nvim-ts-context-commentstring
      nvim-web-devicons
      octo-nvim
      plenary-nvim
      popup-nvim
      telescope-hoogle
      telescope-nvim
      tmux-navigator
      vim-bbye
      vim-ledger
      vimwiki
      which-key-nvim

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
      vim-dadbod
      vim-dadbod-ui

      # Completion
      cmp-buffer
      cmp-cmdline
      cmp-calc
      # cmp-conventionalcommits
      # cmp-dap
      cmp-nvim-lsp
      cmp-path
      cmp-treesitter
      cmp_luasnip
      lspkind-nvim
      null-ls-nvim
      nvim-cmp
      nvim-lspconfig
      vim-dadbod-completion

      # Snippets
      luasnip
      friendly-snippets

      # Filetypes
      nvim-treesitter
      vim-polyglot
      vim-pandoc
      vim-pandoc-after
      vim-pandoc-syntax

      # Testing & Debugging
      nvim-dap
      nvim-dap-ui
      nvim-dap-virtual-text
      one-small-step-for-vimkind
      telescope-dap-nvim
      vim-test
      vim-ultest
    ];
    extraPackages = with pkgs; [
      # Language servers
      nodePackages.bash-language-server
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.vim-language-server
      nodePackages.vscode-html-languageserver-bin
      nodePackages.vscode-json-languageserver
      nodePackages.yaml-language-server
      rnix-lsp
      terraform-ls
      # Linters
      ansible-lint
      editorconfig-checker
      gitlint
      nix-linter
      nixpkgs-lint
      shellcheck
      sqlint
      yamllint
      # Formatters
      luaformatter
      nixfmt
      shfmt
      stylua
      # Utilities
      gh
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
