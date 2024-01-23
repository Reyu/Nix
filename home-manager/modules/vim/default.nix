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
      extraLuaConfig =
        let
          plugins = import ./plugins.nix { inherit config pkgs; };
          mkEntryFromDrv = drv:
            if lib.isDerivation drv then
              { name = "${lib.getName drv}"; path = drv; }
            else
              drv;
          lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
        in
        ''
          require("lazy").setup({
            defaults = {
              lazy = true,
            },
            dev = {
              -- reuse files from pkgs.vimPlugins
              path = "${lazyPath}",
              patterns = { "." },
              -- fallback to download
              fallback = true,
            },
            spec = {
              -- The following configs are needed for fixing lazyvim on nix
              -- force enable telescope-fzf-native.nvim
              { "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
              -- import/override with your plugins
              { import = "plugins" },
              -- treesitter handled by xdg.configFile."nvim/parser", put this line at the end of spec to clear ensure_installed
              { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = {} } },
            },
          })
        '';
      plugins = [ pkgs.vimPlugins.lazy-nvim ];
      extraPackages =
        if config.programs.neovim.minimal then
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
            biber
            fd
            gcc
            gh
            manix
            ripgrep
            texlive.combined.scheme-medium
            tree-sitter
            unzip
            xsel
          ];
    };
    xdg.configFile = {
      "nvim/lua/plugins/lsp/init.lua".source = ./lua/plugins/lsp/init.lua;
      "nvim/lua/plugins/lsp/keymaps.lua".source = ./lua/plugins/lsp/keymaps.lua;
      "nvim/lua/plugins/lsp/util.lua".source = ./lua/plugins/lsp/util.lua;
      "nvim/lua/plugins/coding.lua".source = ./lua/plugins/coding.lua;
      "nvim/lua/plugins/diagnostics.lua".source = ./lua/plugins/diagnostics.lua;
      "nvim/lua/plugins/editor.lua".source = ./lua/plugins/editor.lua;
      "nvim/lua/plugins/extra.lua".source = ./lua/plugins/extra.lua;
      "nvim/lua/plugins/git.lua".source = ./lua/plugins/git.lua;
      "nvim/lua/plugins/init.lua".source = ./lua/plugins/init.lua;
      "nvim/lua/plugins/treesitter.lua".source = ./lua/plugins/treesitter.lua;
      "nvim/lua/plugins/ui.lua".source = ./lua/plugins/ui.lua;
      "nvim/lua/reyu/init.lua".source = ./lua/reyu/init.lua;
      "nvim/lua/reyu/options.lua".source = ./lua/reyu/options.lua;
      "nvim/lua/reyu/util.lua".source = ./lua/reyu/util.lua;
    } // (with builtins;
      let
        # Includes all files in the given directory
        dirContets = dir:
          let
            files = attrNames (readDir ./${dir});
            mapped_files = map
              (file: {
                name = "nvim/${dir}/${file}";
                value = { source = ./${dir}/${file}; };
              })
              files;
          in
          listToAttrs mapped_files;

        # Needs to find `after/queries/{type}/{file}`
        query_files = concatMap
          (x: map (y: "${x}/${y}") (attrNames (readDir ./after/queries/${x})))
          (attrNames (readDir ./after/queries));
        query_map = map
          (x: {
            name = "nvim/after/queries/${x}";
            value = { source = ./after/queries/${x}; };
          })
          query_files;
        queries = listToAttrs query_map;

      in
      queries // dirContets "luasnippets" // dirContets "syntax");
  };
}
