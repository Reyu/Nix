{ config, lib, pkgs, ... }:
with lib;

let
cfg = config.hetzner-cloud;
in {
  options = {
    hetzner-cloud.enable = mkEnableOption "Hetzner Cloud Utilities";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.hc-utils ];
    services.udev.packages = [ pkgs.hc-utils ];

    # systemd.services = {
    #   "hc-net-ifup@" = {
    #     description = "Enable Hetzner Cloud private network interfaces %i";
    #     after = [ "network-online.target" ];
    #     bindsTo = [ "sys-subsystem-net-devices-%i.device" ];
    #     unitConfig = {
    #       ConditionPathExists = "!/run/dhclient.%i.pid";
    #     };
    #     serviceConfig = {
    #       RemainAfterExit = "true";
    #       ExecStart="${pkgs.dhclient}/bin/dhclient -1 -4 -v -pf /run/dhclient.%i.pid -lf /var/lib/dhcp/dhclient.%i.leases %i";
    #       PIDFile="/run/dhclient.%i.pid";
    #     };
    #   };
    #   hc-net-scan = {
    #     description = "Finds and configures Hetzner Cloud private network interfaces";
    #     wants = "systemd-udevd.service";
    #     after = "network-online.target";
    #     serviceConfig = {
    #       Type = "oneshot";
    #       ExecStart = "${pkgs.hc-utils}/bin/hc-ifscan";
    #     };
    #     wantedBy = [ "multi-user.target" ];
    #   };
    # };
  };
}
