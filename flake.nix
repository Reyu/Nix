{
  description = "Reyu Zenfold's NixOS Flake";

  inputs = {
    # Core
    nixpkgs.url = "github:nixos/nixpkgs";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
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

    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    telescope-hoogle = {
      url = "github:luc-tielen/telescope_hoogle";
      flake = false;
    };
    vim-solarized8 = {
      url = "github:lifepillar/vim-solarized8";
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

  };
  outputs = { self, ... }@inputs:
    with inputs;
    utils.lib.mkFlake {
      inherit self inputs;

      sharedOverlays =
        [ self.overlay nur.overlay neovim-nightly.overlay powercord.overlay ];

      channelsConfig = { allowUnfree = true; };

      channels.nixpkgs.overlaysBuilder = channels:
        [ (final: prev: { inherit (channels.unstable) neovim-unwrapped; }) ];

      # All local modules have an `enable` option, so it is safe to add
      # everything
      hostDefaults.modules = builtins.attrValues self.nixosModules ++ [
        home-manager.nixosModules.home-manager
        ({ ... }: {
          home-manager.useUserPackages = true;

          # Let 'nixos-version --json' know the Git revision of this flake.
          system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          nix.registry.nixpkgs.flake = nixpkgs;
          nix.registry.pinpox.flake = self;
        })
      ];

      hosts = let
        inherit (builtins) attrNames readDir listToAttrs;
        inherit (nixpkgs.lib) head splitString;

        # Gather available profiles
        profiles = listToAttrs
        (map (x: {
          name = (head (splitString "." x));
          value = (./profiles + "/${x}");
        }) (attrNames (readDir ./profiles)));

        # Add all hosts under `./hosts` and import
        # `./host/<name>/configuration.nix` by default
        defaults = listToAttrs (map (x: {
          name = x;
          value = { modules = [ (./hosts + "/${x}/configuration.nix") ]; };
        }) (attrNames (readDir ./hosts)));

      in defaults // {
        loki = {
          channelName = "unstable";
          modules = with profiles; [
            ./hosts/loki/configuration.nix
            desktop
          ];
        };
        burrow = {
          modules = with profiles; [
            ./hosts/burrow/configuration.nix
            server
          ];
        };
      };

      homeConfigurations = let
        homeConfig = { profile, system ? "x86_64-linux", username ? "reyu"
          , homeDirectory ? "/home/${username}" }:
          home-manager.lib.homeManagerConfiguration {
            inherit system username homeDirectory;
            pkgs = self.pkgs.${system}.nixpkgs;
            extraSpecialArgs = { flake-inputs = inputs; };
            configuration = {
              imports = [ (./home-manager + "/home-${profile}.nix") ];
            };
          };
      in {
        desktop = homeConfig { profile = "desktop"; };
        server = homeConfig { profile = "server"; };
      };

      deploy.nodes = {
        loki = {
          hostname = "loki.home.reyuzenfold.com";
          profiles = {
            system = {
              sshUser = "root";
              path = deploy-rs.lib.x86_64-linux.activate.nixos
                self.nixosConfigurations.loki;
            };
            # TODO: Wait for home-manager to support new nix-profile
            #   OR: Figure out why desktop is forcing profiles...
            # hm-reyu = {
            #   user = "reyu";
            #   path = deploy-rs.lib.x86_64-linux.activate.home-manager
            #     self.homeConfigurations.desktop;
            # };
          };
        };
        burrow = {
          hostname = "burrow.home.reyuzenfold.com";
          profiles = {
            system = {
              sshUser = "root";
              path = deploy-rs.lib.x86_64-linux.activate.nixos
                self.nixosConfigurations.burrow;
            };
            hm-reyu = {
              user = "reyu";
              path = deploy-rs.lib.x86_64-linux.activate.home-manager
                self.homeConfigurations.server;
            };
          };
        };
      };

      outputsBuilder = channels: {
        # construct packagesBuilder to export all packages defined in overlays
        packages = utils.lib.exportPackages self.overlays channels;

        # Evaluates to `devShell.<system> = <nixpkgs-channel-reference>.mkShell { name = "devShell"; };`.
        devShell = channels.nixpkgs.mkShell { name = "devShell"; };
      };

      # Run deploy-rs as the default app
      defaultApp = deploy-rs.defaultApp;

      overlay = import ./overlays { inherit inputs; };
      overlays = utils.lib.exportOverlays { inherit (self) pkgs inputs; };

      nixosModules = builtins.listToAttrs (map (x: {
        name = x;
        value = import (./modules + "/${x}");
      }) (builtins.attrNames (builtins.readDir ./modules)));

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
          # Filter list of modules, leaving only modules which contain a
          # `test.nix` file
        }) (builtins.filter
          (p: builtins.pathExists (./modules + "/${p}/test.nix"))
          (builtins.attrNames (builtins.readDir ./modules))));
      in deploments // modules;
    };
}
