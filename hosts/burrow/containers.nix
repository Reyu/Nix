{ config, pkgs, ... }: {
  config = {
    networking.firewall = {
      allowedTCPPorts = [
        88 # KDC
        749 # KAdmin
        636 # LDAP
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
          imports = [ ../../modules/common ../../modules/kerberos ];
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
        bindMounts = {
          "/var/db/slapd" = {
            hostPath = "/data/service/openldap/db";
            isReadOnly = false;
          };
          "/etc/slapd.d" = {
            hostPath = "/data/service/openldap/config";
            isReadOnly = false;
          };
        };
        config = { config, pkgs, ... }: {
          imports = [ ../../modules/common ];
          config = {
            services.openldap = {
              enable = true;
              configDir = "/etc/slapd.d";
              urlList = [ "ldapi:///" "ldap:///" ];
            };
          };
        };
      };
    };
  };
}
