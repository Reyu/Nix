{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot.zfs.extraPools = [ "data" "projects" ];

  fileSystems."/" =
    { device = "rpool/ROOT/nixos";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    { device = "rpool/NIX";
      fsType = "zfs";
    };

  fileSystems."/nix/store" =
    { device = "rpool/NIX/store";
      fsType = "zfs";
    };

  fileSystems."/var" =
    { device = "rpool/ROOT/nixos/VAR";
      fsType = "zfs";
    };

  fileSystems."/usr" =
    { device = "rpool/ROOT/nixos/USR";
      fsType = "zfs";
    };

  fileSystems."/root" =
    { device = "rpool/HOME/root";
      fsType = "zfs";
    };

  fileSystems."/nix/var" =
    { device = "rpool/NIX/var";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "rpool/HOME";
      fsType = "zfs";
    };

  fileSystems."/opt" =
    { device = "rpool/ROOT/nixos/OPT";
      fsType = "zfs";
    };

  fileSystems."/home/reyu" =
    { device = "rpool/HOME/reyu";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/FA23-833F";
      fsType = "vfat";
    };

  swapDevices = [ ];

}
