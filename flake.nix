{
  description = "Reyu Zenfold's NixOS Flake";

  inputs = {
    # Core
    nixpkgs.url = "github:nixos/nixpkgs";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus/1.3.0";
    devshell.url = "github:numtide/devshell";
    nixos-generators.url = "github:nix-community/nixos-generators";
    home-manager.url = "github:nix-community/home-manager";
    nur.url = "github:nix-community/NUR";
    mobile-nixos = {
      url = "github:NixOS/mobile-nixos";
      flake = false;
    };

    # Automatic deployment
    agenix.url = "github:ryantm/agenix";

    # ZSH Plugins
    zsh-vimode-visual = {
      url = "github:b4b4r07/zsh-vimode-visual";
      flake = false;
    };

    # Vim + Plugins
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";

    telescope-hoogle = {
      url = "github:luc-tielen/telescope_hoogle";
      flake = false;
    };
    vim-solarized8 = {
      url = "github:lifepillar/vim-solarized8";
      flake = false;
    };
    one-small-step-for-vimkind = {
      url = "github:jbyuki/one-small-step-for-vimkind";
      flake = false;
    };
    cmp-conventionalcommits = {
      url = "github:davidsierradz/cmp-conventionalcommits";
      flake = false;
    };
    cmp-dap = {
      url = "github:rcarriga/cmp-dap";
      flake = false;
    };
    cmp-nvim-lsp-signature-help = {
      url = "github:hrsh7th/cmp-nvim-lsp-signature-help";
      flake = false;
    };
    firenvim = {
      url = "github:glacambre/firenvim";
      flake = false;
    };
    nvim-treesitter-endwise = {
      url = "github:RRethy/nvim-treesitter-endwise";
      flake = false;
    };
    neotest = {
      url = "github:rcarriga/neotest";
      flake = false;
    };
    neotest-haskell = {
      url = "github:MrcJkb/neotest-haskell";
      flake = false;
    };
    neotest-python = {
      url = "github:rcarriga/neotest-python";
      flake = false;
    };
    neotest-vim-test = {
      url = "github:rcarriga/neotest-vim-test";
      flake = false;
    };
    netman = {
      url = "github:miversen33/netman.nvim";
      flake = false;
    };
    persistence-nvim = {
      url = "github:folke/persistence.nvim";
      flake = false;
    };
    neosolarized-nvim = {
      url = "github:Tsuzat/NeoSolarized.nvim";
      flake = false;
    };
    nvim-ufo = {
      url = "github:kevinhwang91/nvim-ufo";
      flake = false;
    };
    promise-async = {
      url = "github:kevinhwang91/promise-async";
      flake = false;
    };
    treesitter-playground = {
      url = "github:nvim-treesitter/playground";
      flake = false;
    };
    mind-nvim = {
      url = "github:Reyu/mind.nvim";
      flake = false;
    };
    mini-nvim = {
      url = "github:echasnovski/mini.nvim";
      flake = false;
    };
    stickybuf-nvim = {
      url = "github:stevearc/stickybuf.nvim";
      flake = false;
    };
    neogen = {
      url = "github:danymat/neogen";
      flake = false;
    };
    hydra = {
      url = "github:anuvyklack/hydra.nvim";
      flake = false;
    };
    haskell-tools-nvim = {
      url = "github:MrcJkb/haskell-tools.nvim";
      flake = false;
    };
    smart-splits = {
      url = "github:mrjones2014/smart-splits.nvim";
      flake = false;
    };
    bufresize-nvim = {
      url = "github:kwkarlwang/bufresize.nvim";
      flake = false;
    };

    # Discord + Plugins
    replugged.url = "github:LunNova/replugged-nix-flake";

    discord-better-status = {
      url = "github:GriefMoDz/better-status-indicators";
      flake = false;
    };
    discord-read-all = {
      url = "github:intrnl/powercord-read-all";
      flake = false;
    };
    discord-theme-slate = {
      url = "github:DiscordStyles/Slate";
      flake = false;
    };
    discord-theme-toggler = {
      url = "github:redstonekasi/theme-toggler";
      flake = false;
    };
    discord-tweaks = {
      url = "github:NurMarvin/discord-tweaks";
      flake = false;
    };
    discord-vc-timer = {
      url = "github:RazerMoon/vcTimer";
      flake = false;
    };

    # Other Sources
    kmonad.url = "github:kmonad/kmonad?dir=nix";
    mutt-trim = {
      url = "github:Konfekt/mutt-trim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, utils, ... }@inputs:
    utils.lib.mkFlake {
      # Required inputs of `mkFlake`
      inherit inputs self;

      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];

      sharedOverlays = with inputs; [
        agenix.overlay
        devshell.overlay
        neovim-nightly.overlay
        nur.overlay
        kmonad.overlays.default
        (import ./overlays { inherit inputs; })
      ];

      channelsConfig = {
        allowUnfreePredicate = pkg:
          builtins.elem (nixpkgs.lib.getName pkg) [
            "betterttv"
            "discord"
            "plexmediaserver"
            "slack"
            "steam"
            "steam-original"
            "steam-run"
            "steam-runtime"
          ];
      };

      channels.nixpkgs.overlaysBuilder = channels:
        [ (final: prev: { inherit (channels.unstable) neovim-unwrapped; }) ];

      hostDefaults.system = "x86_64-linux";
      hostDefaults.channelName = "unstable";
      hostDefaults.modules = with self.nixosModules; [
        "${inputs.home-manager}/nixos"
        {
          home-manager.extraSpecialArgs = { inherit inputs self; };
          home-manager.useGlobalPkgs = true;
        }
        ./users/reyu
        ./users/root
        age
        cachix
        crypto
        environment
        locale
        nix-common
        security
        ({ _, ... }: {
          _module.args = { inherit self; };

          # Let 'nixos-version --json' know the Git revision of this flake.
          system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          # flake-utils-plus options
          nix.generateRegistryFromInputs = true;
          nix.generateNixPathFromInputs = true;
          # Default stateVersion
          system.stateVersion = "22.05";
        })
      ];

      hosts = import ./hosts { inherit self inputs; };

      homeConfigurations = import ./home-manager { inherit self inputs; };

      outputsBuilder = channels:
        let pkgs = channels.nixpkgs;
        in {
          # construct packagesBuilder to export all packages defined in overlays
          packages = utils.lib.exportPackages self.overlays channels;

          # Evaluates to `devShell.<system> = <nixpkgs-channel-reference>.mkShell { name = "devShell"; };`.
          devShell = pkgs.devshell.mkShell {
            name = "FoxNet-Nix-Configs";
            packages = with pkgs; [ cachix rnix-lsp ];
            commands = [
              {
                name = "repl";
                package = pkgs.fup-repl;
                help = "A package that adds a kick-ass repl";
              }
              {
                name = "agenix";
                package = pkgs.agenix;
              }
              {
                package = pkgs.nixpkgs-fmt;
                category = "formatters";
              }
              { package = pkgs.nixos-generators; }
            ];
          };
        };

      overlays = utils.lib.exportOverlays { inherit (self) pkgs inputs; } // {
        default = import ./overlays { inherit inputs; };
      };

      nixosModules = {
        inherit (inputs.agenix.nixosModules) age;
        kmonad = inputs.kmonad.nixosModules.default;
      } // builtins.listToAttrs (map (x: {
        name = x;
        value = import (./modules + "/${x}");
      }) (builtins.attrNames (builtins.readDir ./modules)));

      homeModules = builtins.listToAttrs (map (x: {
        name = x;
        value = import ./home-manager/modules/${x};
      }) (builtins.attrNames (builtins.readDir ./home-manager/modules)));

      checks =
        # Checks to run with `nix flake check -L`, will run in a QEMU VM.
        # Looks for all ./modules/<module name>/test.nix files and adds them to
        # the flake's checks output. The test.nix file is optional and may be
        # added to any module.
        builtins.listToAttrs (map (x: {
          name = x;
          value = (import ./modules/${x}/test.nix) {
            pkgs = nixpkgs;
            inherit self;
          };
        })
        # Filter list of modules, leaving only modules which contain a
        # `test.nix` file
          (builtins.filter
            (p: builtins.pathExists (./modules/${p}/test.nix))
            (builtins.attrNames (builtins.readDir ./modules))));
    };
}
