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
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/data/etc" = {
      device = "data/etc";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/media" = {
      device = "data/media";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/media/ISO" = {
      device = "data/media/ISO";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/media/audio" = {
      device = "data/media/audio";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/media/audio/books" = {
      device = "data/media/audio/books";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/media/audio/music" = {
      device = "data/media/audio/music";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/media/books" = {
      device = "data/media/books";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/media/pictures" = {
      device = "data/media/pictures";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/media/video" = {
      device = "data/media/video";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/media/video/movies" = {
      device = "data/media/video/movies";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/media/video/television" = {
      device = "data/media/video/television";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/media/video/youtube" = {
      device = "data/media/video/youtube";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/mirror" = {
      device = "data/mirror";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/mirror/centos" = {
      device = "data/mirror/centos";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/mirror/clfs" = {
      device = "data/mirror/clfs";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/mirror/debian-cd" = {
      device = "data/mirror/debian-cd";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/mirror/debian-multimedia" = {
      device = "data/mirror/debian-multimedia";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/mirror/debian-security" = {
      device = "data/mirror/debian-security";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/mirror/epel" = {
      device = "data/mirror/epel";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/mirror/gentoo" = {
      device = "data/mirror/gentoo";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/mirror/gentoo-portage" = {
      device = "data/mirror/gentoo-portage";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/mirror/hackage" = {
      device = "data/mirror/hackage";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/mirror/kernel" = {
      device = "data/mirror/kernel";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/mirror/lfs" = {
      device = "data/mirror/lfs";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/mirror/lfs-livecd" = {
      device = "data/mirror/lfs-livecd";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/mirror/packman" = {
      device = "data/mirror/packman";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/mirror/pfsense" = {
      device = "data/mirror/pfsense";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/modeling" = {
      device = "data/modeling";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/modeling/gcode" = {
      device = "data/modeling/gcode";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/monitoring" = {
      device = "data/monitoring";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/monitoring/influxdb" = {
      device = "data/monitoring/influxdb";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/repos" = {
      device = "data/repos";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/service" = {
      device = "data/service";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/service/consul" = {
      device = "data/service/consul";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/service/dns" = {
      device = "data/service/dns";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/service/krb5" = {
      device = "data/service/krb5";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/service/nomad" = {
      device = "data/service/nomad";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/service/openldap" = {
      device = "data/service/openldap";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    "/data/service/vault" = {
      device = "data/service/vault";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
  };

  services.nfs.server.exports = ''
    /data/media/ISO               *(rw,sec=krb5,all_squash,mp,subtree_check)
    /data/media/audio/books       *(rw,sec=krb5,all_squash,mp,subtree_check)
    /data/media/audio/music       *(rw,sec=krb5,all_squash,mp,subtree_check)
    /data/media/books             *(rw,sec=krb5,all_squash,mp,subtree_check)
    /data/media/pictures          *(rw,sec=krb5,all_squash,mp,subtree_check)
    /data/media/video/movies      *(rw,sec=krb5,all_squash,mp,subtree_check)
    /data/media/video/television  *(rw,sec=krb5,all_squash,mp,subtree_check)
    /data/media/video/youtube     *(rw,sec=krb5,all_squash,mp,subtree_check)
  '';

  swapDevices = [ ];
}
