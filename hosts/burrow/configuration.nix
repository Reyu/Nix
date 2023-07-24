{ config, ... }: {
  imports = [ ./hardware-configuration.nix ./MAS.nix ];
  config = {
    boot = {
      supportedFilesystems = [ "zfs" ];
      loader = {
        systemd-boot = {
          enable = true;
          editor = false;
          consoleMode = "max";
        };
        efi.canTouchEfiVariables = true;
      };
      initrd.kernelModules = [ "igb" "ixgbe" ];
      initrd.network = {
        enable = true;
        ssh = {
          enable = true;
          port = 2233;
          hostKeys = [ "/etc/ssh/initrd_ssh_host_ed25519_key" ];
          authorizedKeys = config.users.users.root.openssh.authorizedKeys.keys;
        };
        postCommands = ''
          echo "zfs load-key -a; killall zfs; exit" >> /root/.profile
        '';
      };
      zfs.extraPools = [ "data" ];
    };

    foxnet.consul.firewall.open = {
      dns = true;
      serf_wan = true;
      server = true;
    };

    age.secrets."vault_storage.hcl" = {
      file = ../../secrets/vault/burrow-storage.hcl;
      owner = "vault";
    };

    users.groups.media = { };
    users.users = {
      media = {
        shell = null;
        group = "media";
        isSystemUser = true;
      };
      syncthing = {
        shell = null;
        group = "syncthing";
        extraGroups = [ "media" ];
        isSystemUser = true;
      };
    };

    services = {
      consul.extraConfig = {
        server = true;
        bootstrap = true;
        ui = true;
        datacenter = "home";
        client_addr = "{{ GetAllInterfaces | include \"name\" \"eno[1-4]|lo\" | exclude \"flags\" \"link-local unicast\" | join \"address\" \" \" }}";
        advertise_addr = "{{ GetPublicInterfaces | include \"type\" \"IPv6\" | sort \"-address\" | attr \"address\" }}";
      };
      vault = {
        storageBackend = "consul";
        extraConfig = ''
          ui = true
        '';
        extraSettingsPaths = [
          config.age.secrets."vault_storage.hcl".path
        ];
      };
      nfs.server.enable = true;
      syncthing = {
        enable = true;
        user = "syncthing";
        dataDir = "/data/service/sync";
        configDir = "/data/etc/syncthing";
        guiAddress = "100.82.76.79:8384";
      };
      tailscale.enable = true;
    };

    networking = {
      hostName = "burrow";
      hostId = "34376a36";
      domain = "home.reyuzenfold.com";

      useDHCP = false;
      interfaces = {
        eno1.useDHCP = true;
        eno2.useDHCP = false;
        eno3.useDHCP = false;
        eno4.useDHCP = false;
      };

      firewall = {
        checkReversePath = "loose";
        trustedInterfaces = [ "tailscale0" ];
        allowedTCPPorts = [
          2049 # NFS
        ];
      };
    };

    virtualisation.docker.enable = true;
    virtualisation.docker.storageDriver = "zfs";
  };
}
