{ lib, pkgs, config, ... }:
{
  config = {
    age.secrets = {
      "openldap.rootpw" = {
        file = ./secrets/openldap/rootpw;
        mode = "660";
        owner = config.services.openldap.user;
        group = config.services.openldap.group;
      };
    };

    fileSystems."/var/lib/openldap" = {
      device = "/dev/disk/by-id/scsi-0HC_Volume_100219012";
      fsType = "ext4";
    };

    networking.hostName = lib.mkForce "auth";
    networking.domain = "reyuzenfold.com";
    networking.defaultGateway6 = { address = "fe80::1"; interface = "enp1s0"; };
    networking.firewall.allowedTCPPorts = [ 636 ];
    networking.interfaces.enp1s0.ipv6 = {
      addresses = [
      {
        address = "2a01:4ff:f0:987c::1";
        prefixLength = 64;
      }
      ];
      routes = [
      {
        address = "2a01:4ff:f0:987c::";
        prefixLength = 64;
        type = "local";
      }
      ];
    };

    services = {
      openldap = {
        enable = true;
        mutableConfig = true;
        urlList = [ "ldap:///" "ldaps:///" ];
        settings = {
          attrs = {
            olcLogLevel = [ "conns config" ];

            /* settings for acme ssl */
            olcTLSCACertificateFile = "/var/lib/acme/${config.networking.fqdn}/full.pem";
            olcTLSCertificateFile = "/var/lib/acme/${config.networking.fqdn}/cert.pem";
            olcTLSCertificateKeyFile = "/var/lib/acme/${config.networking.fqdn}/key.pem";
            olcTLSCipherSuite = "HIGH:MEDIUM:+3DES:+RC4:+aNULL";
            olcTLSCRLCheck = "none";
            olcTLSVerifyClient = "never";
            olcTLSProtocolMin = "3.1";
          };

          children = {
            "cn=schema".includes = [
              "${pkgs.openldap}/etc/schema/core.ldif"
              "${pkgs.openldap}/etc/schema/cosine.ldif"
              "${pkgs.openldap}/etc/schema/inetorgperson.ldif"
            ];
            "olcDatabase={-1}frontend" = {
              attrs = {
                objectClass = "olcDatabaseConfig";
                olcDatabase = "{-1}frontend";
                olcAccess = [ "{0}to * by dn.exact=uidNumber=0+gidNumber=0,cn=peercred,cn=external,cn=auth manage stop by * none stop" ];
              };
            };
            "olcDatabase={0}config" = {
              attrs = {
                objectClass = "olcDatabaseConfig";
                olcDatabase = "{0}config";
                olcAccess = [ "{0}to * by * none break" ];
              };
            };
            "olcDatabase={1}mdb" = {
              attrs = {
                objectClass = [ "olcDatabaseConfig" "olcMdbConfig" ];
                olcDatabase = "{1}mdb";
                olcDbDirectory = "/var/lib/openldap/data";
                olcSuffix = "dc=reyuzenfold,dc=com";
                olcRootDN = "cn=admin,dc=reyuzenfold,dc=com";
                olcRootPW.path = config.age.secrets."openldap.rootpw".path;
                olcAccess = [
                  "{0}to attrs=userPassword by self write by anonymous auth by * none"
                  "{1}to * by * read"
                ];
              };
            };
          };
        };
      };
    };

    users.groups.acme.members = [ config.services.openldap.group ];
    security.acme.certs = {
      "${config.networking.fqdn}" = {
        extraDomainNames = [ "ldap.${config.networking.domain}" ];
        reloadServices = [ "openldap" ];
      };
    };
    systemd.services.openldap = {
      wants = [ "acme-${config.networking.fqdn}.service" ];
      after = [ "acme-${config.networking.fqdn}.service" ];
    };
  };
}
