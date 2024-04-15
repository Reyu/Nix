{ pkgs, ... }:
{
  programs.swayr = {
    enable = true;
    settings = {
      menu = {
        executable = "${pkgs.wofi}/bin/wofi";
        args = [
          "--show=dmenu"
          "--allow-markup"
          "--allow-images"
          "--insensitive"
          "--cache-file=/dev/null"
          "--parse-search"
          "--prompt={prompt}"
        ];

        format = {
          indent = "    ";
          urgency_start = "<span background=\"darkred\" foreground=\"yellow\">";
          urgency_end = "</span>";
          html_escape = true;
          icon_dirs = [
            "/run/current-system/sw/share/icons/hicolor/scalable/apps"
            "/run/current-system/sw/share/icons/hicolor/48x48/apps"
            "/run/current-system/sw/share/pixmaps"
            "~/.nix-profile/share/icons/hicolor/scalable/apps"
            "~/.nix-profile/share/icons/hicolor/48x48/apps"
            "~/.nix-profile/share/pixmaps"
          ];
        };
        layout = {
          auto_tile = false;
          auto_tile_min_window_width_per_output_width = [
            [
              1024
              500
            ]
            [
              1280
              600
            ]
            [
              1400
              680
            ]
            [
              1440
              700
            ]
            [
              1600
              780
            ]
            [
              1920
              920
            ]
            [
              2560
              1000
            ]
            [
              3440
              1000
            ]
            [
              4096
              1200
            ]
          ];
        };

        focus = {
          lockin_delay = 750;
        };

        misc = {
          auto_nop_delay = 3000;
          seq_inhibit = false;
        };

        swaymsg_commands = {
          include_predefined = true;
          commands = {
            "Workspace to left output" = "move workspace to output left";
            "Workspace to right output" = "move workspace to output right";
          };
        };
      };
    };
    systemd.enable = true;
  };
  programs.wofi = {
    enable = true;
    settings = {
      allow-markup = true;
      allow_images = true;
      cache-file = "/dev/null";
      insensitive = true;
      key_down = "Control_L-n";
      key_up = "Control_L-p";
      location = "center";
      height = 800;
      width = 2000;
    };
    style = builtins.readFile ./wofi.css;
  };
}
