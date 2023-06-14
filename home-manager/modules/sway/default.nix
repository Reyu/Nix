{ config, pkgs, lib, ... }: {
  imports = [ ./swayr.nix ];
  home.packages = with pkgs; [
    grim
    slurp
    swayidle
    swayr
    wl-clipboard
    wlr-randr
    xdg-utils
  ];
  programs = {
    swaylock.enable = true;
    zathura.enable = true;
  };
  services = {
    swayidle.enable = true;
  };
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
          inner = 10;
          smartBorders = "on";
        };
        startup = [
          { command = "systemctl --user restart waybar.service"; always = true; }
          { command = "systemctl --user restart swayr.service"; always = true; }
          { command = "systemctl --user start keepassxc.service"; }
          { command = "element"; }
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
          "${modifier}+Shift+r" = "exec swaymsg rename workspace to $(${prompt} -d -l0 -p 'Rename Workspace: ')";

          "${modifier}+Shift+minus" = "move to scratchpad";
          "${modifier}+minus" = "scratchpad show";
          "${modifier}+c" = "[class=\"Element\"] scratchpad show";
          "${modifier}+n" = "exec alacritty --class journal -T Journal -e nvim -c 'Neorg journal today'";

          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+q" =
            "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

          "${modifier}+r" = "mode resize";
        };
        assigns = {
          "Web" = [];
          "Refrence" = [];
          "Video" = [];
          "Work" = [{class="Slack";}];
          "Games" = [{class="Steam";}];
        };
        floating = {
          criteria = [
            { class = "journal"; }
            { title = "Journal"; }
            { class = "Pavucontrol"; }
            { app_id = "org.keepassxc.KeePassXC"; }
            { title = "Steam - Update News"; }
          ];
        };
        window = {
          commands = [
            {
              command = "move to scratchpad";
              criteria = {
                class = "Element";
              };
            }
            {
              command = "resize set 75 ppt 75 ppt";
              criteria = {
                title = "Journal";
              };
            }
          ];
        };
        workspaceOutputAssign = [
          {
            workspace = "Web";
            output = "DP-1";
          }
          {
            workspace = "Code";
            output = "DP-1";
          }
          {
            workspace = "Refrence";
            output = "DP-2";
          }
          {
            workspace = "Work";
            output = "DP-2";
          }
          {
            workspace = "Video";
            output = "DP-3";
          }
        ];
      };
      wrapperFeatures.gtk = true;
    };
}
