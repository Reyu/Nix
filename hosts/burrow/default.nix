{ config, lib, pkgs, ... }: {
  imports = [
    ./mounts.nix
    ./consul.nix
    ./vault.nix
    ./nomad.nix
  ];
  config = {
    boot = {
      initrd.availableKernelModules =
        [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "sd_mod" ];
      initrd.kernelModules = [ "igb" ];
      kernelModules = [ "kvm-intel" ];
      supportedFilesystems = [ "zfs" ];
      extraModulePackages = [ ];
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        grub.mirroredBoots = [
          { path = "/boot"; }
          { path = "/boot-alternate"; }
        ];
      };
      initrd.network = {
        enable = true;
        ssh = {
          port = 2222;
          hostKeys = [ /root/.ssh/boot_host_ed25519_key ];
        };
      };
    };

    networking = {
      domain = "home.reyuzenfold.com";
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
      nfs.server.enable = true;
      gitea = {
        enable = true;
        domain = builtins.concatStringsSep "."
          (with config.networking; [ hostName domain ]);
        rootUrl = "http://" + config.services.gitea.domain;
        httpPort = 3030;
      };
      hydra.package = pkgs.master.hydra-unstable;
      hydra.extraConfig = ''
        Include /etc/hydra/gitea_authorization.conf
      '';
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
        3000 # Hydra
        3030 # Gitea
        2049 # NFS
      ];
    };
  };
}
