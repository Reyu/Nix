{ config, pkgs, ... }: {
  config.containers = {
    kerberos = {
      autoStart = true;
      bindMounts = {
        "/var/heimdal" = { hostPath = "/data/service/krb5";
                           isReadOnly = false; };
      };
      config = { config, pkgs, ... }: {
        imports = [ ../../common ];
        config = {
          krb5 = {
            kerberos = pkgs.heimdal;
            extraConfig = ''
              [kdc]
                database = {
                  mkey_file = /var/heimdal/m-key
                  acl_file = /var/heimdal/kadm5.acl
                }
              '';
          };
          systemd.services = {
            kadmind = {
              description = "Remote Administration daemon";
              path = [ pkgs.heimdal ];
              script = "${pkgs.heimdal}/libexec/heimdal/kadmind";
              wantedBy = [ "multi-user.target" ];
            };
            kdc = {
              description = "Key Distribution Center daemon";
              path = [ pkgs.heimdal ];
              script = "${pkgs.heimdal}/libexec/heimdal/kdc";
              wantedBy = [ "multi-user.target" ];
            };
          };
          networking.firewall = {
            allowedTCPPorts = [
              88   # KDC
              749  # KADMIND
            ];
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
