{ config, pkgs, ... }: {
  config.containers = {
    kerberos = {
      autoStart = true;
      bindMounts = {
        "/var/heimdal" = { hostPath = "/data/service/krb5";
                           isReadOnly = false; };
      };
      config = { config, pkgs, ... }: {
        imports = [
          ../../common
          ../../modules/kerberos.nix
          ];
        };
        config = {
          krb5 = {
            kdc.enabled = true;
            kadmind.enabled = true;
          };
        };
      };
    };
    ldap = {
      autoStart = true;
      config = { config, pkgs, ... }: {
        imports = [ ../../common ];
        config = {
          services.openldap = {
            enable = true;
            configDir = "/var/db/slapd.d";
            urlList = [
              "ldapi:///"
              "ldaps:///"
            ];
          };
          networking.firewall = {
            allowedTCPPorts = [
              636  # LDAPS
            ];
          };
        };
      };
    };
  };
}
