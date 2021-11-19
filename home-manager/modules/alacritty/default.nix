{ config, pkgs, lib, ... }:
let vars = import ./vars.nix;
in {
  # Alacritty
    programs.alacritty = {
      enable = true;
      settings = {
        window.decorations = "none";
        scrolling.history = 0;
        font.normal.family = "SauceCodePro Nerd Font";
        colors = {
          primary = {
            background = "#002b36";
            foreground = "#839496";
          };
          cursor = {
            text = "#002b36";
            cursor = "#839496";
          };
          normal = {
            black = "#073642";
            red = "#dc322f";
            green = "#859900";
            yellow = "#b58900";
            blue = "#268bd2";
            magenta = "#d33682";
            cyan = "#2aa198";
            white = "#eee8d5";
          };
          bright = {
            black = "#002b36";
            red = "#cb4b16";
            green = "#586e75";
            yellow = "#657b83";
            blue = "#839496";
            magenta = "#6c71c4";
            cyan = "#93a1a1";
            white = "#fdf6e3";
          };
        };
      };
    };
}