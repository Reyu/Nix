{ config, pkgs, ... }: {
  config.containers = {
    kerberos = {
      autoStart = true;
      bindMounts = {
        "/var/heimdal" = {
          hostPath = "/data/service/krb5";
          isReadOnly = false;
        };
      };
      config = { config, pkgs, ... }: {
        imports = [ ../../modules/common ../../modules/kerberos.nix ];
        config = {
          foxnet.krb = {
            kdc.enabled = true;
            kadmind.enabled = true;
          };
        };
      };
    };
    ldap = {
      autoStart = true;
      config = { config, pkgs, ... }: {
        imports = [ ../../modules/common ];
        config = {
          services.openldap = {
            enable = true;
            configDir = "/var/db/slapd.d";
            urlList = [ "ldapi:///" "ldaps:///" ];
          };
          networking.firewall = {
            allowedTCPPorts = [
              636 # LDAPS
            ];
          };
        };
      };
    };
  };
}
