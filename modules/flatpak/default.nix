{ pkgs, ... }:
{
  config = {
    services.flatpak.enable = true;
    xdg.portal.enable = true;
    xdg.portal.extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
