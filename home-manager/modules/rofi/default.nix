{ config, pkgs, lib, ... }:
{
  programs.rofi = {
    enable = true;
    # TODO Fix Me
    # Theme broken
    # theme = ./nord.rasi;
  };
}
