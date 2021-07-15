{ config, pkgs, libs, ... }:
{
  home.stateVersion = "20.09";

  programs.home-manager.enable = true;
  home.extraOutputsToInstall = [ "man" ];
}
