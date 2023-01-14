{ config, pkgs, lib, ... }: {
  imports = [ ./swayr.nix ];
  home.packages = with pkgs; [
    swayr
  ];
  wayland.windowManager.sway =
    let
      prompt = "${pkgs.fuzzel}/bin/fuzzel";
      curWSName = "$(swaymsg -t get_workspaces | jq -r '.[]|select(.focused == true)|.name')";
      workspaceList = "swaymsg -t get_workspaces | jq -r '.[]|.name'";
    in
    {
      enable = true;
      config = rec {
        bars = [ ];
        modifier = "Mod4";
        terminal = "alacritty";
        focus.followMouse = false;
        focus.newWindow = "urgent";
        gaps = {
         outer = 5;
         inner = 15;
         smartBorders = "on";
        };
        startup = [
          { command = "systemctl --user restart waybar.service"; always = true; }
          { command = "systemctl --user restart swayr.service"; always = true; }
          { command = "systemctl --user start keepassxc.service"; }
          { command = "firefox"; }
          { command = "firefox -P video"; }
          { command = "telegram-desktop"; }
          { command = "discord"; }
        ];
        keybindings = {
          "${modifier}+Return" = "exec alacritty -e tmux new -As ${curWSName}";
          "${modifier}+z" = "exec firefox";
          "${modifier}+Backspace" = "kill";
          "${modifier}+d" = "exec ${prompt}";

          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";

          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";

          "${modifier}+b" = "splith";
          "${modifier}+v" = "splitv";
          "${modifier}+f" = "fullscreen toggle";
          "${modifier}+a" = "exec swayr switch-to-urgent-or-lru-window";

          "${modifier}+s" = "layout stacking";
          "${modifier}+e" = "layout toggle split";

          "${modifier}+Shift+space" = "floating toggle";
          "${modifier}+space" = "focus mode_toggle";

          "${modifier}+w" = "exec swayr switch-workspace-or-window";
          "${modifier}+Shift+w" = "exec swayr move-focused-to";
          "${modifier}+n" = "exec swaymsg workspace $(${prompt} -d -l0 -p 'New Workspace: ')";
          "${modifier}+Shift+r" = "exec swaymsg rename workspace to $(${prompt} -d -l0 -p 'Rename Workspace: ')";

          "${modifier}+Shift+minus" = "move to scratchpad";
          "${modifier}+minus" = "scratchpad show";

          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+e" =
            "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

          "${modifier}+r" = "mode resize";
        };
        floating = {
          criteria = [
            { class = "Pavucontrol"; }
            { app_id = "org.keepassxc.KeePassXC"; }
          ];
        };
      };
    };
}
