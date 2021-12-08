{
  description = "Reyu Zenfold's NixOS Flake";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly.inputs.flake-utils.follows = "flake-utils";

    # Vim Plugins
    cmp-buffer.url = "github:hrsh7th/cmp-buffer";
    cmp-buffer.flake = false;

    cmp-nvim-lsp.url = "github:hrsh7th/cmp-nvim-lsp";
    cmp-nvim-lsp.flake = false;

    nvim-cmp.url = "github:hrsh7th/nvim-cmp";
    nvim-cmp.flake = false;

    telescope-hoogle.url = "github:luc-tielen/telescope_hoogle";
    telescope-hoogle.flake = false;

    vim-solarized8.url = "github:lifepillar/vim-solarized8";
    vim-solarized8.flake = false;

    # Other Sources
    mutt-trim.url = "github:Konfekt/mutt-trim";
    mutt-trim.flake = false;

    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";

    powercord.url = "github:LavaDesu/powercord-overlay";
    powercord.inputs.nixpkgs.follows = "nixpkgs";
    powercord.inputs.utils.follows = "flake-utils-plus";

    discord-better-status.url = "github:GriefMoDz/better-status-indicators";
    discord-better-status.flake = false;
    discord-read-all.url = "github:intrnl/powercord-read-all";
    discord-read-all.flake = false;
    discord-theme-slate.url = "github:DiscordStyles/Slate";
    discord-theme-slate.flake = false;
    discord-theme-toggler.url = "github:redstonekasi/theme-toggler";
    discord-theme-toggler.flake = false;
    discord-tweaks.url = "github:NurMarvin/discord-tweaks";
    discord-tweaks.flake = false;
    discord-vc-timer.url = "github:RazerMoon/vcTimer";
    discord-vc-timer.flake = false;

  };
  outputs = { self, ... }@inputs:
    with inputs;
    let
      # Function to create default (common) system config options
      defFlakeSystem = baseCfg:
        nixpkgs.lib.nixosSystem {

          system = "x86_64-linux";
          modules = [

            # Make inputs and overlay accessible as module parameters
            { _module.args.inputs = inputs; }
            { _module.args.self-overlay = self.overlay; }

            ({ ... }: {
              imports = builtins.attrValues self.nixosModules ++ [
                {
                  nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
                  nixpkgs.overlays = [
                    self.overlay
                    nur.overlay
                    neovim-nightly.overlay
                    powercord.overlay
                  ];

                  home-manager.useUserPackages = true;

                  # Extra Certs
                  security.pki.certificateFiles =
                    [ ./certs/ReyuZenfold.crt ./certs/CAcert.crt ];
                }
                baseCfg
                home-manager.nixosModules.home-manager
              ];

              # Let 'nixos-version --json' know the Git revision of this flake.
              system.configurationRevision =
                nixpkgs.lib.mkIf (self ? rev) self.rev;
              nix.registry.nixpkgs.flake = nixpkgs;
              nix.registry.pinpox.flake = self;
            })
          ];
        };

    in {

      overlay = final: prev: (import ./overlays inputs) final prev;

      nixosModules = builtins.listToAttrs (map (x: {
        name = x;
        value = import (./modules + "/${x}");
      }) (builtins.attrNames (builtins.readDir ./modules)));

      nixosConfigurations = builtins.listToAttrs (map (x: {
        name = x;
        value = defFlakeSystem {
          imports = [
            (import (./hosts + "/${x}/configuration.nix") { inherit self; })
          ];
        };
      }) (builtins.attrNames (builtins.readDir ./hosts)));

      homeConfigurations = let
        homeConfig = path:
          home-manager.lib.homeConfigurations {
            # Pass inputs to home-manager modules
            _module.args.flake-inputs = inputs;

            imports = [
              path
              {
                nixpkgs.overlays = [
                  self.overlay
                  nur.overlay
                  neovim-nightly.overlay
                  powercord.overlay
                ];
              }
            ];
          };
      in {
        desktop = homeConfig home-manager/home.nix;
        server = homeConfig home-manager/home-server.nix;
      };
    } //

    # (flake-utils.lib.eachSystem [ "aarch64-linux" "x86_64-linux" ]) (system:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}.extend self.overlay;
      in rec {
        # Custom packages added via the overlay are selectively added here, to
        # allow using them from other flakes that import this one.
        packages = flake-utils.lib.flattenTree { mutt-trim = pkgs.mutt-trim; };

        # Checks to run with `nix flake check -L`, will run in a QEMU VM.
        # Looks for all ./modules/<module name>/test.nix files and adds them to
        # the flake's checks output. The test.nix file is optional and may be
        # added to any module.
        checks = builtins.listToAttrs (map (x: {
          name = x;
          value = (import (./modules + "/${x}/test.nix")) {
            pkgs = nixpkgs;
            inherit system self;
          };
        }) (
          # Filter list of modules, leaving only modules which contain a
          # `test.nix` file
          builtins.filter
          (p: builtins.pathExists (./modules + "/${p}/test.nix"))
          (builtins.attrNames (builtins.readDir ./modules))));
      });
}
