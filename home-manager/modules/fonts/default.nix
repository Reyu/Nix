{ pkgs, ... }: {
  fonts.fontconfig.enable = true;
  gtk.font = {
    name = "Source Code Pro Powerline";
  };
  home.packages = with pkgs; [
    nerdfonts
    powerline-fonts
    terminus-nerdfont
  ];
}
