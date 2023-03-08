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
      {
        plugin = lazy-nvim;
        type = "lua";
        config = ''
          require('reyu.options')
          require("lazy").setup({
              defaults = {
                  lazy = true,
              },
              import = "plugins"
          })
        '';
      }
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
