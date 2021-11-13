{ config, pkgs, lib, ... }:
with lib;
let cfg = config.foxnet.defaults.sound;
in {

  options.foxnet.defaults.sound = { enable = mkEnableOption "sound defaults"; };
  config = mkIf cfg.enable {
    
    environment.systemPackages = with pkgs; [ pavucontrol ];
    # Enable sound.
    sound.enable = true;
    hardware.pulseaudio = {
      enable = true;
      #package = pkgs.pulseaudioFull;
    };
  };
}
