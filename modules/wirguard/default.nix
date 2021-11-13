{ pkgs, config, lib, ... }: {
  environment.systemPackages = [ pkgs.wireguard ];
  networking.wireguard.enable = true;
}
