{ pkgs, lib, ... }:
with lib; {
  # TODO: This needs to be WAY more intelligent
  environment.systemPackages = [ pkgs.wireguard ];
  networking.wireguard.enable = true;
}
