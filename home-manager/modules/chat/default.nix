{ config, pkgs, libs, ... }:
{
  home.packages = with pkgs; [ element-desktop tdesktop ];
}
