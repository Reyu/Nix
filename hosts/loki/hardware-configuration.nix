{ config, lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "rpool/local/root";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/7715-86BD";
      fsType = "vfat";
    };

  fileSystems."/boot2" =
    {
      device = "/dev/disk/by-uuid/FA23-833F";
      fsType = "vfat";
    };

  fileSystems."/home" =
    {
      device = "data/home";
      fsType = "zfs";
    };

  fileSystems."/home/reyu" =
    {
      device = "data/home/reyu";
      fsType = "zfs";
    };

  fileSystems."/root" =
    {
      device = "data/home/root";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    {
      device = "rpool/local/nix";
      fsType = "zfs";
    };

  fileSystems."/persist" =
    {
      device = "rpool/safe/persist";
      fsType = "zfs";
    };

  fileSystems."/var/lib/containers/storage" =
    {
      device = "rpool/local/podman";
      fsType = "zfs";
    };

  swapDevices = [ ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

}
