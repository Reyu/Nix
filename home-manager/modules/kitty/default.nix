{
  programs.kitty = {
    enable = true;
    font = {
      name = "Hasklug Nerd Font Mono";
      size = 12;
    };
    settings = {
      scrollback_lines = 0;
      strip_trailing_spaces = "smart";
      allow_remote_control = "socket-only";
      listen_on = "unix:/tmp/kitty";

      background_opacity = "0.9";
      background_tint = "0.5";
      dynamic_background_opacity = "yes";
      confirm_os_window_close = 0;

      background = "#001e26";
      foreground = "#708183";
      cursor = "#708183";
      selection_background = "#002731";
      color0 = "#002731";
      color8 = "#465a61";
      color1 = "#d01b24";
      color9 = "#bd3612";
      color2 = "#728905";
      color10 = "#465a61";
      color3 = "#a57705";
      color11 = "#52676f";
      color4 = "#2075c7";
      color12 = "#708183";
      color5 = "#c61b6e";
      color13 = "#5856b9";
      color6 = "#259185";
      color14 = "#81908f";
      color7 = "#e9e2cb";
      color15 = "#fcf4dc";
      selection_foreground = "#001e26";
    };
    extraConfig = ''
      # - Use additional nerd symbols
      # See https://github.com/be5invis/Iosevka/issues/248
      # See https://github.com/ryanoasis/nerd-fonts/wiki/Glyph-Sets-and-Code-Points

      # Seti-UI + Custom
      symbol_map U+E5FA-U+E6AC Symbols Nerd Font

      # Devicons
      symbol_map U+E700-U+E7C5 Symbols Nerd Font

      # Font Awesome
      symbol_map U+F000-U+F2E0 Symbols Nerd Font

      # Font Awesome Extension
      symbol_map U+E200-U+E2A9 Symbols Nerd Font

      # Material Design Icons
      symbol_map U+F0001-U+F1AF0 Symbols Nerd Font

      # Weather
      symbol_map U+E300-U+E3E3 Symbols Nerd Font

      # Octicons
      symbol_map U+F400-U+F532,U+2665,U+26A1 Symbols Nerd Font

      # Powerline Symbols
      symbol_map U+E0A0-U+E0A2,U+E0B0-U+E0B3 Symbols Nerd Font

      # Powerline Extra Symbols
      symbol_map U+E0A3,U+E0B4-U+E0C8,U+E0CA,U+E0CC-U+E0D4 Symbols Nerd Font

      # IEC Power Symbols
      symbol_map U+23FB-U+23FE,U+2B58 Symbols Nerd Font

      # Font Logos
      symbol_map U+F300-U+F32F Symbols Nerd Font

      # Pomicons
      symbol_map U+E000-U+E00A Symbols Nerd Font

      # Codicons
      symbol_map U+EA60-U+EBEB Symbols Nerd Font

      # Additional sets
      symbol_map U+E276C-U+E2771 Symbols Nerd Font # Heavy Angle Brackets
      symbol_map U+2500-U+259F Symbols Nerd Font # Box Drawing

      # Some symbols not covered by Symbols Nerd Font
      # nonicons contains icons in the range: U+F101-U+F27D
      # U+F167 is HTML logo, but YouTube logo in Symbols Nerd Font
      symbol_map U+F102,U+F116-U+F118,U+F12F,U+F13E,U+F1AF,U+F1BF,U+F1CF,U+F1FF,U+F20F,U+F21F-U+F220,U+F22E-U+F22F,U+F23F,U+F24F,U+F25F nonicons
    '';
  };
}
