{ lib, config, ... }: {
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

    networking.hostName = lib.mkForce "database";
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
        hostgssenc postgres postgres 192.168.0.102/32 gss include_realm=0
      '';
      settings = let
        certDir = config.security.acme.certs.postgres.directory;
      in {
        ssl_cert_file = "${certDir}/cert.pem";
        ssl_key_file = "${certDir}/key.pem";
      };
    };

    users.groups.acme.members = [ ];
    security.acme.certs.postgres = {
      domain = config.networking.fqdn;
      extraDomainNames = [
        "database.ash.${config.networking.domain}"
      ];
    };
  };
}
