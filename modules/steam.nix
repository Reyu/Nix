{ config, pkgs, ... }:

{
  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
             "steam"
             "steam-original"
           ];
    allowBroken = true;
    packageOverrides = pkgs: {
      steam = pkgs.steam.override {
        nativeOnly = true;
      };
    };
  };
  programs.steam.enable = true;
  hardware.steam-hardware.enable = true;
}
