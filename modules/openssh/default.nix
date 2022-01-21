{ config, pkgs, lib, ... }:
with lib; {
  config = {
    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
      passwordAuthentication = false;
      startWhenNeeded = true;
    };

    # Block anything that is not SSH.
    networking.firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [ 22 ];
    };
  };
}
