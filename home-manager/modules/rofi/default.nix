{ config, pkgs, lib, ... }:
{
  programs.rofi = {
    enable = true;
    theme = ./nord.rasi;
  };
}
