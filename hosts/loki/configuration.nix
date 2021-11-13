{ self, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  foxnet.desktop = {
    enable = true;
    hostname = "loki";
    hostId = "d540cb4f";
  };
  foxnet.services = {
    docker.enable = true;
  };
}
