{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common
    ../../common/desktop.nix
    ../../common/cachix.nix
    ../../common/users.nix
    ../../extra/hydra.nix
    ../../extra/steam.nix
  ];

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub.zfsSupport = true;
    };
    supportedFilesystems = [ "zfs" ];
    kernelModules = [ "kvm-amd" "kvm-intel" ];
  };

  environment.systemPackages = with pkgs; [ minicom ];

  reyu.flakes.enable = true;
  reyu.zfs.common = true;

  fileSystems = {
    "/home/reyu/Mail" = {
      device = "data/Mail";
      fsType = "zfs";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/FA23-833F";
      fsType = "vfat";
    };

    "/media/ISO" = {
      device = "burrow:/data/media/ISO";
      fsType = "nfs";
      options = [ "x-systemd.automount" "x-systemd.idle-timeout=600" "noauto" ];
    };

    "/media/Music" = {
      device = "burrow:/data/media/audio/music";
      fsType = "nfs";
      options = [ "x-systemd.automount" "x-systemd.idle-timeout=600" "noauto" ];
    };

    "/media/Movies" = {
      device = "burrow:/data/media/video/movies";
      fsType = "nfs";
      options = [ "x-systemd.automount" "x-systemd.idle-timeout=600" "noauto" ];
    };

    "/media/Television" = {
      device = "burrow:/data/media/video/television";
      fsType = "nfs";
      options = [ "x-systemd.automount" "x-systemd.idle-timeout=600" "noauto" ];
    };
  };

  hardware.pulseaudio.enable = true;

  networking = {
    hostName = "loki";
    hostId = "d540cb4f";
    firewall.allowPing = false;
    tcpcrypt.enable = true;
    wireless.enable = false;
  };

  services = {
    openssh.enable = true;
    sanoid = {
      enable = true;
      interval = "*-*-* *:0..59/15 UTC";
      datasets = {
        "projects" = {
          useTemplate = [ "user" ];
          recursive = true;
        };
        "data/DOCKER" = {
          useTemplate = [ "service" ];
          recursive = true;
        };
        "data/DB" = {
          useTemplate = [ "service" ];
          recursive = true;
        };
        "data/lxd" = {
          useTemplate = [ "service" ];
          recursive = true;
        };
        "data/BACKUP" = {
          recursive = true;
          autosnap = false;
        };
      };
    };
    syncoid = {
      enable = true;
      interval = "hourly";
      sshKey = "/root/.ssh/syncoid";
      commonArgs = [ "--no-sync-snap" ];
      commands = {
        "rpool/ROOT".target =
          "root@burrow.home.reyuzenfold.com:data/BACKUP/loki/ROOT";
        "rpool/HOME".target =
          "root@burrow.home.reyuzenfold.com:data/BACKUP/loki/HOME";
        "data/DB".target =
          "root@burrow.home.reyuzenfold.com:data/BACKUP/loki/DB";
      };
    };
    zfs.trim.enable = true;
  };

  virtualisation = {
    libvirtd.enable = true;
    docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };
}
