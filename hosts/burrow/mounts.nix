{
  foxnet.zfs.defaultMounts = false;
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/de8df3f7-09e8-4955-a781-be1188d1d4c1";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/1DA2-3ADD";
      fsType = "vfat";
    };

    "/nix" = {
      device = "data/NIX";
      fsType = "zfs";
    };

    "/nix/store" = {
      device = "data/NIX/store";
      fsType = "zfs";
    };

    "/nix/var" = {
      device = "data/NIX/var";
      fsType = "zfs";
    };

    "/data" = {
      device = "data";
      fsType = "zfs";
    };

    "/root" = {
      device = "data/HOME/root";
      fsType = "zfs";
    };

    "/data/etc" = {
      device = "data/etc";
      fsType = "zfs";
    };

    "/data/service" = {
      device = "data/service";
      fsType = "zfs";
    };

    "/data/service/slapd" = {
      device = "data/service/slapd";
      fsType = "zfs";
    };

    "/data/service/dns" = {
      device = "data/service/dns";
      fsType = "zfs";
    };

    "/data/service/krb5" = {
      device = "data/service/krb5";
      fsType = "zfs";
    };

    "/data/media" = {
      device = "data/media";
      fsType = "zfs";
    };

    "/data/media/ISO" = {
      device = "data/media/ISO";
      fsType = "zfs";
    };

    "/data/media/audio" = {
      device = "data/media/audio";
      fsType = "zfs";
    };

    "/data/media/audio/books" = {
      device = "data/media/audio/books";
      fsType = "zfs";
    };

    "/data/media/audio/music" = {
      device = "data/media/audio/music";
      fsType = "zfs";
    };

    "/data/media/books" = {
      device = "data/media/books";
      fsType = "zfs";
    };

    "/data/media/pictures" = {
      device = "data/media/pictures";
      fsType = "zfs";
    };

    "/data/media/video" = {
      device = "data/media/video";
      fsType = "zfs";
    };

    "/data/media/video/movies" = {
      device = "data/media/video/movies";
      fsType = "zfs";
    };

    "/data/media/video/television" = {
      device = "data/media/video/television";
      fsType = "zfs";
    };

    "/data/media/video/youtube" = {
      device = "data/media/video/youtube";
      fsType = "zfs";
    };

    "/data/mirror" = {
      device = "data/mirror";
      fsType = "zfs";
    };

    "/data/mirror/centos" = {
      device = "data/mirror/centos";
      fsType = "zfs";
    };

    "/data/mirror/clfs" = {
      device = "data/mirror/clfs";
      fsType = "zfs";
    };

    "/data/mirror/debian-cd" = {
      device = "data/mirror/debian-cd";
      fsType = "zfs";
    };

    "/data/mirror/debian-multimedia" = {
      device = "data/mirror/debian-multimedia";
      fsType = "zfs";
    };

    "/data/mirror/debian-security" = {
      device = "data/mirror/debian-security";
      fsType = "zfs";
    };

    "/data/mirror/epel" = {
      device = "data/mirror/epel";
      fsType = "zfs";
    };

    "/data/mirror/gentoo" = {
      device = "data/mirror/gentoo";
      fsType = "zfs";
    };

    "/data/mirror/gentoo-portage" = {
      device = "data/mirror/gentoo-portage";
      fsType = "zfs";
    };

    "/data/mirror/hackage" = {
      device = "data/mirror/hackage";
      fsType = "zfs";
    };

    "/data/mirror/kernel" = {
      device = "data/mirror/kernel";
      fsType = "zfs";
    };

    "/data/mirror/lfs" = {
      device = "data/mirror/lfs";
      fsType = "zfs";
    };

    "/data/mirror/lfs-livecd" = {
      device = "data/mirror/lfs-livecd";
      fsType = "zfs";
    };

    "/data/mirror/packman" = {
      device = "data/mirror/packman";
      fsType = "zfs";
    };

    "/data/mirror/pfsense" = {
      device = "data/mirror/pfsense";
      fsType = "zfs";
    };

    "/data/modeling" = {
      device = "data/modeling";
      fsType = "zfs";
    };

    "/data/modeling/gcode" = {
      device = "data/modeling/gcode";
      fsType = "zfs";
    };

    "/data/monitoring" = {
      device = "data/monitoring";
      fsType = "zfs";
    };

    "/data/monitoring/influxdb" = {
      device = "data/monitoring/influxdb";
      fsType = "zfs";
    };

    "/data/repos" = {
      device = "data/repos";
      fsType = "zfs";
    };

    "/home" = {
      device = "data/HOME";
      fsType = "zfs";
    };

    "/home/reyu" = {
      device = "data/HOME/reyu";
      fsType = "zfs";
    };
  };
}
