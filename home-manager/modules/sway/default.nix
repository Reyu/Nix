{ config, pkgs, lib, ... }: {
  wayland.windowManager.sway =
    let
      modifier = "Mod4";
      wofi = "${pkgs.wofi}/bin/wofi";
    in
    {
      enable = true;
      config = {
        bars = [ ];
        modifier = modifier;
        terminal = "alacritty";
        startup = [
          { command = "systemctl --user restart waybar.service"; always = true; }
          { command = "firefox"; }
        ];
        keybindings = let cfg = config.wayland.windowManager.sway.config; in {
          "${modifier}+Return" = "exec ${cfg.terminal}";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+d" = "exec ${wofi} --show drun";

          "${modifier}+${cfg.left}" = "focus left";
          "${modifier}+${cfg.down}" = "focus down";
          "${modifier}+${cfg.up}" = "focus up";
          "${modifier}+${cfg.right}" = "focus right";

          "${modifier}+Left" = "focus left";
          "${modifier}+Down" = "focus down";
          "${modifier}+Up" = "focus up";
          "${modifier}+Right" = "focus right";

          "${modifier}+Shift+${cfg.left}" = "move left";
          "${modifier}+Shift+${cfg.down}" = "move down";
          "${modifier}+Shift+${cfg.up}" = "move up";
          "${modifier}+Shift+${cfg.right}" = "move right";

          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Right" = "move right";

          "${modifier}+b" = "splith";
          "${modifier}+v" = "splitv";
          "${modifier}+f" = "fullscreen toggle";
          "${modifier}+a" = "focus parent";

          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";

          "${modifier}+Shift+space" = "floating toggle";
          "${modifier}+space" = "focus mode_toggle";

          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";

          "${modifier}+Shift+1" =
            "move container to workspace number 1";
          "${modifier}+Shift+2" =
            "move container to workspace number 2";
          "${modifier}+Shift+3" =
            "move container to workspace number 3";
          "${modifier}+Shift+4" =
            "move container to workspace number 4";
          "${modifier}+Shift+5" =
            "move container to workspace number 5";
          "${modifier}+Shift+6" =
            "move container to workspace number 6";
          "${modifier}+Shift+7" =
            "move container to workspace number 7";
          "${modifier}+Shift+8" =
            "move container to workspace number 8";
          "${modifier}+Shift+9" =
            "move container to workspace number 9";

          "${modifier}+Shift+minus" = "move scratchpad";
          "${modifier}+minus" = "scratchpad show";

          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+e" =
            "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

          "${modifier}+r" = "mode resize";
        };
      };
      wrapperFeatures = {
        gtk = true;
      };
    };
}
