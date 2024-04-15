{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  gtk.font = {
    name = "hasklig";
  };
  home.packages = with pkgs; [
    hasklig
    nerdfonts
    powerline-fonts
    terminus-nerdfont
  ];
}
