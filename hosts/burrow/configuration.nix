{ config, lib, pkgs, ... }: {
  config = {
    reyu.flakes.enable = true;
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      supportedFilesystems = [ "zfs" ];
    };
    networking = {
      hostName = "burrow";
      hostId = "34376a36";
      useDHCP = false;
      interfaces = {
        eno1.useDHCP = true;
        eno2.useDHCP = false;
        eno3.useDHCP = false;
        eno4.useDHCP = false;
      };
    };
    users = {
      users.syncoid = {
        description = "Sanoid/Syncoid Transfer";
        isSystemUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFBXVIGn3L1+6QdDGOxnB7anLHtEf2xV/jk5adJ/Q9WJ"
        ];
      };
    };
    services = {
      consul = {
        enable = true;
        extraConfig = {
          datacenter = "home";
          domain = "consul.reyuzenfold.com";
          server = true;
          bootstrap = true;
          bind_addr = ''{{ GetInterfaceIP "eno1" }}'';
          acl = {
            enabled = true;
            default_policy = "deny";
            down_policy = "extend-cache";
          };
        };
      };
      vault = {
        enable = true;
        storageBackend = "consul";
        extraSettingsPaths = [ /etc/vault.d ];
      };
      nomad = {
        enable = true;
        enableDocker = true;
        dropPrivileges = true;
      };
      nfs.server = {
        enable = true;
        exports = ''
          /data/media/ISO              loki(rw)
          /data/media/audio/music      loki(rw)
          /data/media/video/movies     loki(rw)
          /data/media/video/television loki(rw)
        '';
      };
      syncoid.user = "syncoid";
      zfs.trim.enable = true;
    };
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
    networking.firewall = let
      consul = config.services.consul;
      vault = config.services.vault;
      consulPorts = consul.extraConfig.ports or { };
    in {
      allowedTCPPorts = [
        2049 # NFS
        8200 # Vault
        8201 # Vault Cluster
        (consulPorts.server or 8300)
        (consulPorts.serf_lan or 8301)
        (consulPorts.serf_wan or 8302)
        (consulPorts.http or 8500)
        (consulPorts.dns or 8600)
      ] ++ (if consulPorts ? https then [ consulPorts.https ] else [ ])
        ++ (if consulPorts ? grpc then [ consulPorts.grpc ] else [ ]);
      allowedTCPPortRanges = [
        {
          from = consulPorts.sidecar_min_port or 21000;
          to = consulPorts.sidecar_max or 21255;
        }
        {
          from = consulPorts.expose_min_port or 21500;
          to = consulPorts.expose_max or 21755;
        }
      ];

      allowedUDPPorts = [
        (consulPorts.serf_lan or 8301)
        (consulPorts.serf_wan or 8302)
        (consulPorts.dns or 8600)
      ];
    };
    within.secrets.consul = lib.mkIf (config.services.consul.enable or false) {
      source = ../../secrets/consul.hcl;
      dest = "/etc/consul.d/secure.hcl";
      owner = "consul";
    };
    within.secrets.vault = lib.mkIf (config.services.vault.enable or false) {
      source = ../../secrets/vault.hcl;
      dest = "/etc/vault.d/secure.hcl";
      owner = "vault";
    };
  };
}
