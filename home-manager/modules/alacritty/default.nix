{
  # Alacritty
  programs.alacritty = {
    enable = true;
    settings = {
      bell.duration = 125;
      bell.animation = "EaseOutExpo";
      window.decorations = "none";
      window.opacity = 0.9;
      scrolling.history = 0;
      font.normal.family = "Hasklig";
      font.size = 12;
      colors = {
        primary = {
          background = "0x001217";
          foreground = "0x708183";
        };
        cursor = {
          text = "#002b36";
          cursor = "#839496";
        };
        normal = {
          black = "0x002b36";
          red = "0xdc322f";
          green = "0x859900";
          yellow = "0xb58900";
          blue = "0x268bd2";
          magenta = "0xd33682";
          cyan = "0x2aa198";
          white = "0xeee8d5";
        };
        bright = {
          black = "0x002b36";
          red = "0xcb4b16";
          green = "0x586e75";
          yellow = "0x657b83";
          blue = "0x839496";
          magenta = "0x6c71c4";
          cyan = "0x93a1a1";
          white = "0xfdf6e3";
        };
      };
    };
  };
}
