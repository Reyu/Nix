{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common
    ../../common/raspberrypi
    ../../common/users.nix
  ];

  environment.systemPackages = with pkgs; [ consul-template ];

  networking = {
    hostName = "ismene";
  };

  services = {
    consul = {
      enable = true;
      # extraConfig = {
      #   datacenter = "home";
      #   domain = "consul.reyuzenfold.com";
      #   server = true;
      #   bootstrap = true;
      # };
    };
    vault.enable = true;
    salt.master.enable = true;
    salt.minion.enable = true;
  };
}
