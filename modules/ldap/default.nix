{ config, pkgs, lib, ... }: {
  options.foxnet.ldap = {
  };
  config = let cfg = config.foxnet.krb;
  in {
    users.ldap = {
      server = lib.mkDefault "ldap://ismene.home.reyuzenfold.com";
      base = lib.mkDefault "dc=reyuzenfold,dc=com";
    };
  };
}
