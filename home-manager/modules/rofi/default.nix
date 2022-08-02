{ config, pkgs, lib, ... }:
{
  programs.rofi = {
    enable = true;
    theme = "solarized_alternate";
  };
}
