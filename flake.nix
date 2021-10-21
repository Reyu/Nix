{
  description = "Reyu Zenfold's Nix Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-21.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    home-manager = {
      url = "github:nix-community/home-manager/release-21.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NOTE / TODO
    # neovim = {
    #   url = "github:neovim/neovim?dir=contrib";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # TODO
    # powercord = {
    #   url = "github:LavaDesu/powercord-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.utils.follows = "utils";
    # };
    # discord-tweaks = {
    #   url = "github:NurMarvin/discord-tweaks";
    #   flake = false;
    # };

    # NOTE Could be useful later (for raspberryPi)
    # nixos-hardware.url = "github:nixos/nixos-hardware";

  };

  outputs = inputs@{ self, nixpkgs, unstable, nur, utils, home-manager, ... }:
    utils.lib.systemFlake {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" ];

      hostDefaults = {
        system = "x86_64-linux";
        extraArgs = { inherit utils inputs; };
        modules = [
          utils.nixosModules.saneFlakeDefaults
          home-manager.nixosModule
          {
            # Let 'nixos-version --json' know the Git revision of this flake.
            system.configurationRevision =
              nixpkgs.lib.mkIf (self ? rev) self.rev;
            system.autoUpgrade.flags = [
              "--option"
              "extra-binary-caches"
              "https://reyu.cachix.org"
              "https://reyu-system.cachix.org"
            ];
          }
          ./cachix.nix
          ./modules/users
          ./modules/common
          ./modules/crypto
          ./modules/security
        ];

      };

      sharedOverlays = [ self.overlay nur.overlay ];

      # Channel defaults
      channelsConfig.allowUnfree = true;

      # Channel definitions. `channels.<name>.{input,overlaysBuilder,config,patches}`
      channels.nixpkgs.input = nixpkgs;
      channels.nixpkgs.overlaysBuilder = channels:
        [
          (final: prev: {
            unstable = import inputs.unstable { system = prev.system; };
          })
        ];
      channels.unstable.input = unstable;
      # channels.unstable.overlaysBuilder = channels:
      #   [
      #     (final: prev: {
      #       neovim-nightly = inputs.neovim.defaultPackage.${prev.system};
      #     })
      #   ];

      # Host Configurations
      hosts.loki.modules = [
          ./hosts/loki
          ./modules/docker
          ./modules/kerberos
          ./modules/keybase
          ./modules/ldap
          ./modules/zfs
          ./profiles/desktop.nix
        ];

        hosts.burrow.modules = [
          ./hosts/burrow
          ./modules/kerberos
          ./modules/zfs
        ];

      overlay = import ./overlays;

      # For non-NixOS Systems
      homeConfigurations = {
        work = home-manager.lib.homeManagerConfiguration {
          configuration = { pkgs, ... }: {
            imports =
              [ ./modules/neovim ./modules/shell ./modules/zsh ./modules/tmux ];
            config = {
              programs.home-manager.enable = true;
              home.extraOutputsToInstall = [ "man" ];
              nixpkgs.config = import ./moduls/nix/config.nix;
              xdg.configFile."nix/nix.conf".source = ./modules/nix/nix.conf;
            };
          };
          homeDirectory = "/Users/t0m00fc";
          system = "x86_64-darwin";
          username = "t0m00fc";
        };
      };

      devShellBuilder = channels:
        channels.nixpkgs.mkShell {
          buildInputs = with channels.nixpkgs; [ rage nixfmt ];
        };
    };
}
