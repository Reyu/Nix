{ pkgs, ... }:
{
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      pulseSupport = true;
      githubSupport = true;
      mpdSupport = true;
    };
    script = "polybar -r primary &";

    config = ./config;
    extraConfig = ''
      [module/xmonad]
      type = custom/script
      exec = ${pkgs.xmonad-log}/bin/xmonad-log
      tail = true
    '';
  };
}
