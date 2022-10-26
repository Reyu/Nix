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
    extraConfig = ''
      " vim
      lua require("reyu.init")
    '';
    package = pkgs.neovim-nightly;
    plugins = with pkgs.vimPlugins; [
      # Themes
      neosolarized-nvim

      # General
      direnv-vim
      fidget-nvim
      firenvim
      gitsigns-nvim
      neoscroll-nvim
      nvim-tree-lua
      nvim-web-devicons
      octo-nvim
      telescope-hoogle
      telescope-nvim
      tmux-navigator
      which-key-nvim
      easy-align
      netman
      telescope-ui-select-nvim
      lsp_lines-nvim
      lualine-nvim
      zen-mode-nvim
      twilight-nvim
      nvim-ufo
      mind-nvim
      mini-nvim
      aerial-nvim
      stickybuf-nvim
      nvim-notify
      nvim-bqf
      neogen
      hydra
      toggleterm-nvim

      # Must have T.Pope plugins
      vim-eunuch
      vim-fugitive
      vim-projectionist

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
      # friendly-snippets

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
          tree-sitter-markdown-inline
          tree-sitter-nix
          tree-sitter-python
          tree-sitter-sql
          tree-sitter-rst
          tree-sitter-toml
          tree-sitter-vim
          tree-sitter-yaml
        ]))
      treesitter-playground
      nvim-treesitter-endwise
      nvim-ts-rainbow
      nvim-ts-context-commentstring
      nvim-treesitter-context
      # vim-polyglot
      vim-pandoc
      vim-pandoc-after
      vim-pandoc-syntax
      { plugin = vim-ledger; optional = true; }

      # Testing & Debugging
      neotest
      neotest-python
      neotest-vim-test
      nvim-dap
      nvim-dap-ui
      nvim-dap-virtual-text
      telescope-dap-nvim
      vim-test
      trouble-nvim

      # Dependency/Library packages
      SchemaStore-nvim
      plenary-nvim
      popup-nvim
      FixCursorHold-nvim
      promise-async
    ];
    extraPackages = with pkgs; [
      # Language servers
      nodePackages.bash-language-server
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.vim-language-server
      nodePackages.vscode-json-languageserver-bin
      nodePackages.yaml-language-server
      rnix-lsp
      terraform-ls

      # Linters
      actionlint
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
  # Vim package to neatly contain customizations.
  xdg.dataFile = { "nvim/site/pack/reyu" = { source = ./pack; }; };
}
