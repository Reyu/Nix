{ config, pkgs, lib, ... }:
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
    settings.tree_view = true;
    settings.vimMode = true;
  };

  programs.jq.enable = true;

  programs.bat = {
    enable = true;
  };

  xdg.configFile = {
    "direnv/lib/use_flake.sh".source = ./use_flake.sh;
    "neofetch/config.conf".source = ./neofetch.conf;
  };
}
