{ lib, ... }: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [
          "sway/mode"
          "sway/workspaces"
          "custom/arrowRight#workspaces"
          "wlr/taskbar"
        ];
        modules-center = [
          "sway/window"
        ];
        modules-right = [
          "custom/arrowLeft#network"
          "network"
          "custom/arrowLeft#memory"
          "memory"
          "custom/arrowLeft#cpu"
          "cpu"
          "custom/arrowLeft#temp"
          "temperature"
          "custom/arrowLeft#lang"
          "sway/language"
          "custom/arrowLeft#tray"
          "tray"
          "custom/arrowLeft#clock"
          "clock"
        ];

        "sway/workspaces" = {
          format = "{icon}";
          format-icons = {
            "urgent" = "";
            "active" = "";
          };
        };
        network = {
          format = "{bandwidthUpBits} | {bandwidthDownBits}";
          tooltip-format = "{ifname} via {gwaddr} ";
          tooltip-format-wifi = "{essid} ({signalStrength}%) ";
          tooltip-format-ethernet = "{ipaddr} ";
          tooltip-format-disconnected = "Disconnected";
        };
        "custom/arrowRight#workspaces" = {
          format = "";
        };
        "custom/arrowLeft#network" = {
          format = "";
          tooltip = false;
        };
        "custom/arrowLeft#memory" = {
          format = "";
          tooltip = false;
        };
        "custom/arrowLeft#cpu" = {
          format = "";
          tooltip = false;
        };
        "custom/arrowLeft#temp" = {
          format = "";
          tooltip = false;
        };
        "custom/arrowLeft#lang" = {
          format = "";
          tooltip = false;
        };
        "custom/arrowLeft#tray" = {
          format = "";
          tooltip = false;
        };
        "custom/arrowLeft#clock" = {
          format = "";
          tooltip = false;
        };

      };
    };
    style = lib.fileContents ./style.css;
    systemd.enable = true;
  };
}
