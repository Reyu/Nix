{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.reyu.ldap;
in {
  users.ldap = {
    base = "dc=reyuzenfold,dc=com";
    useTLS = true;
  };
}
