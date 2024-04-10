{ lib, pkgs, config, ... }:
let
  krb5 = pkgs.krb5.override { withLdap = true; };
in
{
  config = {
    age.secrets = {
      "openldap.rootpw" = {
        file = ./secrets/openldap/rootpw;
        mode = "440";
        owner = config.services.openldap.user;
        group = config.services.openldap.group;
      };
      "ldap.keytab" = {
        file = ./secrets/auth/ldap.keytab;
        mode = "440";
        owner = config.services.openldap.user;
        group = config.services.openldap.group;
      };
      "kdb5.stash" = {
        file = ./secrets/krb5/kdb5.stash;
      };
    };

    fileSystems."/var/lib/openldap" = {
      device = "/dev/disk/by-id/scsi-0HC_Volume_100219012";
      fsType = "ext4";
    };

    networking.firewall.allowedTCPPorts = let
      listeningOn = x: lib.lists.elem x config.services.openldap.urlList;
    in [
      (lib.mkIf (listeningOn "ldap:///") 389)
      (lib.mkIf (listeningOn "ldaps:///") 636)
      88   # Kerberos V5 KDC
      543  # Kerberos authenticated rlogin
      544  # and remote shell
      749  # Kerberos 5 admin/changepw
      2105 # Kerberos auth. & encrypted rlogin
    ];
    networking.firewall.allowedUDPPorts = [
      88  # Kerberos V5 KDC
      749 # Kerberos 5 admin/changepw
    ];
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
    networking.hostFiles = let
      # Copied from nixpkgs to put real hostname first,
      # because it seems whatever the first option is, is what
      # slapd tries to use for the SASL hostname...
      localhostHosts = pkgs.writeText "localhost-hosts" ''
        127.0.0.1 localhost
        ${lib.optionalString config.networking.enableIPv6 "::1 localhost"}
      '';
      stringHosts =
        let
          oneToString = set: ip: ip + " " + lib.concatStringsSep " " set.${ip} + "\n";
          allToString = set: lib.concatMapStrings (oneToString set) (lib.attrNames set);
        in pkgs.writeText "string-hosts" (allToString (lib.filterAttrs (_: v: v != []) config.networking.hosts));
      extraHosts = pkgs.writeText "extra-hosts" config.networking.extraHosts;
    in lib.mkBefore [ stringHosts localhostHosts extraHosts ];

    services = {
      openldap = {
        enable = true;
        mutableConfig = false;
        urlList = [ "ldaps://" "ldap:///" "ldapi:///" ];
        settings = {
          attrs = {
            olcLogLevel = [ "acl stats" ];

            /* settings for acme ssl */
            olcTLSCACertificateFile = config.security.acme.certs.ldap.directory + "/full.pem";
            olcTLSCertificateFile = config.security.acme.certs.ldap.directory + "/cert.pem";
            olcTLSCertificateKeyFile = config.security.acme.certs.ldap.directory + "/key.pem";
            olcTLSCipherSuite = "HIGH:MEDIUM:+3DES:+RC4:+aNULL";
            olcTLSCRLCheck = "none";
            olcTLSVerifyClient = "never";
            olcTLSProtocolMin = "3.1";

            /* SASL authentication */
            olcSaslHost = "auth.reyuzenfold.com";
            olcSaslRealm = "REYUZENFOLD.COM";
            olcSaslSecProps = "noplain,noanonymous";
            olcAuthzRegexp = [
              ''{0}"uid=([^/]*)/admin,(cn=reyuzenfold.com,)?cn=gssapi,cn=auth" "cn=admin,dc=reyuzenfold,dc=com"''
              ''{1}"uid=([^,]*),(cn=reyuzenfold.com,)?cn=gssapi,cn=auth" "uid=$1,ou=users,dc=reyuzenfold,dc=com''
              ''{2}"uid=host/([^,]*).reyuzenfold.com,(cn=reyuzenfold.com,)?cn=gssapi,cn=auth" "cn=$1,ou=systems,dc=reyuzenfold,dc=com''
            ];
          };

          children = {
            "cn=schema".includes = [
              "${pkgs.openldap}/etc/schema/core.ldif"
              "${pkgs.openldap}/etc/schema/cosine.ldif"
              "${pkgs.openldap}/etc/schema/inetorgperson.ldif"
              "${pkgs.openldap}/etc/schema/nis.ldif"
              ./kerberos.openldap.ldif
            ];
            "olcDatabase={-1}frontend" = {
              attrs = {
                objectClass = "olcDatabaseConfig";
                olcDatabase = "{-1}frontend";
                olcAccess = [
                  ''{0}to dn.base="" by * read''
                ];
              };
            };
            "olcDatabase={0}config" = {
              attrs = {
                objectClass = "olcDatabaseConfig";
                olcDatabase = "{0}config";
                olcAccess = [
                  ''{0}to *
                      by group.exact="cn=Administrators,dc=reyuzenfold,dc=com" read
                      by dn.exact=uidNumber=0+gidNumber=0,cn=peercred,cn=external,cn=auth manage stop''
                  ''{2}to * by * none break''
                ];
              };
            };
            "olcDatabase={1}mdb" = {
              attrs = {
                objectClass = [ "olcDatabaseConfig" "olcMdbConfig" ];
                olcDatabase = "{1}mdb";
                olcDbDirectory = "/var/lib/openldap/data";
                olcRootDN = "cn=admin,dc=reyuzenfold,dc=com";
                # olcRootPW.path = config.age.secrets."openldap.rootpw".path;
                olcDbIndex = [
                  "objectClass eq"
                  "cn pres,eq"
                  "uid pres,eq"
                  "sn pres,eq,subany"
                  "krbPrincipalName eq,pres,sub"
                ];
                olcSuffix = "dc=reyuzenfold,dc=com";
                olcAccess = let
                    root = ''dn.exact=uidNumber=0+gidNumber=0,cn=peercred,cn=external,cn=auth'';
                    admins = ''group.exact="cn=administrators,dc=reyuzenfold,dc=com"'';
                    kdc = ''dn.exact="uid=kdc,ou=kerberos,ou=services,dc=reyuzenfold,dc=com"'';
                    kadmin = ''dn.exact="uid=kadmin,ou=kerberos,ou=services,dc=reyuzenfold,dc=com"'';
                in [
                  ''{0}to * by ${root} manage by * none break''
                  /* === Restrict access to sensitive keys === */
                  ''{1}to attrs=userPassword
                      by ssf=256 self write
                      by ssf=256 ${admins} write
                      by ssf=64 anonymous auth''
                  ''{2}to attrs=krbPrincipalKey
                      by ${kdc} manage
                      by ${kadmin} manage
                      by ssf=256 self write
                      by ssf=64 anonymous auth''
                  /* === Restrict access to kerberos containers === */
                  ''{3}to dn.subtree="cn=krbcontainer,dc=reyuzenfold,dc=com"
                      by ${kdc} manage
                      by ${kadmin} manage
                      by ${admins} read''
                  /* === Allow some self management === */
                  ''{4}to attrs=mail,mobile,displayName,givenName,sn
                      by ssf=256 ${admins} write
                      by self write
                      by users read''
                  /* === Some extra container config === */
                  ''{5}to dn.subtree="ou=users,dc=reyuzenfold,dc=com"
                      by ${kdc} write
                      by ${kadmin} write
                      by ssf=256 ${admins} write
                      by users read''
                  ''{6}to dn.subtree="ou=groups,dc=reyuzenfold,dc=com"
                      by ${kdc} write
                      by ${kadmin} write
                      by ssf=256 ${admins} write
                      by users read''
                  ''{7}to dn.subtree="ou=systems,dc=reyuzenfold,dc=com"
                      by ${kdc} write
                      by ${kadmin} write
                      by ssf=256 ${admins} write
                      by users read''
                  ''{8}to dn.subtree="ou=services,dc=reyuzenfold,dc=com"
                      by ${kdc} write
                      by ${kadmin} write
                      by ssf=256 ${admins} write
                      by users read''
                  /* General fallback */
                  ''{9}to dn.subtree="dc=reyuzenfold,dc=com"
                      by ssf=256 ${admins} write
                      by users read''
                ];
              };
            };
          };
        };
      };
    };
    systemd.services.openldap.environment = { KRB5_KTNAME = config.age.secrets."ldap.keytab".path; };

    services.kerberos_server = {
      enable = true;
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
    security.krb5 = {
      enable = true;
      package = krb5;
      settings.dbmodules."REYUZENFOLD.COM" = {
        db_library = "kldap";
        ldap_kerberos_container_dn = "cn=krbcontainer,dc=reyuzenfold,dc=com";
        ldap_kdc_dn = "uid=kdc,ou=kerberos,ou=services,dc=reyuzenfold,dc=com";
        ldap_kadmind_dn = "uid=kadmin,ou=kerberos,ou=services,dc=reyuzenfold,dc=com";
        ldap_service_password_file = config.age.secrets."kdb5.stash".path;
        ldap_servers = "ldapi://";
      };
    };
    systemd.services.kdc = {
      wants = [ "openldap.service" ];
      after = [ "openldap.service" ];
    };
    systemd.services.kadmind = {
      wants = [ "openldap.service" ];
      after = [ "openldap.service" ];
    };

    security.acme.certs = {
      "ldap" = {
        domain = config.networking.fqdn;
        extraDomainNames = [
          "ldap.${config.networking.domain}"
        ];
        reloadServices = [ "openldap" ];
      };
    };
    systemd.services.openldap = {
      wants = [ "acme-ldap.${config.networking.domain}.service" ];
      after = [ "acme-ldap.${config.networking.domain}.service" ];
    };
    users.groups.acme.members = [ config.services.openldap.group ];
  };
}
