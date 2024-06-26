{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./MAS.nix
  ];
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
      initrd.kernelModules = [
        "igb"
        "ixgbe"
      ];
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

    users = {
      mutableUsers = false;
      users.reyu.extraGroups = [ "podman" ];
      extraUsers = {
        syncthing = {
          shell = null;
          group = "syncthing";
          extraGroups = [ "media" ];
          isSystemUser = true;
        };
        ${config.services.syncoid.user} = {
          createHome = lib.mkForce true;
          description = "Syncoid ZFS snapshot transfer tool";
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJgBOWfRPHca+rsVzxY51zOJP7J5TcnOXCw1M7N418JS"
          ];
          useDefaultShell = true;
        };
      };
    };
    home-manager.users.${config.services.syncoid.user} = {
      home.packages = [
        pkgs.mbuffer
        pkgs.lzop
      ];
      home.stateVersion = "22.11";
    };

    services = {
      nfs.server.enable = true;
      syncthing = {
        enable = true;
        dataDir = "/data/service/sync";
        configDir = "/data/etc/syncthing";
        guiAddress = "0.0.0.0:8384";
      };
      syncoid = {
        enable = true;
        commonArgs = [
          "--no-sync-snap"
          "--create-bookmark"
          "--use-hold"
        ];
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

    virtualisation.podman.zfs = true;
    virtualisation.containers.storage.settings.storage.options.zfs.fsname = "data/containers/storage";
  };
}
