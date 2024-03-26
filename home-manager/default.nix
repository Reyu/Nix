{ self, inputs, lib, ... }:
let hmConfig = inputs.home-manager.lib.homeManagerConfiguration;
in {

  desktop = hmConfig {
    extraSpecialArgs = { inherit inputs self; };
    pkgs = self.pkgs.x86_64-linux.nixpkgs;
    modules = [
      {
        home = {
          username = lib.mkDefault "reyu";
          homeDirectory = lib.mkDefault "/home/reyu";
        };
      }
      ./profiles/desktop.nix
    ];
  };

  server = hmConfig {
    extraSpecialArgs = { inherit inputs self; };
    pkgs = self.pkgs.x86_64-linux.nixpkgs;
    modules = [
      {
        home = {
          username = lib.mkDefault "reyu";
          homeDirectory = lib.mkDefault "/home/reyu";
        };
      }
      ./profiles/server.nix
    ];
  };

  minimalRoot = hmConfig {
    extraSpecialArgs = { inherit inputs self; };
    pkgs = self.pkgs.x86_64-linux.nixpkgs;
    modules = [
      ./profiles/common.nix
      {
        manual.manpages.enable = true;
        home = {
          username = lib.mkDefault "root";
          homeDirectory = lib.mkDefault "/root";
        };
      }
    ];
  };
}
