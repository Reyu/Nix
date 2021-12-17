{ config, pkgs, lib, ... }: {
  services.picom = {
    enable = true;
    fade = true;
    fadeDelta = 5;
  };
}
