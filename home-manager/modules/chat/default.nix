{ config, pkgs, libs, inputs, ... }:
{
  home.packages = with pkgs; [
    (discord-plugged.override {
      plugins = [
        inputs.discord-better-status
        inputs.discord-read-all
        inputs.discord-theme-toggler
        inputs.discord-tweaks
        inputs.discord-vc-timer
      ];
      themes = [ inputs.discord-theme-slate ];
    })
    element-desktop
    slack
    tdesktop
  ];
}
