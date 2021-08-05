{ config, pkgs, lib, ... }:

{
  services = {
    dbus = {
      enable = true;
      packages = [ pkgs.gnome3.dconf ];
    };
    unclutter = {
      enable = true;
      timeout = 3;
    };
    xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "dvorak";
      libinput.enable = true;
      windowManager.xmonad.enable = true;
    };
  };
}
