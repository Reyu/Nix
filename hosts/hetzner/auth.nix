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
      "krb5_service.pass" = {
        file = ./secrets/krb5/ldap_service_password;
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
              ./kerberos.openldap.ldif
            ];
            "olcDatabase={-1}frontend" = {
              attrs = {
                objectClass = "olcDatabaseConfig";
                olcDatabase = "{-1}frontend";
                olcAccess = [
                  ''{0}to *
                      by dn.exact=uidNumber=0+gidNumber=0,cn=peercred,cn=external,cn=auth manage stop
                      by * none stop''
                ];
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
                  ''{0}to attrs=userPassword
                      by self write
                      by anonymous auth
                      by * none''

                  ''{1}to attrs=shadowLastChange
                      by self write
                      by * read''

                  ''{2}to attrs=krbPrincipalKey
                      by anonymous auth
                      by dn.exact="uid=kdc-service,dc=example,dc=com" read
                      by dn.exact="uid=kadmin-service,dc=example,dc=com" write
                      by self write
                      by * none''

                  ''{3}to dn.subtree="cn=krbcontainer,dc=reyuzenfold,dc=com"
                      by dn.exact="cn=kdc-service,dc=reyuzenfold,dc=com" write
                      by dn.exact="cn=adm-service,dc=reyuzenfold,dc=com" write
                      by * none''

                  ''{4}to dn.subtree="ou=users,dc=reyuzenfold,dc=com"
                      by dn.exact="cn=kdc-service,dc=reyuzenfold,dc=com" write
                      by dn.exact="cn=adm-service,dc=reyuzenfold,dc=com" write
                      by * none''

                  ''{5}to *
                      by * read''
                ];
              };
            };
          };
        };
      };
    };

    services.kerberos_server = {
      enable = false;
      realms = {
        "REYUZENFOLD.COM".acl = [
          {
            access = "all";
            principal = "*/admin";
          }
          {
            access = "all";
            principal = "admin";
          }
        ];
      };
    };
    security.krb5.settings.dbmodules."REYUZENFOLD.COM" = {
      db_library = "kldap";
      ldap_kerberos_container_dn = "cn=krbcontainer,dc=reyuzenfold,dc=com";
      ldap_kdc_dn = "cn=kdc-service,dc=reyuzenfold,dc=com";
      ldap_kadmind_dn = "cn=adm-service,dc=reyuzenfold,dc=com";
      ldap_service_password_file = config.age.secrets."krb5_service.pass".path;
      ldap_servers = "ldaps://ldap.${config.networking.domain}";
    };

    systemd.services.openldap = {
      wants = [ "acme-ldap.${config.networking.domain}.service" ];
      after = [ "acme-ldap.${config.networking.domain}.service" ];
    };

    users.groups.acme.members = [ config.services.openldap.group ];
    security.acme.defaults.group = "certs";

    security.acme.certs = {
      # "${config.networking.fqdn}" = {};
      "ldap.${config.networking.domain}" = {
        reloadServices = [ "openldap" ];
      };
      "kerberos.${config.networking.domain}" = {
        extraDomainNames = [
          "kadmin.${config.networking.domain}"
          "kdc.${config.networking.domain}"
        ];
        reloadServices = [ "kadmind" "kdc" ];
      };
    };
  };
}
