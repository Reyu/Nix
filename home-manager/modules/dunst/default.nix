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
        monitor = 0;
        follow = "mouse";
        geometry = "300x5-50+50";
        indicate_hidden = "yes";
        shrink = "no";
        transparency = 0;
        notification_height = 0;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        frame_width = 0;
        separator_color = "frame";
        sort = "yes";
        line_height = 0;
        markup = "full";
        alignment = "left";
        show_age_threshold = 60;
        word_wrap = "yes";
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = "yes";
        hide_duplicate_count = "false";
        show_indicators = "no";
        icon_position = "left";
        max_icon_size = 32;
        sticky_history = "yes";
        history_length = 20;
        browser = "${pkgs.chromium}/bin/chromium";
        always_run_script = "true";
        title = "Dunst";
        class = "Dunst";
        startup_notification = "false";
      };

      shortcuts = {
        close = "ctrl+space";
        close_all = "ctrl+shift+space";
        history = "ctrl+grave";
        context = "ctrl+shift+period";
      };
    };
  };
}
