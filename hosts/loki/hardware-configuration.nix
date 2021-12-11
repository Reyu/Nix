{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "nvme" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot.zfs.extraPools = [ "data" "projects" ];

  fileSystems."/boot" = {
    device = "/dev/disk/by-id/nvme-eui.00253854014011fa-part1";
    fsType = "vfat";
  };
  fileSystems."/boot2" = {
    device = "/dev/disk/by-id/nvme-eui.0025385301401cbf-part1";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "rpool/ROOT/nixos";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "rpool/NIX";
    fsType = "zfs";
  };

  fileSystems."/nix/store" = {
    device = "rpool/NIX/store";
    fsType = "zfs";
  };

  fileSystems."/nix/var" = {
    device = "rpool/NIX/var";
    fsType = "zfs";
  };

  fileSystems."/usr" = {
    device = "rpool/ROOT/nixos/USR";
    fsType = "zfs";
  };

  fileSystems."/var" = {
    device = "rpool/ROOT/nixos/VAR";
    fsType = "zfs";
  };

  fileSystems."/opt" = {
    device = "rpool/ROOT/nixos/OPT";
    fsType = "zfs";
  };

  fileSystems."/root" = {
    device = "rpool/HOME/root";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "rpool/HOME";
    fsType = "zfs";
  };

  fileSystems."/home/reyu" = {
    device = "rpool/HOME/reyu";
    fsType = "zfs";
  };

  swapDevices = [ ];

}
