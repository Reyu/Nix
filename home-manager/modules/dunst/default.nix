{ config, pkgs, lib, ... }:
{
  services.dunst = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
      size = "22x22";
    };
    settings = {
      global = {
        alignment = "left";
        always_run_script = "true";
        browser = config.programs.firefox.package.outPath + "/bin/firefox";
        class = "Dunst";
        dmenu = config.programs.rofi.finalPackage.outPath + "/bin/rofi -dmenu -p Actions";
        ellipsize = "middle";
        follow = "none";
        frame_width = 2;
        geometry = "300x5-50+50";
        hide_duplicate_count = "false";
        history_length = 20;
        horizontal_padding = 8;
        icon_position = "right";
        ignore_newline = "no";
        indicate_hidden = "yes";
        line_height = 0;
        markup = "full";
        max_icon_size = 32;
        monitor = 0;
        notification_height = 0;
        padding = 8;
        separator_color = "frame";
        separator_height = 2;
        show_age_threshold = 60;
        show_indicators = "yes";
        shrink = "no";
        sort = "yes";
        stack_duplicates = "yes";
        startup_notification = "true";
        sticky_history = "yes";
        title = "Dunst";
        transparency = 0;
        word_wrap = "yes";
      };
    };
  };
}
