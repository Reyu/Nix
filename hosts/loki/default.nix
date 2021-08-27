{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd.availableKernelModules =
      [ "xhci_pci" "nvme" "ahci" "usbhid" "sd_mod" ];
    initrd.kernelModules = [ ];
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "zfs" ];
    loader = {
      efi.canTouchEfiVariables = true;
      grub.zfsSupport = true;
      # grub.splashImage = null;
      grub.gfxmodeEfi = "2560x1440";
      systemd-boot.enable = true;
    };
    zfs.extraPools = [ "projects" ];
  };

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
  hardware.pulseaudio.enable = true;

  networking.hostId = "d540cb4f";

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
}

