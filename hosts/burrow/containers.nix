{ config, pkgs, ... }: {
  config = {
    networking.firewall = {
      allowedTCPPorts = [
        88 # KDC
        464 # kpasswd
        749 # KAdmin
        750 # KDC
        389 # OpenLdap
      ];
      allowedUDPPorts = [
        88 # KDC
        464 # kpasswd
        750 # KDC
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
            networking = {
              hostName = "kerberos";
              domain = "home.reyuzenfold.com";
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
          imports = [ ../../modules/common ../../modules/kerberos ];
          config = {
            services.openldap = {
              enable = true;
              configDir = "/etc/slapd.d";
              urlList = [ "ldapi:///" "ldap:///" ];
            };
            networking = {
              hostName = "ldap";
              domain = "home.reyuzenfold.com";
            };
          };
        };
      };
    };
  };
}
