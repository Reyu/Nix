{ config, pkgs, ... }: {
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  home.packages = [
    (pkgs.neovim-qt.override { neovim = config.programs.neovim.finalPackage; })
  ];
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    withNodeJs = true;
    extraPython3Packages = ps: with ps; [ rope jedi ];
    extraConfig = "lua require('reyu/init')";
    package = pkgs.neovim-nightly;
    plugins = with pkgs.vimPlugins; [
      # Themes
      NeoSolarized

      # General
      FixCursorHold-nvim
      dashboard-nvim
      direnv-vim
      fidget-nvim
      firenvim
      gitsigns-nvim
      impatient-nvim
      lualine-nvim
      mattn-calendar-vim
      neoscroll-nvim
      nvim-autopairs
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
      goyo
      easy-align
      netman
      telescope-ui-select-nvim
      lsp_lines-nvim
      neorg

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
      cmp-calc
      cmp-cmdline
      cmp-conventionalcommits
      cmp-dap
      cmp-emoji
      cmp-latex-symbols
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
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
      (nvim-treesitter.withPlugins (plugins:
        with plugins; [
          tree-sitter-bash
          tree-sitter-comment
          tree-sitter-dockerfile
          tree-sitter-haskell
          tree-sitter-hcl
          tree-sitter-json
          tree-sitter-latex
          tree-sitter-ledger
          tree-sitter-lua
          tree-sitter-make
          tree-sitter-markdown
          tree-sitter-nix
          tree-sitter-norg
          tree-sitter-python
          tree-sitter-rst
          tree-sitter-toml
          tree-sitter-vim
          tree-sitter-yaml
        ]))
      nvim-treesitter-endwise
      vim-polyglot
      vim-pandoc
      vim-pandoc-after
      vim-pandoc-syntax

      # Testing & Debugging
      neotest
      neotest-python
      neotest-vim-test
      nvim-dap
      nvim-dap-ui
      nvim-dap-virtual-text
      one-small-step-for-vimkind
      telescope-dap-nvim
      vim-test
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
      proselint
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
      lolcat
    ];
  };
  xdg.configFile = { "nvim/lua" = { source = ./lua; }; };
}
