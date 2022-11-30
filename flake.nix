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
    deploy-rs.url = "github:serokell/deploy-rs";
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
  outputs = { self, ... }@inputs:
    with inputs;
    let
      extraSpecialArgs = { inherit inputs self; };
      pkgs = self.pkgs.x86_64-linux.nixpkgs;
    in utils.lib.mkFlake {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];

      sharedOverlays = [
        agenix.overlay
        deploy-rs.overlay
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
            "obsidian"
            "plexmediaserver"
            "slack"
            "steam"
            "steam-original"
            "steam-run"
            "steam-runtime"
            "unrar"
          ];
      };

      channels.nixpkgs.overlaysBuilder = channels:
        [ (final: prev: { inherit (channels.unstable) neovim-unwrapped; }) ];

      hostDefaults.system = "x86_64-linux";
      hostDefaults.channelName = "unstable";
      hostDefaults.modules = with self.nixosModules; [
        "${home-manager}/nixos"
        {
            home-manager.extraSpecialArgs = { inherit inputs self; };
            home-manager.useGlobalPkgs = true;
        }
        ./users/root.nix
        ./users/reyu.nix
        age
        cachix
        crypto
        environment
        locale
        nix-common
        security
        ({ ... }: {
          # Let 'nixos-version --json' know the Git revision of this flake.
          system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          # flake-utils-plus options
          nix.generateRegistryFromInputs = true;
          nix.generateNixPathFromInputs = true;
          # Default stateVersion
          system.stateVersion = "22.05";
        })
      ];

      hosts = with self.nixosModules; {
        loki = {
          modules = [
            ./hosts/loki/configuration.nix
            flatpak
            onlykey
            sound
            xserver
            kmonad.nixosModules.default
          ];
        };
        burrow = {
          modules = [
            ./hosts/burrow/configuration.nix
            consul
            docker
            nomad
            telegraf
            vault
          ];
        };
        kit = {
          system = "aarch64-linux";
          modules = [
            ./hosts/kit/configuration.nix
            (import "${mobile-nixos}/lib/configuration.nix" {
              device = "pine64-pinephone";
            })
            onlykey
          ];
        };
      };

      homeConfigurations = let
        hmConfig = home-manager.lib.homeManagerConfiguration;
      in {
        desktop = hmConfig {
          extraSpecialArgs = { inherit inputs self; };
          pkgs = self.pkgs.x86_64-linux.nixpkgs;
          modules = [
            {
              home = {
                username = "reyu";
                homeDirectory = "/home/reyu";
              };
            }
            ./home-manager/profiles/desktop.nix
          ];
        };
        server = hmConfig {
          extraSpecialArgs = { inherit inputs self; };
          pkgs = self.pkgs.x86_64-linux.nixpkgs;
          modules = [
            {
              home = {
                username = "reyu";
                homeDirectory = "/home/reyu";
              };
            }
            ./home-manager/profiles/server.nix
          ];
        };
        minimalRoot = hmConfig {
          extraSpecialArgs = { inherit inputs self; };
          pkgs = self.pkgs.x86_64-linux.nixpkgs;
          modules = [
            ./home-manager/profiles/common.nix
            {
              manual.manpages.enable = true;
              home = {
                username = "root";
                homeDirectory = "/root";
              };
            }
          ];
        };
      };

      deploy.nodes = let
        inherit (deploy-rs.lib.x86_64-linux.activate) nixos home-manager custom;
        host = x: nixos self.nixosConfigurations."${x}";
        user = x: home-manager self.homeConfigurations."${x}";
      in {
        loki = {
          hostname = "loki.home.reyuzenfold.com";
          profiles = {
            system = {
              sshUser = "root";
              path = host "loki";
            };
            hm-reyu = {
              user = "reyu";
              path = user "desktop";
            };
            hm-root = {
              sshUser = "root";
              path = user "minimalRoot";
            };
          };
        };
        burrow = {
          hostname = "burrow.home.reyuzenfold.com";
          profiles = {
            system = {
              sshUser = "root";
              path = host "burrow";
            };
            hm-reyu = {
              user = "reyu";
              path = user "server";
            };
            hm-root = {
              sshUser = "root";
              path = user "minimalRoot";
            };
          };
        };
        kit = {
          hostname = "172.16.128.9";
          profiles = {
            hm-reyu = {
              user = "reyu";
              path = user "minimalRoot";
            };
          };
        };
      };

      outputsBuilder = channels:
        let pkgs = channels.nixpkgs;
        in {
          # construct packagesBuilder to export all packages defined in overlays
          packages = (utils.lib.exportPackages self.overlays channels);

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
                name = "deploy";
                package = pkgs.deploy-rs.deploy-rs;
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
        age = agenix.nixosModules.age;
      } // builtins.listToAttrs (map (x: {
        name = x;
        value = import (./modules + "/${x}");
      }) (builtins.attrNames (builtins.readDir ./modules)));

      homeModules = builtins.listToAttrs (map (x: {
        name = x;
        value = import (./home-manager/modules + "/${x}");
      }) (builtins.attrNames (builtins.readDir ./home-manager/modules)));

      checks = let
        # Sanity check for deploy-rs systems
        deploments = builtins.mapAttrs
          (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

        # Checks to run with `nix flake check -L`, will run in a QEMU VM.
        # Looks for all ./modules/<module name>/test.nix files and adds them to
        # the flake's checks output. The test.nix file is optional and may be
        # added to any module.
        modules = builtins.listToAttrs (map (x: {
          name = x;
          value = (import (./modules + "/${x}/test.nix")) {
            pkgs = nixpkgs;
            inherit self;
          };
        })
        # Filter list of modules, leaving only modules which contain a
        # `test.nix` file
          (builtins.filter
            (p: builtins.pathExists (./modules + "/${p}/test.nix"))
            (builtins.attrNames (builtins.readDir ./modules))));
      in deploments // modules;
    };
}
