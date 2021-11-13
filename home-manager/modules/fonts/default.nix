{ config, pkgs, lib, ... }: {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerdfonts powerline-fonts terminus-nerdfont
  ];
}
