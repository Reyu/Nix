{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, home-manager, ... }:
    let
      nixosSystem = nixpkgs.lib.makeOverridable nixpkgs.lib.nixosSystem;
      defFlakeSystem = baseCfg:
        nixosSystem {
          system = "x86_64-linux";
          modules = [
            ({ ... }: {
              imports = [
                { nix.nixPath = [ "nixpkgs=${nixpkgs}" ]; }
                home-manager.nixosModules.home-manager
                {
                  home-manager.useUserPackages = true;
                }
                baseCfg
              ];
              # Let 'nixos-version --json' know the Git revision of this flake.
              system.configurationRevision =
                nixpkgs.lib.mkIf (self ? rev) self.rev;
            })
          ];
        };
    in {
      nixosConfigurations = {
        inherit nixpkgs;
        loki = defFlakeSystem { imports = [ ./hosts/loki/configuration.nix ]; };
        traveler =
          defFlakeSystem { imports = [ ./hosts/traveler/configuration.nix ]; };
        ismene = nixosSystem {
          system = "aarch64-linux";
          modules = [
            ({ ... }: {
              imports = [
                { nix.nixPath = [ "nixpkgs=${nixpkgs}" ]; }
                ./hosts/ismene/configuration.nix
              ];
            })
          ];
        };
      };
    };
}
