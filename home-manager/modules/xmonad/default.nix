{ config, pkgs, lib, ... }:
{

  xsession.scriptPath = ".hm-xsession";
  xsession.enable = true;

  xsession.windowManager.xmonad = {
    enable = true;
    extraPackages = haskellPackages:
      with haskellPackages; [
        containers
        dbus
        directory
        unix
        utf8-string
        xmonad-contrib
      ];
    config = ./xmonad.hs;
  };
}
