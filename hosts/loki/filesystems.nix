{ config, lib, pkgs, modulesPath, ... }: {
  foxnet.zfs.defaultMounts = true;
  fileSystems = {
    "/home/reyu/Mail" = {
      device = "data/Mail";
      fsType = "zfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/FA23-833F";
      fsType = "vfat";
    };
    # "/media/ISO" = {
    #   device = "burrow:/data/media/ISO";
    #   fsType = "nfs";
    #   options = [ "x-systemd.automount" "x-systemd.idle-timeout=600" "noauto" ];
    # };
    # "/media/Music" = {
    #   device = "burrow:/data/media/audio/music";
    #   fsType = "nfs";
    #   options = [ "x-systemd.automount" "x-systemd.idle-timeout=600" "noauto" ];
    # };
    # "/media/Movies" = {
    #   device = "burrow:/data/media/video/movies";
    #   fsType = "nfs";
    #   options = [ "x-systemd.automount" "x-systemd.idle-timeout=600" "noauto" ];
    # };
    # "/media/Television" = {
    #   device = "burrow:/data/media/video/television";
    #   fsType = "nfs";
    #   options = [ "x-systemd.automount" "x-systemd.idle-timeout=600" "noauto" ];
    # };
  };
}
