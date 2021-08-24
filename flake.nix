{
  description = "Reyu Zenfold's Nix Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    master.url = "github:nixos/nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager/release-21.05";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      nameValuePair = name: value: { inherit name value; };
      genAttrs = names: f:
        builtins.listToAttrs (map (n: nameValuePair n (f n)) names);

      supportedSystems = [ "x86_64-linux" "x86_64-darwin" ];
      forAllSystems = genAttrs supportedSystems;

      pkgsFor = forAllSystems (system: pkgsFor_ system);
      pkgsFor_ = system:
        (import nixpkgs) {
          inherit system;
          overlays = builtins.attrValues self.overlays;
          config = {
            allowUnfreePredicate = pkg:
              builtins.elem (nixpkgs.lib.getName pkg) [ "discord" ];
          };
        };

      sysConfigRevision = { ... }: {
        # Let 'nixos-version --json' know the Git revision of this flake.
        system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
      };
      # sysOverlays = { ... }: {
      #   nix.nixPath = builtins.attrValues (builtins.mapAttrs
      #     (name: value: name + "=" + (builtins.toString value)) inputs);
      # };
      nixosSystem = nixpkgs.lib.makeOverridable nixpkgs.lib.nixosSystem;
    in {
      overlay = self.overlays.packages;
      overlays = with builtins;
        let
          overlayFiles = listToAttrs (map (name: {
            name = nixpkgs.lib.strings.removeSuffix ".nix" name;
            value = import (./overlays + "/${name}");
          }) (attrNames (readDir ./overlays)));
        in overlayFiles // {
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
            # sysOverlays
            ./hosts/loki/configuration.nix
            ./hosts/loki/hardware-configuration.nix
            ./cachix.nix
            ./modules/common
            ./modules/common/desktop.nix
            ./modules/common/users.nix
            ./modules/sysoverlay.nix
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
                    ./modules/email.nix
                    ./modules/development.nix
                    ./modules/home.nix
                    ./modules/chat.nix
                    ./modules/firefox.nix
                    ./modules/music.nix
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
          inherit (pkgsFor_ "x86_64-linux") pkgs;
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
            inputs.home-manager.nixosModules.home-manager
            ({
              home-manager = {
                useGlobalPkgs = true;
                users.reyu = { pkgs, ... }: {
                  imports = [
                    ./modules/home.nix
                    ./modules/chat.nix
                    ./modules/firefox.nix
                    ./modules/music.nix
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
          inherit (pkgsFor_ "x86_64-linux") pkgs;
        };
        hashicorp = nixosSystem {
          system = "x86_64-linux";
          modules = [ sysConfigRevision ];
          inherit (pkgsFor_ "x86_64-linux") pkgs;
        };
      };
      homeConfigurations = {
        work = inputs.home-manager.lib.homeManagerConfiguration {
          configuration = { pkgs, ... }: {
            imports = [
              ./modules/shell.nix
              ./modules/zsh.nix
              ./modules/nvim.nix
              ./modules/tmux.nix
            ];
            config = {
              programs.home-manager.enable = true;
              home.extraOutputsToInstall = [ "man" ];
              nixpkgs.config = import ./configs/nix/config.nix;
              xdg.configFile."nix/nix.conf".source = ./configs/nix/nix.conf;
            };
          };
          homeDirectory = "/Users/t0m00fc";
          system = "x86_64-darwin";
          username = "t0m00fc";
          inherit (pkgsFor_ "x86_64-darwin") pkgs;
        };
      };

      devShell = forAllSystems (system:
        pkgsFor.${system}.mkShell {
          buildInputs = with pkgsFor.${system};
            [ nixfmt ] ++ (with pkgsFor.${system}.haskellPackages; [
              # For XMonad and related Haskell files
              brittany
              haskell-language-server
              xmonad
              xmonad-contrib
              xmonad-extras
            ]);
        });
    };
}
