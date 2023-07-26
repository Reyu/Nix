{ pkgs, ... }:
{

  imports = [
    ./starship.nix
    ./zsh.nix
  ];

  home.packages = with pkgs; [
    htop
    keychain
    libsecret
    perl
    ntfy-sh
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--inline-info"
    ];
  };

  programs.direnv.enable = true;

  programs.dircolors = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.htop = {
    enable = true;
    settings = {
      account_guest_in_cpu_meter = "1";
      all_branches_collapsed = "1";
      color_scheme = "6";
      column_meter_modes_0 = "1 1 1 1 2 2 2";
      column_meter_modes_1 = "1 2 2 2 2 2 2";
      column_meters_0 = "LeftCPUs4 CPU Memory ZFSARC DiskIO NetworkIO Systemd";
      column_meters_1 = "RightCPUs4 CPU Memory ZFSARC Tasks LoadAverage Uptime";
      detailed_cpu_time = "1";
      header_margin = "0";
      hide_function_bar = "1";
      highlight_base_name = "1";
      shadow_other_users = "1";
      show_program_path = "1";
      show_thread_names = "1";
    };
  };

  programs.jq.enable = true;

  programs.bat = {
    enable = true;
  };

  programs.ssh = {
    hashKnownHosts = true;
  };

  xdg.configFile = {
    "neofetch/config.conf".source = ./neofetch.conf;
  };
}
