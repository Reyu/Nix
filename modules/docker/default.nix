{ pkgs, config, lib, ... }:
with lib;
let cfg = config.foxnet.services.docker;
in
{
  config = {
    environment.systemPackages =
      [ pkgs.docker-client pkgs.docker-credential-helpers ];
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
    users.users.reyu.extraGroups = [ "docker" ];
  };
}
