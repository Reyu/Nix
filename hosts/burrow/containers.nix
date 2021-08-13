{ config, pkgs, ... }: {
  config = {
    networking.firewall = {
      allowedTCPPorts = [
        88 # KDC
        749 # KAdmin
      ];
      allowedUDPPorts = [
        88 # KDC
        749 # KAdmin
      ];
    };
    containers = {
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
          };
        };
      };
    };
  };
}
