{ config, pkgs, lib, ... }: {
  options = {
    programs.neovim.minimal = lib.mkOption {
      type = lib.types.bool;
      description = "Minimal NeoVim configuration";
      default = true;
    };
  };

  config = {
    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    home.packages = [
      (pkgs.neovim-qt.override {
        neovim = config.programs.neovim.finalPackage;
      })
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
      extraLuaConfig = ''
        vim.loader.enable()
        require('reyu.options')
        vim.api.nvim_create_augroup('plugins', {clear = true})
      '';
      plugins = import ./plugins { inherit config pkgs; };
      extraPackages = if config.programs.neovim.minimal then
        with pkgs; [ fd tree-sitter ]
      else
        with pkgs; [
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
          gh
          texlive.combined.scheme-medium
          tree-sitter
          unzip
          xsel
        ];
    };
    xdg.configFile = {
      "nvim/lua/reyu.lua".source = ./lua/reyu.lua;
      "nvim/lua/reyu/options.lua".source = ./lua/reyu/options.lua;
      "nvim/lua/reyu/util.lua".source = ./lua/reyu/util.lua;
    } // (with builtins;
      let
        # Includes all files in the given directory
        dirContets = (dir:
          let
            files = attrNames (readDir ./${dir});
            mapped_files = map (file: {
              name = "nvim/${dir}/${file}";
              value = { source = ./${dir}/${file}; };
            }) files;
          in listToAttrs mapped_files);

        # Needs to find `after/queries/{type}/{file}`
        query_files = concatMap
          (x: map (y: "${x}/${y}") (attrNames (readDir ./after/queries/${x})))
          (attrNames (readDir ./after/queries));
        query_map = map (x: {
          name = "nvim/after/queries/${x}";
          value = { source = ./after/queries/${x}; };
        }) query_files;
        queries = listToAttrs query_map;

      in queries // dirContets "luasnippets" // dirContets "syntax");
  };
}
