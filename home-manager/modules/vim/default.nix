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
          require("reyu.options")
          require("lazy").setup({import = "plugins"}, {
              defaults = {lazy = true},
              install = {missing = true, colorscheme = {"NeoSolarized"}},
              checker = {enabled = true}
          })
        '';
        runtime = {
          "lua/plugins/coding.lua".source = ./lua/plugins/coding.lua;
          "lua/plugins/diagnostics.lua".source = ./lua/plugins/diagnostics.lua;
          "lua/plugins/editor.lua".source = ./lua/plugins/editor.lua;
          "lua/plugins/extra.lua".source = ./lua/plugins/extra.lua;
          "lua/plugins/git.lua".source = ./lua/plugins/git.lua;
          "lua/plugins/init.lua".source = ./lua/plugins/init.lua;
          "lua/plugins/lsp/init.lua".source = ./lua/plugins/lsp/init.lua;
          "lua/plugins/lsp/keymaps.lua".source = ./lua/plugins/lsp/keymaps.lua;
          "lua/plugins/lsp/util.lua".source = ./lua/plugins/lsp/util.lua;
          "lua/plugins/treesitter.lua".source = ./lua/plugins/treesitter.lua;
          "lua/plugins/ui.lua".source = ./lua/plugins/ui.lua;
          "lua/plugins/util.lua".source = ./lua/plugins/util.lua;
        };
      }
      nvim-treesitter.withAllGrammars
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
      unzip
    ];
  };
  xdg.configFile = {
    "nvim/after/queries/nix/injections.scm".source = ./after/queries/nix/injections.scm;
    "nvim/lua/reyu.lua".source = ./lua/reyu.lua;
    "nvim/lua/reyu/options.lua".source = ./lua/reyu/options.lua;
    "nvim/lua/reyu/util.lua".source = ./lua/reyu/util.lua;
    "nvim/luasnippets/haskell.lua".source = ./luasnippets/haskell.lua;
    "nvim/luasnippets/nvim-lua.lua".source = ./luasnippets/nvim-lua.lua;
  };
}
