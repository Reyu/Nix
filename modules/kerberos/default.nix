{ config, pkgs, lib, ... }: {
  config.krb5 = {
    libdefaults = { "default_realm" = "REYUZENFOLD.COM"; };
    realms = {
      "REYUZENFOLD.COM" = {
        admin_server = "kerberos.reyuzenfold.com";
        kdc = [ "kerberos.reyuzenfold.com" ];
      };
    };
    domain_realm = {
      "reyuzenfold.com" = "REYUZENFOLD.COM";
      ".reyuzenfold.com" = "REYUZENFOLD.COM";
    };
  };
}
