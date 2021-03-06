{
  description = "Reyu Zenfold's NixOS Flake";

  inputs = {
    # Core
    nixpkgs.url = "github:nixos/nixpkgs";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    devshell.url = "github:numtide/devshell";
    mobile-nixos = {
      url = github:NixOS/mobile-nixos;
      flake = false;
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Automatic deployment
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "utils";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ZSH Plugins
    zsh-vimode-visual = {
      url = "github:b4b4r07/zsh-vimode-visual";
      flake = false;
    };

    # Vim + Plugins
    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "utils";
    };

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
    neotest-python = {
      url = "github:rcarriga/neotest-python";
      flake = false;
    };
    neotest-vim-test = {
      url = "github:rcarriga/neotest-vim-test";
      flake = false;
    };

    # Discord + Plugins
    powercord = {
      url = "github:LavaDesu/powercord-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "utils";
    };

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
    mutt-trim = {
      url = "github:Konfekt/mutt-trim";
      flake = false;
    };

    # TODO: try this
    # kmonad = {
    #   url = "github:kmonad/kmonad?dir=nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # Region Deployments
    # deploy-linode = {
    #   url = "./regions/linode";
    # };
  };
  outputs = { self, ... }@inputs:
    with inputs;
    let extraSpecialArgs = { inherit inputs self; };
    in
    utils.lib.mkFlake {
      inherit self inputs;

      sharedOverlays = [
        agenix.overlay
        deploy-rs.overlay
        devshell.overlay
        neovim-nightly.overlay
        nur.overlay
        powercord.overlay
        self.overlay
      ];

      channelsConfig = { allowUnfree = true; };

      channels.nixpkgs.overlaysBuilder = channels:
        [ (final: prev: { inherit (channels.unstable) neovim-unwrapped; }) ];

      hostDefaults.modules = with self.nixosModules; [
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
          # Default stateVersion
          system.stateVersion = "22.05";

          # Let 'nixos-version --json' know the Git revision of this flake.
          system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          nix.registry.nixpkgs.flake = nixpkgs;
          nix.registry.pinpox.flake = self;
        })
      ];

      hosts = with self.nixosModules; {
        loki = {
          modules = [
            ./hosts/loki/configuration.nix
            consul
            docker
            flatpak
            kerberos
            ldap
            onlykey
            sound
            xserver
          ];
        };
        burrow = {
          modules = [
            ./hosts/burrow/configuration.nix
            consul
            vault
            nomad
            docker
            kerberos
            ldap
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

      homeConfigurations =
        let
          inherit extraSpecialArgs;
          hmConfig = home-manager.lib.homeManagerConfiguration;
        in
        {
          desktop = hmConfig {
            inherit extraSpecialArgs;
            pkgs = self.pkgs.x86_64-linux.nixpkgs;
            modules = [
              { home = { username = "reyu"; homeDirectory = "/home/reyu"; }; }
              ./home-manager/profiles/desktop.nix
            ];
          };
          server = hmConfig {
            inherit extraSpecialArgs;
            pkgs = self.pkgs.x86_64-linux.nixpkgs;
            modules = [
              { home = { username = "reyu"; homeDirectory = "/home/reyu"; }; }
              ./home-manager/profiles/server.nix
            ];
          };
          minimalRoot = hmConfig {
            inherit extraSpecialArgs pkgs;
            modules = [
              ./home-manager/modules/shell
              {
                manual.manpages.enable = true;
                home = {
                  username = "root";
                  homeDirectory = "/root";
                  packages = [ pkgs.htop ];
                  sessionVariables = {
                    EDITOR = "nvim";
                    VISUAL = "nvim";
                  };
                };
              }
            ];
          };
        };

      deploy.nodes =
        let
          inherit (deploy-rs.lib.x86_64-linux.activate) nixos home-manager custom;
          host = x: nixos self.nixosConfigurations."${x}";
          user = x: home-manager self.homeConfigurations."${x}";
        in
        {
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
        in
        {
          # construct packagesBuilder to export all packages defined in overlays
          packages = utils.lib.exportPackages self.overlays channels;

          # Evaluates to `devShell.<system> = <nixpkgs-channel-reference>.mkShell { name = "devShell"; };`.
          devShell = pkgs.devshell.mkShell {
            name = "FoxNet-Nix-Configs";
            packages = with pkgs; [
              cachix
              rnix-lsp
            ];
            commands = [
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
              {
                package = pkgs.nixos-generators;
              }
            ];
          };
        };

      # Run deploy-rs as the default app
      defaultApp = deploy-rs.defaultApp;

      overlay = import ./overlays { inherit inputs; };
      overlays = utils.lib.exportOverlays { inherit (self) pkgs inputs; };

      nixosModules = { age = agenix.nixosModules.age; } // builtins.listToAttrs (map
        (x: {
          name = x;
          value = import (./modules + "/${x}");
        })
        (builtins.attrNames (builtins.readDir ./modules)));

      homeModules = builtins.listToAttrs (map (x: {
        name = x;
        value = import (./home-manager/modules + "/${x}");
      })
      (builtins.attrNames (builtins.readDir ./home-manager/modules)));

      checks =
        let
          # Sanity check for deploy-rs systems
          deploments = builtins.mapAttrs
            (system: deployLib: deployLib.deployChecks self.deploy)
            deploy-rs.lib;

          # Checks to run with `nix flake check -L`, will run in a QEMU VM.
          # Looks for all ./modules/<module name>/test.nix files and adds them to
          # the flake's checks output. The test.nix file is optional and may be
          # added to any module.
          modules = builtins.listToAttrs (map
            (x: {
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
        in
        deploments // modules;
    };
}
