{
  lib,
  pkgs,
  config,
  ...
}:
let
  krb5 = pkgs.krb5.override { withLdap = true; };
  olcRuleMap =
    # Remove newlines and consecutive whitespace.
    # Lets the config, here, be easier to read, while minimizing in config files.
    with builtins;
    with lib.lists;
    with lib.strings;
    imap0 (
      index: rule:
      "{${toString index}}" + concatStringsSep " " (
        filter (char: char != "") (splitString " " (replaceStrings [ "\n" ] [ " " ] rule))
      )
    );
in
{
  config = {
    age.secrets = {
      "cachix-agent.token" = {
        file = ./secrets/auth/cachix-agent.token;
        path = "/etc/cachix-agent.token";
      };
      "ldap.keytab" = {
        file = ./secrets/auth/ldap.keytab;
        mode = "440";
        owner = config.services.openldap.user;
        group = config.services.openldap.group;
      };
      "openldap.rootpw" = {
        file = ./secrets/openldap/rootpw;
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

    networking.firewall.allowedTCPPorts =
      let
        listeningOn = x: lib.lists.elem x config.services.openldap.urlList;
      in
      [
        (lib.mkIf (listeningOn "ldap:///") 389)
        (lib.mkIf (listeningOn "ldaps:///") 636)
        88 # Kerberos V5 KDC
        543 # Kerberos authenticated rlogin
        544 # and remote shell
        749 # Kerberos 5 admin/changepw
        2105 # Kerberos auth. & encrypted rlogin
      ];
    networking.firewall.allowedUDPPorts = [
      88 # Kerberos V5 KDC
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
    networking.hostFiles =
      let
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
          in
          pkgs.writeText "string-hosts" (
            allToString (lib.filterAttrs (_: v: v != [ ]) config.networking.hosts)
          );
        extraHosts = pkgs.writeText "extra-hosts" config.networking.extraHosts;
      in
      lib.mkForce [
        stringHosts
        localhostHosts
        extraHosts
      ];

    services = {
      openldap = {
        enable = true;
        mutableConfig = false;
        urlList = [
          "ldaps://"
          "ldap:///"
          "ldapi:///"
        ];
        settings = {
          attrs = {
            olcLogLevel = [ "acl stats" ];

            # settings for acme ssl
            olcTLSCACertificateFile = config.security.acme.certs.ldap.directory + "/full.pem";
            olcTLSCertificateFile = config.security.acme.certs.ldap.directory + "/cert.pem";
            olcTLSCertificateKeyFile = config.security.acme.certs.ldap.directory + "/key.pem";
            olcTLSCipherSuite = "HIGH:MEDIUM:+3DES:+RC4:+aNULL";
            olcTLSCRLCheck = "none";
            olcTLSVerifyClient = "never";
            olcTLSProtocolMin = "3.1";

            # SASL authentication
            olcSaslHost = "auth.ash.reyuzenfold.com";
            olcSaslRealm = "REYUZENFOLD.COM";
            olcSaslSecProps = "noplain,noanonymous";
            olcAuthzRegexp = olcRuleMap [
              ''"uid=([^/]*)/admin,(cn=reyuzenfold.com,)?cn=gssapi,cn=auth" "cn=admin,dc=reyuzenfold,dc=com"''
              ''"uid=([^/,]*)(/[^,]*)?,(cn=reyuzenfold.com,)?cn=gssapi,cn=auth" "uid=$1,ou=users,dc=reyuzenfold,dc=com''
              ''"uid=host/([^,]*).reyuzenfold.com,(cn=reyuzenfold.com,)?cn=gssapi,cn=auth" "cn=$1,ou=systems,dc=reyuzenfold,dc=com''
            ];
          };

          children = {
            "cn=schema".includes = [
              "${pkgs.openldap}/etc/schema/core.ldif"
              "${pkgs.openldap}/etc/schema/cosine.ldif"
              "${pkgs.openldap}/etc/schema/inetorgperson.ldif"
              ./files/rfc2307bis.ldif
              ./files/kerberos.openldap.ldif
            ];
            "cn=module{1}" = {
              attrs = {
                objectClass = [ "olcModuleList" ];
                olcModuleLoad = [
                  "memberof"
                  "refint"
                ];
                olcModulePath = "/usr/lib/ldap";
              };
            };
            "olcDatabase={-1}frontend" = {
              attrs = {
                objectClass = "olcDatabaseConfig";
                olcDatabase = "{-1}frontend";
                olcAccess = olcRuleMap [ ''to dn.base="" by * read'' ];
              };
            };
            "olcDatabase={0}config" = {
              attrs = {
                objectClass = "olcDatabaseConfig";
                olcDatabase = "{0}config";
                olcAccess = olcRuleMap [
                  ''to *
                      by group.exact="cn=Administrators,dc=reyuzenfold,dc=com" read
                      by dn.exact=uidNumber=0+gidNumber=0,cn=peercred,cn=external,cn=auth write stop''
                  ''to *
                      by * none break''
                ];
              };
            };
            "olcDatabase={1}mdb" = {
              attrs = {
                objectClass = [
                  "olcDatabaseConfig"
                  "olcMdbConfig"
                ];
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
                olcAccess =
                  let
                    root = ''dn.exact=uidNumber=0+gidNumber=0,cn=peercred,cn=external,cn=auth'';
                    admins = ''group.exact="cn=administrators,dc=reyuzenfold,dc=com"'';
                    kdc = ''dn.exact="uid=kdc,ou=kerberos,ou=services,dc=reyuzenfold,dc=com"'';
                    kadmin = ''dn.exact="uid=kadmin,ou=kerberos,ou=services,dc=reyuzenfold,dc=com"'';
                  in
                  olcRuleMap [
                    ''to * by ${root} write by * none break''
                    # ================================================================================
                    # ============= Ensure authentication keys are protected but usable ==============
                    # ================================================================================
                    ''to attrs=userPassword
                        by self write
                        by ${admins} write
                        by anonymous auth''
                    ''to attrs=krbPrincipalKey
                        by self write
                        by ${kdc} write
                        by ${kadmin} write
                        by anonymous auth''
                    # ================================================================================
                    # ================= Restrict access to core kerberos containers ==================
                    # ================================================================================
                    ''to dn.subtree="cn=krbcontainer,dc=reyuzenfold,dc=com"
                        by ${kdc} write
                        by ${kadmin} write
                        by ${admins} read''
                    # ================================================================================
                    # ====================== Restrict access to kerberos fields ======================
                    # ================================================================================
                    ''to attrs=krbLastFailedAuth,krbLastSuccessfulAuth,krbLoginFailedCount
                        by ${kdc} write
                        by ${kadmin} write
                        by ${admins} read
                        by self read''
                    ''to attrs=krbLastPwdChange,krbPasswordExpiration,krbCanonicalName,krbPrincipalName
                        by ${kdc} read
                        by ${kadmin} write
                        by ${admins} read
                        by self read''
                    ''to attrs=krbExtraData,krbObjectReferences,krbPwdPolicyReference,krbTicketFlags
                        by ${kdc} read
                        by ${kadmin} write
                        by ${admins} read''
                    # ================================================================================
                    # ========================== Allow some self management ==========================
                    # ================================================================================
                    ''to attrs=displayName,givenName,mail,mobile,sn
                        by ${admins} write
                        by self write
                        by users read''
                    # ================================================================================
                    # ========================= Some extra container config ==========================
                    # ================================================================================
                    ''to dn.subtree="ou=users,dc=reyuzenfold,dc=com"
                        by ${kdc} read
                        by ${kadmin} write
                        by ${admins} write
                        by users read''
                    ''to dn.subtree="ou=groups,dc=reyuzenfold,dc=com"
                        by ${kdc} read
                        by ${kadmin} write
                        by ${admins} write
                        by users read''
                    ''to dn.subtree="ou=systems,dc=reyuzenfold,dc=com"
                        by ${kdc} read
                        by ${kadmin} write
                        by ${admins} write
                        by users read''
                    ''to dn.subtree="ou=services,dc=reyuzenfold,dc=com"
                        by ${kdc} read
                        by ${kadmin} write
                        by ${admins} write
                        by users read''
                    # ================================================================================
                    # =============================== General fallback ===============================
                    # ================================================================================
                    ''to dn.subtree="dc=reyuzenfold,dc=com"
                        by ${admins} write
                        by users read''
                  ];
              };
              children = {
                "olcOverlay={0}memberof" = {
                  attrs = {
                    objectClass = [
                      "olcConfig"
                      "olcMemberOf"
                      "olcOverlayConfig"
                    ];
                    olcOverlay = "memberof";
                    olcMemberOfDangling = "ignore";
                    olcMemberOfRefInt = "TRUE";
                    olcMemberOfGroupOC = "groupOfNames";
                    olcMemberOfMemberAD = "member";
                    olcMemberOfMemberOfAD = "memberOf";
                  };
                };
                "olcOverlay={1}refint" = {
                  attrs = {
                    objectClass = [
                      "olcConfig"
                      "olcRefintConfig"
                      "olcOverlayConfig"
                    ];
                    olcOverlay = "refint";
                    olcRefintAttribute = [
                      "memberof"
                      "member"
                      "manager"
                      "owner"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
    systemd.services.openldap.environment = {
      KRB5_KTNAME = config.age.secrets."ldap.keytab".path;
    };

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
    systemd.services.kdc.wants = [ "openldap.service" ];
    systemd.services.kadmind.wants = [ "openldap.service" ];

    security.acme.certs = {
      "ldap" = {
        domain = config.networking.fqdn;
        extraDomainNames = [ "ldap.${config.networking.domain}" ];
        reloadServices = [ "openldap" ];
      };
    };
    systemd.services.openldap.wants = [
      "acme-ldap.${config.networking.domain}.service"
    ];
    users.groups.acme.members = [ config.services.openldap.group ];

    services.fail2ban.jails.slapd = {
      enabled = true;
    };
  };
}
