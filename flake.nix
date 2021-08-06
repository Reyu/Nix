{
  description = "Reyu Zenfold's Nix Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    master.url = "github:nixos/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager/release-21.05";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      inherit (builtins) attrNames attrValues listToAttrs readDir removeSuffix;
      inherit (nixpkgs) lib;

      pkgs = (import nixpkgs) {
        system = "x86_64-linux";
        overlays = attrValues self.overlays;
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
        nur = inputs.nur.overlay;
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
            sysConfigRevision
            ./hosts/loki/configuration.nix
            ./hosts/loki/hardware-configuration.nix
            ./cachix.nix
            ./modules/common
            ./modules/common/desktop.nix
            ./modules/common/users.nix
            ./modules/docker.nix
            ./modules/hydra.nix
            ./modules/kerberos.nix
            # ./modules/steam.nix
            ({ pkgs, config, ... }: {
              imports = [ ./modules/zfs.nix ];
              config.foxnet.zfs.common = true;
            })
            ({ pkgs, ... }: {
              config.environment.systemPackages = [ pkgs.neovim pkgs.firefox ];
            })
            inputs.home-manager.nixosModules.home-manager
            ({
              home-manager = {
                useGlobalPkgs = true;
                users.reyu = { pkgs, ... }: {
                  imports = [
                    ./modules/chat.nix
                    ./modules/firefox.nix
                    ./modules/nvim.nix
                    ./modules/shell.nix
                    ./modules/tmux.nix
                    ./modules/xsession.nix
                    ./modules/zsh.nix
                  ];
                };
              };
            })
          ];
          inherit pkgs;
        };
        burrow = nixosSystem {
          system = "x86_64-linux";
          modules = [
            sysConfigRevision
            ./hosts/burrow/configuration.nix
            ./hosts/burrow/hardware-configuration.nix
            ./hosts/burrow/containers.nix
            ./modules/common
            ./modules/common/users.nix
            ./modules/docker.nix
            ./modules/hydra.nix
            ./modules/kerberos.nix
          ];
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
