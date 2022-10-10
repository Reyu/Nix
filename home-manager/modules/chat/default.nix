{ config, pkgs, libs, inputs, ... }:
{
  home.packages = with pkgs; [
    (inputs.replugged.lib.makeDiscordPlugged {
      inherit pkgs;
      plugins = {
        inherit (inputs) discord-better-status discord-read-all discord-theme-toggler discord-tweaks discord-vc-timer;
      };
      themes = { inherit (inputs) discord-theme-slate; };
    })
    element-desktop
    slack
    tdesktop
  ];
}
