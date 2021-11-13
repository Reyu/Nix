{ config, pkgs, lib, ... }:
with lib;
let cfg = config.foxnet.defaults.ldap;
in {
  options.foxnet.defaults.ldap.enable = mkEnableOption "LDAP Defaults";
  config.users.ldap = mkIf cfg.enable {
    server = "ldap://ismene.home.reyuzenfold.com";
    base = "dc=reyuzenfold,dc=com";
  };
}
