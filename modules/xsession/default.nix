{ config, pkgs, libs, ... }:

{
  home.packages = with pkgs; [
    cpu-x
    keepassxc
    pavucontrol
    radeon-profile
    radeontop
    syncthing-tray
    xmonad-log
  ];

  programs = {
    alacritty = {
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
    rofi = {
      enable = true;
      theme = ./rofi/nord.rasi;
    };
  };

  services = {
    dunst = {
      enable = true;
      settings = {
        global = {
          monitor = 0;
          geometry = "600x50-50+65";
          shrink = "yes";
          transparency = 10;
          padding = 16;
          horizontal_padding = 16;
          font = "SauceCodePro Nerd Font 10";
          line_height = 4;
          format = "<b>%s</b>\\n%b";
        };
      };
    };
    picom = {
      enable = true;
      activeOpacity = "1.0";
      inactiveOpacity = "0.8";
      blur = true;
      backend = "glx";
      opacityRule = [ "100:name *= 'i3lock'" "100:name *= 'Firefox'" ];
      shadow = true;
      shadowOpacity = "0.75";
    };
    polybar = {
      enable = true;
      package = pkgs.polybar.override {
        mpdSupport = true;
        githubSupport = true;
      };
      config = ./polybar/linux-desktop;
      extraConfig = ''
        [module/xmonad]
        type = custom/script
        exec = ${pkgs.xmonad-log}/bin/xmonad-log
        tail = true
      '';
      script = "polybar -r primary &";
    };
    redshift = {
      enable = true;
      tray = true;
      latitude = "38.893956";
      longitude = "-77.036539";
    };
    udiskie = {
      enable = true;
      tray = "always";
    };
    screen-locker = {
      enable = true;
      inactiveInterval = 30;
      lockCmd = "${pkgs.i3lock-fancy-rapid} 8 2";
      xautolockExtraOptions = [ "Xautolock.killer: systemctl suspend" ];
    };
    xcape = {
      enable = true;
      mapExpression = { Super_R = "Escape"; };
    };
  };

  xresources.extraConfig = builtins.readFile (pkgs.fetchFromGitHub {
    owner = "solarized";
    repo = "xresources";
    rev = "025ceddbddf55f2eb4ab40b05889148aab9699fc";
    sha256 = "0lxv37gmh38y9d3l8nbnsm1mskcv10g3i83j0kac0a2qmypv1k9f";
  } + "/Xresources.dark");

  xsession = {
    enable = true;
    initExtra = ''
      "autorandr -l home"
    '';
    numlock.enable = true;
    profileExtra = "xrandr --output DisplayPort-1 --primary";

    windowManager.xmonad = {
      enable = true;
      extraPackages = haskellPackages:
        with haskellPackages; [
          containers
          dbus
          directory
          unix
          utf8-string
          xmonad-contrib
        ];
      config = ./xmonad/xmonad.hs;
    };
  };
}
