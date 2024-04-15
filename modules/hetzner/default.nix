{
  config,
  lib,
  pkgs,
  ...
}:
with lib;

let
  cfg = config.hetzner-cloud;
in
{
  options = {
    hetzner-cloud.enable = mkEnableOption "Hetzner Cloud Utilities";
  };
  config = mkIf cfg.enable { services.udev.packages = [ pkgs.hc-utils ]; };
}
