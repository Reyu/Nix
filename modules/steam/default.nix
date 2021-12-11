{ config, pkgs, lib, ... }:
with lib;
let cfg = config.foxnet.steam;
in {

  options.foxnet.steam = {
    enable = mkEnableOption "Steam";
  };

  config = mkIf cfg.enable {

    programs.steam.enable = true;

  };
}
