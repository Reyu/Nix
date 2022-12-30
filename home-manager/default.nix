{ self, inputs, ... }:
let hmConfig = inputs.home-manager.lib.homeManagerConfiguration;
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
      ./profiles/desktop.nix
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
          username = "root";
          homeDirectory = "/root";
        };
      }
    ];
  };
}
