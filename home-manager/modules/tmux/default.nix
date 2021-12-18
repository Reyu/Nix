{ lib, pkgs, config, ... }:
with lib;
let cfg = config.reyu.programs.tmux;
in
{
  options.reyu.programs.tmux.enable =
    mkEnableOption "tmux terminal mutliplexer";

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      aggressiveResize = true;
      clock24 = true;
      escapeTime = 10;
      keyMode = "vi";
      terminal = "screen-256color";
      extraConfig = ''
        unbind-key C-b
        set-option -g prefix M-b
        set-option -g visual-activity off
        set-option -g visual-bell on
        set-option -g set-titles on
        set-option -g set-titles-string '#S'
        set-option -g destroy-unattached off
        set-option -g focus-events on
        set-option -ga terminal-overrides ",alacritty:Tc"
        set-window-option -g allow-rename on
        set-window-option -g automatic-rename on
        set-window-option -g automatic-rename-format "#{?pane_in_mode,[tmux],#{pane_title}}#{?pane_dead,[dead],}"

        ###
        # Vim-Tmux-Navigation
        ###
        # Smart pane switching with awareness of Vim splits.
        # See: https://github.com/christoomey/vim-tmux-navigator
        is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
        bind-key -n M-h if-shell "$is_vim" "send-keys M-h"  "select-pane -L"
        bind-key -n M-j if-shell "$is_vim" "send-keys M-j"  "select-pane -D"
        bind-key -n M-k if-shell "$is_vim" "send-keys M-k"  "select-pane -U"
        bind-key -n M-l if-shell "$is_vim" "send-keys M-l"  "select-pane -R"
        bind-key -n M-\\ if-shell "$is_vim" "send-keys M-\\" "select-pane -l"
        bind-key -T copy-mode-vi M-h select-pane -L
        bind-key -T copy-mode-vi M-j select-pane -D
        bind-key -T copy-mode-vi M-k select-pane -U
        bind-key -T copy-mode-vi M-l select-pane -R
        bind-key -T copy-mode-vi M-\\ select-pane -l

        ###
        # Look & Feel
        ###
        set -g status-style "bg=black,fg=yellow"
        setw -g window-status-style "fg=brightblue,bg=default"
        setw -g window-status-current-style "fg=brightred,bg=default"
        set -g pane-border-style "fg=black"
        set -g pane-active-border-style "fg=brightgreen"
        set -g message-style "fg=brightred,bg=black"
        set -g display-panes-active-colour blue #blue
        set -g display-panes-colour brightred #orange
        setw -g clock-mode-colour green #green

        ###
        # status bar content
        ###
        set -g status-justify centre
        set -g status-left-length 60
        set -g status-left "#[bold]#{?client_readonly,#[fg=colour161][RO] ,}#{?client_prefix,#[fg=colour64],#{?pane_in_mode,#[fg=colour200],#[fg=colour160]}}#S#{?session_many_attached,#[fg=default]+,} #{session_alerts}"
        set -g status-right-length 160
        set -g status-right "#{battery_icon}#[fg=blue]:#{battery_status_fg}#{battery_percentage}#[fg=blue]:#{battery_remain} #[fg=blue]| #[fg=yellow]CPU#{cpu_fg_color}#{cpu_icon}#{cpu_percentage} #[fg=blue]| #[fg=yellow]Online: #{online_status} #[fg=blue]| #[fg=yellow]%a %h-%d %H:%M #[fg=blue]| #[fg=yellow]#H"
        setw -g window-status-format "#I#{?window_linked,+,}:#W#F"
        setw -g window-status-current-format "#I#{?window_linked,+,}:#W#F"
      '';
      plugins = with pkgs; [
        tmuxPlugins.sessionist
        tmuxPlugins.pain-control
        tmuxPlugins.logging
        tmuxPlugins.copycat
        tmuxPlugins.yank
        tmuxPlugins.open
        tmuxPlugins.sidebar
        tmuxPlugins.battery
        tmuxPlugins.online-status
        tmuxPlugins.cpu
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
  };
}
