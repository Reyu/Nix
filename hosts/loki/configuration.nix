{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    efiSupport = true;
    device = "nodev";
    mirroredBoots = [
      {
        devices = [ "/dev/disk/by-id/nvme-eui.00253854014011fa-part1" ];
        path = "/boot";
      }
      {
        devices = [ "/dev/disk/by-id/nvme-eui.0025385301401cbf-part1" ];
        path = "/boot2";
      }
    ];
    users.reyu.hashedPasswordFile = builtins.toString ../../secrets/grub-reyu.passwd;
    zfsSupport = true;
  };
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [ "elevator=noop" ];
  boot.tmpOnTmpfs = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  nix.settings = {
    cores = 16;
    max-jobs= 8;
  };

  console.useXkbConfig = true;
  programs.dconf.enable = true;

  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.firewall.checkReversePath = "loose";

  foxnet.consul.firewall.open = {
    http = true;
  };
  services.consul = {
    interface.bind = "enp73s0";
    extraConfig = {
      datacenter = "home";
      retry_join = ["burrow.home.reyuzenfold.com"];
    };
  };

  services = {
    tailscale.enable = true;
    sanoid = {
      interval = "*-*-* *:0..59/15 UTC";
      datasets = {
        "rpool/ROOT" = {
          recursive = true;
          yearly = 1;
        };
        "rpool/HOME" = {
          processChildrenOnly = true;
          recursive = true;
          yearly = 1;
        };
        "projects" = {
          processChildrenOnly = true;
          recursive = true;
        };
      };
    };
    xserver.wacom.enable = true;
    zfs.autoScrub.enable = true;
  };

  networking.hostName = "loki";
  networking.hostId = "d540cb4f";

  virtualisation.podman.enable = true;
  virtualisation.docker.storageDriver = "zfs";
}
