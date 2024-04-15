{ pkgs, ... }:
{
  imports = [ ./swayr.nix ];
  home.packages = with pkgs; [
    grim
    slurp
    sway-contrib.grimshot
    swayr
    wl-clipboard
    wlr-randr
    xdg-utils
  ];
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
  };
  programs = {
    swaylock.enable = true;
    zathura.enable = true;
  };
  services = {
    swayosd = {
      display = "DP-1";
      enable = true;
    };
    swayidle.enable = true;
    udiskie.tray = "always";
  };
  wayland.windowManager.sway =
    let
      prompt = "${pkgs.fuzzel}/bin/fuzzel";
      curWSName = "$(swaymsg -t get_workspaces | jq -r '.[]|select(.focused == true)|.name')";
    in
    {
      enable = true;
      config = rec {
        bars = [ ];
        modifier = "Mod4";
        terminal = "kitty";
        focus.followMouse = false;
        focus.newWindow = "urgent";
        gaps = {
          outer = 5;
          inner = 10;
          smartBorders = "on";
        };
        startup = [
          {
            command = "sleep 3s; systemctl --user reload-or-restart waybar.service";
            always = true;
          }
          {
            command = "sleep 3s; systemctl --user reload-or-restart swayr.service";
            always = true;
          }
          { command = "sleep 3s; systemctl --user start keepassxc.service"; }
        ];
        keybindings = {
          "${modifier}+Return" = "exec ${terminal} -e tmux new -As ${curWSName}";
          "${modifier}+z" = "exec xdg-open http:"; # Open default browser
          "${modifier}+Backspace" = "kill";
          "${modifier}+d" = "exec ${pkgs.wofi}/bin/wofi --show=drun";
          "${modifier}+Shift+v" = "exec pavucontrol";

          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";

          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";

          "${modifier}+grave" = "focus parent";
          "${modifier}+shift+grave" = "focus child";

          "${modifier}+b" = "splith";
          "${modifier}+v" = "splitv";
          "${modifier}+f" = "fullscreen toggle";

          "${modifier}+g" = "exec swayr switch-window";
          "${modifier}+Delete" = "exec swayr quit-window";
          "${modifier}+Tab" = "exec swayr switch-to-urgent-or-lru-window";
          "${modifier}+Next" = "exec swayr next-window all-workspaces";
          "${modifier}+Prior" = "exec swayr prev-window all-workspaces";
          "${modifier}+Shift+g" = "exec swayr switch-workspace-or-window";
          "${modifier}+Mod1+c" = "exec swayr execute-swaymsg-command";
          "${modifier}+Mod1+Shift+c" = "exec swayr execute-swayr-command";

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
          "${modifier}+Shift+c" = "exec element";
          "${modifier}+n" = "exec ${terminal} --class journal -T Journal -e nvim -c 'Neorg journal today'";

          "${modifier}+Shift+q" = "exec swaynag -t warning -m 'Do you really want to exit sway?' -b 'Yes, exit sway' 'swaymsg exit'";

          "${modifier}+r" = "mode resize";

          "${modifier}+Shift+s" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot --notify --cursor copy area";
        };
        assigns = {
          "Web" = [ ];
          "Chat" = [ ];
          "Video" = [ ];
          "Games" = [ { class = "steam"; } ];
        };
        floating = {
          criteria = [
            { app_id = "pavucontrol"; }
            { app_id = "org.keepassxc.KeePassXC"; }
            { app_id = "journal"; }
            { class = "Element"; }
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
            workspace = "Work";
            output = "DP-1";
          }
          {
            workspace = "Chat";
            output = "DP-2";
          }
          {
            workspace = "Macbook";
            output = "DP-2";
          }
          {
            workspace = "Video";
            output = "DP-3";
          }
        ];
      };
      extraConfig = ''
        seat seat0 hide_cursor 3000
      '';
      wrapperFeatures.gtk = true;
    };
}
