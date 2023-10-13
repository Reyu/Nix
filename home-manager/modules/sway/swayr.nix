{ pkgs, ... }:
{
  systemd.user.services.swayr = {
    Unit = {
      Description = "Window switcher for Sway";
      Documentation = "https://sr.ht/~tsdh/swayr/";
      PartOf = "sway-session.target";
      After = "sway-session.target";
    };

    Service = {
      Type = "simple";
      Environment = "RUST_BACKTRACE=1";
      ExecStart = "${pkgs.swayr}/bin/swayrd";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "sway-session.target" ];
    };
  };
  xdg.configFile."wofi/config".text = ''
    allow-markup=true
    allow_images=true
    cache-file=/dev/null
    insensitive=true
    key_down=Control_L-n
    key_up=Control_L-p

    location=center
    height=800
    width=2000
  '';
  xdg.configFile."wofi/style.css".source = ./wofi.css;
  xdg.configFile."swayr/config.toml".text = ''
    [menu]
    executable = '${pkgs.wofi}/bin/wofi'
    args = [
        '--show=dmenu',
        '--allow-markup',
        '--allow-images',
        '--insensitive',
        '--cache-file=/dev/null',
        '--parse-search',
        '--prompt={prompt}',
    ]

    [format]
    output_format = '{indent}<b>Output {name}</b>    <span alpha="20000">({id})</span>'
    workspace_format = '{indent}<b>Workspace {name} [{layout}]</b> on output {output_name}    <span alpha="20000">({id})</span>'
    container_format = '{indent}<b>Container [{layout}]</b> <i>{marks}</i> on workspace {workspace_name}    <span alpha="20000">({id})</span>'
    window_format = 'img:{app_icon}:text:{indent}<i>{app_name}</i> — {urgency_start}<b>“{title}”</b>{urgency_end} <i>{marks}</i> on workspace {workspace_name} / {output_name}    <span alpha="20000">({id})</span>'
    indent = '    '
    urgency_start = '<span background="darkred" foreground="yellow">'
    urgency_end = '</span>'
    html_escape = true
    icon_dirs = [
        '/run/current-system/sw/share/icons/hicolor/scalable/apps',
        '/run/current-system/sw/share/icons/hicolor/48x48/apps',
        '/run/current-system/sw/share/pixmaps',
        '~/.nix-profile/share/icons/hicolor/scalable/apps',
        '~/.nix-profile/share/icons/hicolor/48x48/apps',
        '~/.nix-profile/share/pixmaps',
    ]

    [layout]
    auto_tile = false
    auto_tile_min_window_width_per_output_width = [
        [1024, 500],
        [1280, 600],
        [1400, 680],
        [1440, 700],
        [1600, 780],
        [1920, 920],
        [2560, 1000],
        [3440, 1000],
        [4096, 1200],
    ]

    [focus]
    lockin_delay = 750

    [misc]
    auto_nop_delay = 3000
    seq_inhibit = false

    [swaymsg_commands]
    include_predefined = true
    [swaymsg_commands.commands]
    "Workspace to left output" = "move workspace to output left"
    "Workspace to right output" = "move workspace to output right"
  '';
}
