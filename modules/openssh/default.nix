{ config, pkgs, lib, ... }:
with lib;
let cfg = config.foxnet.services.openssh;
in {

  options.foxnet.services.openssh = {
    enable = mkEnableOption "OpenSSH server";
  };

  config = mkIf cfg.enable {

    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
      passwordAuthentication = false;
      startWhenNeeded = true;
      challengeResponseAuthentication = false;
    };

    # Block anything that is not SSH.
    networking.firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [ 22 ];
    };
  };
}
