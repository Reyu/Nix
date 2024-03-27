{ lib, pkgs, ... }:
with lib;
{
  config = {
    home.packages = with pkgs; [
      tmux-xpanes
    ];
    programs.tmux = {
      enable = true;
      prefix = "M-b";
      aggressiveResize = true;
      clock24 = true;
      escapeTime = 10;
      keyMode = "vi";
      terminal = "screen-256color";
      historyLimit = 20000;
      sensibleOnTop = false;
      secureSocket = true;
      extraConfig = ''
        # ==========================
        # ===  General settings  ===
        # ==========================
        set -g buffer-limit 20
        set -g display-time 1500
        set -g remain-on-exit off
        set -g repeat-time 300
        set -g focus-events on
        setw -g allow-rename off
        setw -g automatic-rename off

        set -g set-titles on
        set -g set-titles-string "#I:#W"

        set -as terminal-features ',*-256color:RGB'
        set -as terminal-features ',*-kitty:RGB:usstyle'

        # ==========================
        # ===   Key bindings     ===
        # ==========================

        # Rename session and window
        bind r command-prompt -I "#{window_name}" "rename-window '%%'"
        bind R command-prompt -I "#{session_name}" "rename-session '%%'"

        # Link window
        bind L command-prompt -p "Link window from (session:window): " "link-window -s %% -a"

        # Merge session with another one (e.g. move all windows)
        # If you use adhoc 1-window sessions, and you want to preserve session upon exit
        # but don't want to create a lot of small unnamed 1-window sessions around
        # move all windows from current session to main named one (dev, work, etc)
        bind M-u command-prompt -p "Session to merge with: " \
           "run-shell 'yes | head -n #{session_windows} | xargs -I {} -n 1 tmux movew -t %%'"

        bind D if -F '#{session_many_attached}' \
            'confirm-before -p "Detach other clients? (y/n)" "detach -a"' \
            'display "Session has only 1 client attached"'

        # Hide status bar on demand
        bind M-s if -F '#{s/off//:status}' 'set status off' 'set status on'

        # Send KILL signal to process in current pane
        bind-key '*' run-shell "~/.config/tmux/kill.sh KILL"

        # Vim Tmux Navigator
        # Smart pane switching with awareness of Vim splits.
        # See: https://github.com/christoomey/vim-tmux-navigator
        is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
            | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

        bind-key -n 'M-h' if-shell "$is_vim" 'send-keys M-h'  'select-pane -L'
        bind-key -n 'M-j' if-shell "$is_vim" 'send-keys M-j'  'select-pane -D'
        bind-key -n 'M-k' if-shell "$is_vim" 'send-keys M-k'  'select-pane -U'
        bind-key -n 'M-l' if-shell "$is_vim" 'send-keys M-l'  'select-pane -R'
        bind-key -n 'M-\' if-shell "$is_vim" 'send-keys M-\'  'select-pane -l'

        bind-key -n 'M-H' if-shell "$is_vim" 'send-keys M-H' 'resize-pane -L 3'
        bind-key -n 'M-J' if-shell "$is_vim" 'send-keys M-J' 'resize-pane -D 3'
        bind-key -n 'M-K' if-shell "$is_vim" 'send-keys M-K' 'resize-pane -U 3'
        bind-key -n 'M-L' if-shell "$is_vim" 'send-keys M-L' 'resize-pane -R 3'

        bind-key -T copy-mode-vi 'M-h' select-pane -L
        bind-key -T copy-mode-vi 'M-j' select-pane -D
        bind-key -T copy-mode-vi 'M-k' select-pane -U
        bind-key -T copy-mode-vi 'M-l' select-pane -R
        bind-key -T copy-mode-vi 'M-\' select-pane -l

        # ==================================================
        # === Window monitoring for activity and silence ===
        # ==================================================
        bind 'M-m' setw monitor-activity \; display-message 'Monitor window activity [#{?monitor-activity,ON,OFF}]'
        bind 'M-M' if -F '#{monitor-silence}' \
            'setw monitor-silence 0 ; display-message "Monitor window silence [OFF]"' \
            'command-prompt -p "Monitor silence: interval (s)" "setw monitor-silence %%"'

        # Activity bell and whistles
        set -g visual-activity on

        # =====================================
        # ===           Theme               ===
        # =====================================
        # color_dark="black"
        # color_light="white"
        # color_session_text="colour39"
        # color_status_text="colour245"
        # color_main="green"
        # color_secondary="colour134"
        # color_level_ok="green"
        # color_level_warn="yellow"
        # color_level_stress="red"
        # color_window_off_indicator="colour088"
        # color_window_off_status_bg="colour238"
        # color_window_off_status_current_bg="colour254"

        # =====================================
        # ===    Appearence and status bar  ===
        # ======================================

        set -g mode-style "fg=default,bg=$color_main"

        # command line style
        set -g message-style "fg=$color_main,bg=$color_dark"

        # status line style
        set -g status-style "fg=$color_status_text,bg=$color_dark"

        # window segments in status line
        set -g window-status-separator ""
        separator_powerline_left=""
        separator_powerline_right=""

        setw -g window-status-format " #I:#W "
        setw -g window-status-current-style "fg=$color_light,bold,bg=$color_main"
        setw -g window-status-current-format "#[fg=$color_dark,bg=$color_main]$separator_powerline_right#[default] #I:#W# #[fg=$color_main,bg=$color_dark]$separator_powerline_right#[default]"

        # when window has monitoring notification
        setw -g window-status-activity-style "fg=$color_main"

        # outline for active pane
        setw -g pane-active-border-style "fg=$color_main"

        # general status bar settings
        set -g status on
        set -g status-interval 5
        set -g status-position top
        set -g status-justify left
        set -g status-right-length 100

        # define widgets we're going to use in status bar
        # note, that this is not the complete list, some of them are loaded from plugins
        wg_session="#[fg=$color_session_text] #S #[default]"
        wg_battery="#{battery_status_fg} #{battery_icon} #{battery_percentage}"
        wg_date="#[fg=$color_secondary]%h %d %H:%M#[default]"
        wg_user_host="#[fg=$color_secondary]#(whoami)#[default]@#H"
        wg_is_zoomed="#[fg=$color_dark,bg=$color_secondary]#{?window_zoomed_flag,[Z],}#[default]"
        wg_is_keys_off="#[fg=$color_light,bg=$color_window_off_indicator]#([ $(tmux show-option -qv key-table) = 'off' ] && echo 'OFF')#[default]"

        wg_mode_prefix="#[fg=green]#[noreverse]$separator_powerline_left#[reverse][M-b]#[noreverse]$separator_powerline_right#[reverse]#[fg=defult]"
        wg_mode_sync="#{?synchronize-panes,#[fg=yellow]#[noreverse]$separator_powerline_left#[reverse][Sync]#[noreverse]$separator_powerline_right#[reverse]#[fg=defult],}"
        wg_mode="#[push-default,reverse]#{?client_prefix,$wg_mode_prefix,$wg_mode_sync}#[noreverse,pop-default,fg=default,bg=default]"

        set -g status-left "$wg_session"
        set -g status-right "$wg_mode $wg_is_keys_off $wg_is_zoomed $wg_user_host | $wg_date $wg_battery"


        # =====================================
        # ===        Renew environment      ===
        # =====================================
        set -g update-environment \
          "DISPLAY\
          SSH_ASKPASS\
          SSH_AUTH_SOCK\
          SSH_AGENT_PID\
          SSH_CONNECTION\
          SSH_TTY\
          WINDOWID\
          XAUTHORITY"

        bind '$' run "~/.config/tmux/renew_env.sh"

        # ==============================================
        # ===   Nesting local and remote sessions     ===
        # ==============================================

        # Session is considered to be remote when we ssh into host
        if-shell 'test -n "$SSH_CLIENT"' \
            'source-file ~/.config/tmux/tmux.remote.conf'

        # Also, change some visual styles when window keys are off
        bind -T root F12  \
            set prefix None \;\
            set key-table off \;\
            set status-style "fg=$color_status_text,bg=$color_window_off_status_bg" \;\
            set window-status-current-format "#[fg=$color_window_off_status_bg,bg=$color_window_off_status_current_bg]$separator_powerline_right#[default] #I:#W# #[fg=$color_window_off_status_current_bg,bg=$color_window_off_status_bg]$separator_powerline_right#[default]" \;\
            set window-status-current-style "fg=$color_dark,bold,bg=$color_window_off_status_current_bg" \;\
            if -F '#{pane_in_mode}' 'send-keys -X cancel' \;\
            refresh-client -S \;\

        bind -T off F12 \
          set -u prefix \;\
          set -u key-table \;\
          set -u status-style \;\
          set -u window-status-current-style \;\
          set -u window-status-current-format \;\
          refresh-client -S

      '';
      plugins = with pkgs; [
        tmuxPlugins.sessionist
        tmuxPlugins.pain-control
        tmuxPlugins.logging
        tmuxPlugins.open
        {
          plugin = tmuxPlugins.battery;
          extraConfig = ''
            set -g @batt_color_full_charge "#[fg=$color_level_ok]"
            set -g @batt_color_high_charge "#[fg=$color_level_ok]"
            set -g @batt_color_medium_charge "#[fg=$color_level_warn]"
            set -g @batt_color_low_charge "#[fg=$color_level_stress]"
          '';
        }
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = ''
            set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-capture-pane-contents 'on'
          '';
        }
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '60' # minutes
          '';
        }
      ];
    };
    xdg.configFile = {
      "tmux/renew_env.sh".source = ./renew_env.sh;
      "tmux/tmux.remote.conf".source = ./tmux.remote.conf;
      "tmux/kill.sh".source = ./kill.sh;
    };
  };
}
