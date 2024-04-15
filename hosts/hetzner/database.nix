{ pkgs, lib, config, ... }: {
  config = {

    fileSystems."/boot" = lib.mkForce
    {
      device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_45152206-part15";
      fsType = "vfat";
    };
    fileSystems.${builtins.dirOf config.services.postgresql.dataDir} = {
      device = "/dev/disk/by-id/scsi-0HC_Volume_100563488";
      fsType = "ext4";
    };

    age.secrets = {
      "host.keytab" = {
        file = ./secrets/database/ash/host.keytab;
        path = "/etc/krb5.keytab";
      };
      "pg_hba.ldap.conf" = {
        file = ./secrets/database/pg_hba_ldap;
        owner = "postgres";
        group = "postgres";
      };
      "psql.keytab" = {
        file = ./secrets/database/ash/psql.keytab;
        owner = "postgres";
        group = "postgres";
      };
      "cachix-agent.token".file = ./secrets/database/ash/cachix-agent.token;
    };

    networking.hostName = lib.mkForce "database";
    networking.domain = "ash.reyuzenfold.com";
    networking.firewall.allowedTCPPorts = [ config.services.postgresql.settings.port ];
    networking.interfaces.enp1s0.ipv6 = {
      addresses = [
        {
          address = "2a01:4ff:f0:b436::1";
          prefixLength = 64;
        }
      ];
      routes = [
        {
          address = "2a01:4ff:f0:b436::";
          prefixLength = 64;
          type = "local";
        }
      ];
    };

    services.postgresql = {
      enable = true;
      # package = pkgs.postgresql_16.overrideAttrs (final: prev: {
      #     buildInputs = prev.buildInputs ++ [ pkgs.openldap ];
      #     configureFlags = prev.configureFlags ++ ["--with-ldap"];
      # });

      enableTCPIP = true;
      ensureUsers = [
        {
          name = "reyu";
          ensureClauses = { login = true; createrole = true; createdb = true; };
          ensureDBOwnership = true;
        }
      ];
      ensureDatabases = [
        "reyu"
      ];
      authentication = ''
        # TYPE          DATABASE    USER    ADDRESS         METHOD
        host            all         all     100.64.0.0/10   gss map=foxnet
        hostgssenc      all         all     all             gss map=foxnet

        # include_if_exists  ${config.age.secrets."pg_hba.ldap.conf".path}
      '';
      identMap = ''
        foxnet /^(.*)@reyuzenfold\.com$ \1
      '';
      settings = let
        certDir = "/run/credentials/postgresql.service";
      in {
        ssl = true;
        ssl_cert_file = "${certDir}/cert.pem";
        ssl_key_file = "${certDir}/key.pem";
        krb_server_keyfile = config.age.secrets."psql.keytab".path;
      };
    };

    security.acme.certs.postgres = {
      domain = config.networking.fqdn;
      extraDomainNames = [
        "database.${config.networking.domain}"
      ];
      group = "postgres";
      postRun = "systemctl restart postgresql";
    };
    systemd.services.postgresql.requires = ["acme-finished-postgres.target"];
    systemd.services.postgresql.serviceConfig.LoadCredential = let
      certDir = config.security.acme.certs.postgres.directory;
    in [
      "cert.pem:${certDir}/cert.pem"
      "key.pem:${certDir}/key.pem"
    ];
  };
}
