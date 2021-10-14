{
  foxnet.zfs.defaultMounts = false;
  fileSystems = {
    "/" = {
      device = "rpool/ROOT/nixos";
      fsType = "zfs";
    };

    "/usr" = {
      device = "rpool/ROOT/nixos/usr";
      fsType = "zfs";
    };

    "/var" = {
      device = "rpool/ROOT/nixos/var";
      fsType = "zfs";
    };

    "/opt" = {
      device = "rpool/ROOT/nixos/opt";
      fsType = "zfs";
    };

    "/home" = {
      device = "rpool/HOME";
      fsType = "zfs";
    };

    "/nix" = {
      device = "rpool/LOCAL/nix";
      fsType = "zfs";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/67A6-8840";
      fsType = "vfat";
    };

    "/boot-alternate" = {
      device = "/dev/disk/by-uuid/6825-97EC";
      fsType = "vfat";
    };

    "/data" = {
      device = "data";
      fsType = "zfs"; options = [ "zfsutil" ];
    };
  };

  swapDevices = [ ];
}
