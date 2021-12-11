{ config, pkgs, lib, ... }:
{

  xsession.enable = true;
  xsession.scriptPath = ".hm-xsession";
  xsession.numlock.enable = true;
  xsession.initExtra = ''
    ${pkgs.autorandr} -c
  '';

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
