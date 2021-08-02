{ config, pkgs, libs, ... }:
{
  imports = [
    ./modules/firefox.nix
  ];
  config = {
    home.stateVersion = "20.09";

    programs.home-manager.enable = true;
    home.extraOutputsToInstall = [ "man" ];
  };
}
