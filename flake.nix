{
  description = "Reyu Zenfold's Nix Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
    home-manager.url = "github:nix-community/home-manager/release-21.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    neovim-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      inherit (builtins) attrValues listToAttrs removeSuffix attrNames readDir;
      inherit (nixpkgs) lib;
      pkgs = { system ? "x86_64-linux" }:
        (import nixpkgs) {
          system = "${system}";
          overlays = attrValues self.overlays;
          config.allowUnfreePredicate = pkg:
            builtins.elem (lib.getName pkg) [
              "steam"
              "steam-original"
              "steam-runtime"
            ];
        };
      sysConfigRevision = { ... }: {
        # Let 'nixos-version --json' know the Git revision of this flake.
        system.configurationRevision = lib.mkIf (self ? rev) self.rev;
      };
      nixosSystem = lib.makeOverridable lib.nixosSystem;
    in {
      # overlays = let
      #   overlayFiles = listToAttrs (map (name: {
      #     name = removeSuffix ".nix" name;
      #     value = import (./overlays + "/${name}");
      #   }) (attrNames (readDir ./overlays)));
      # in overlayFiles // {
      overlays = {
        nur = final: prev: {
          nur = import inputs.nur {
            nurpkgs = final.unstable;
            pkgs = final.unstable;
          };
        };
        unstable = final: prev: {
          unstable = import inputs.unstable { system = final.system; };
        };
        master = final: prev: {
          master = import inputs.master { system = final.system; };
        };
      };
      nixosConfigurations = {
        loki = nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/loki/configuration.nix
            ./hosts/loki/hardware-configuration.nix
            ./cachix.nix
            ./common
            ./common/desktop.nix
            ./common/users.nix
            ./modules/docker.nix
            ./modules/hydra.nix
            ./modules/kerberos.nix
            ./modules/steam.nix
            ./modules/zfs.nix
            sysConfigRevision
            inputs.home-manager.nixosModules.home-manager
            {
              foxnet = {
                zfs.common = true;
              };
            }
          ];
          inherit (pkgs { system = "x86_64-linux"; })
          ;
        };
        burrow = nixosSystem {
          system = "x86_64-linux";
          modules = [ sysConfigRevision (./hosts/burrow/configuration.nix) ];
          inherit pkgs;
        };
      };
    } // inputs.flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
    (system:
      let pkgs = import nixpkgs { inherit system pkgs; };
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            nixfmt
            # For XMonad and related Haskell files
            haskellPackages.brittany
            haskellPackages.haskell-language-server
          ];
        };
      });
}
