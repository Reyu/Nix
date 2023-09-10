{ pkgs, config, lib, ... }:
with lib;
{
  config = {
    virtualisation = {
      docker.enable = lib.mkForce false;
      podman = {
          enable = true;
          dockerCompat = true;
          dockerSocket.enable = true;
          defaultNetwork.settings.dns_enabled = true;
      };
    };
  };
}
