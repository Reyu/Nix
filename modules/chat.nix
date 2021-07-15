{ config, pkgs, libs, ... }: {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [ "discord" ];
  home.packages = with pkgs; [ discord element-desktop tdesktop ];
}
