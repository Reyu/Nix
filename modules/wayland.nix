{ config, pkgs, libs, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      assigns = {
        "1: web" = [ { class = "^Firefox$"; } ];
      };

    };
  };

  services.redshift = {
    enable = false;
    package = pkgs.redshift-wlr;
  };

  programs.waybar.enable = true;
}
