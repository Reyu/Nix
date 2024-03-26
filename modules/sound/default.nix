{ pkgs, lib, ... }:
with lib; {
  config = {
    environment.systemPackages = with pkgs; [ pavucontrol ];
    # Enable sound.
    sound.enable = true;
    hardware.pulseaudio = { enable = true; };
  };
}
