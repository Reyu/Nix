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
    package = pkgs.neovim-nightly;
    plugins = with pkgs.vimPlugins; [
      # Theme
      neosolarized-nvim

      # Interface
      gitsigns-nvim
      hydra
      lualine-nvim
      neo-tree-nvim
      neoscroll-nvim
      noice-nvim
      nvim-notify
      twilight-nvim
      vim-fugitive
      which-key-nvim
      zen-mode-nvim
      nvim-ufo

      # Fuzzy finder / Picker
      telescope-dap-nvim
      telescope-frecency-nvim
      telescope-hoogle
      telescope-nvim
      telescope-ui-select-nvim

      # Completion and Snippets
      nvim-cmp
      luasnip
      cmp-buffer
      cmp-calc
      cmp-conventionalcommits
      cmp-dap
      cmp-dictionary
      cmp-digraphs
      cmp-emoji
      cmp-git
      cmp-greek
      cmp-latex-symbols
      cmp-nvim-lsp
      cmp-nvim-lsp-document-symbol
      cmp-nvim-lsp-signature-help
      cmp-nvim-lua
      cmp-nvim-tags
      cmp-pandoc-nvim
      cmp-path
      cmp-tmux
      cmp-treesitter
      cmp-under-comparator
      cmp_luasnip
      lspkind-nvim

      # Filetypes
      (nvim-treesitter.withPlugins (plugins:
        with plugins; [
          tree-sitter-bash
          tree-sitter-comment
          tree-sitter-dockerfile
          tree-sitter-haskell
          tree-sitter-hcl
          tree-sitter-json
          tree-sitter-jsonc
          tree-sitter-latex
          tree-sitter-regex
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
      nvim-treesitter-context
      nvim-treesitter-endwise
      nvim-treesitter-textobjects
      nvim-ts-context-commentstring
      treesitter-playground

      # Debug & Testing
      lspkind-nvim
      neodev-nvim
      neotest
      neotest-haskell
      neotest-python
      neotest-vim-test
      null-ls-nvim
      nvim-dap
      nvim-dap-python
      nvim-dap-ui
      nvim-dap-virtual-text
      nvim-lspconfig
      trouble-nvim

      # Project management
      neoconf-nvim

      # Dependencies
      nui-nvim # noice-nvim | neo-tree-nvim
      nvim-web-devicons # telescope-frecency-nvim(opt) | neo-tree-nvim | trouble-nvim
      plenary-nvim # telescope-nvim | neo-tree-nvim | neotest | refactoring-nvim
      promise-async # nvim-ufo
      refactoring-nvim # null-ls
      smart-splits-nvim # hydra
      sqlite-lua # telescope-frecency-nvim

      # Other
      mini-nvim
      firenvim
      SchemaStore-nvim
      direnv-vim
    ];
    extraPackages = with pkgs; [
      # Language servers
      nodePackages.bash-language-server
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.vim-language-server
      nodePackages.vscode-json-languageserver-bin
      nodePackages.yaml-language-server
      rnix-lsp
      statix
      sumneko-lua-language-server
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
      deadnix
      luaformatter
      nixfmt
      shfmt
      stylua

      # Extras
      fd
      gcc
      tree-sitter
      xsel
    ];
  };
  # Vim package to neatly contain customizations.
  xdg.dataFile = { "nvim/site/pack/home-manager" = { source = ./pack; }; };
}
