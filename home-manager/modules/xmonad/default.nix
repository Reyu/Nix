{ config, pkgs, ... }:
{

  xsession.enable = true;
  xsession.scriptPath = ".hm-xsession";
  xsession.numlock.enable = true;
  xsession.initExtra = ''
    xsetroot -cursor_name left_ptr
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
