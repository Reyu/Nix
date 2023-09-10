{ config, ... }: {
  users = {
    extraUsers = {
      media = {
        shell = null;
        uid = 996;
        group = "media";
        isSystemUser = true;
      };
    };
    extraGroups = { media = { gid = 994; }; };
  };
  services = {
    bazarr = {
      enable = true;
      group = "media";
      openFirewall = true;
    };
    calibre-server = {
      enable = true;
      auth = {
        enable = true;
        userDb = "/var/lib/calibre-server/users.sqlite";
      };
      group = "media";
      libraries = [ "/data/media/books" ];
    };
    # Disabled until fixed
    # calibre-web = {
    #   enable = true;
    #   group = "media";
    #   listen.ip = "100.83.149.127";
    #   openFirewall = true;
    #   options.calibreLibrary = "/data/media/books";
    # };
    lidarr = {
      enable = true;
      group = "media";
      openFirewall = true;
    };
    plex = {
      enable = true;
      group = "media";
      openFirewall = true;
    };
    radarr = {
      enable = true;
      group = "media";
      openFirewall = true;
    };
    readarr = {
      enable = true;
      group = "media";
      openFirewall = true;
    };
    sonarr = {
      enable = true;
      group = "media";
      openFirewall = true;
    };
    tautulli = {
      enable = true;
      group = "media";
      openFirewall = true;
    };
  };
  virtualisation.oci-containers = {
    backend = "podman";
    containers = let
      mediaUser = with builtins;
        concatStringsSep ":" (map toString [
          config.users.extraUsers.media.uid
          config.users.extraGroups.media.gid
        ]);
    in {
      seedsync-ct21154-deluge = {
        image = "ipsingh06/seedsync";
        ports = [ "8800:8800" ];
        user = mediaUser;
        environment = {
          UMASK = "022";
          TZ = config.time.timeZone;
        };
        volumes = [
          "/data/media/seedsync/ct21154/deluge:/downloads"
          "/data/etc/seedsync/ct21154/deluge:/config"
          "/data/etc/seedsync/.ssh:/home/seedsync/.ssh"
        ];
      };
      seedsync-ct21154-nzbget = {
        image = "ipsingh06/seedsync";
        ports = [ "8801:8801" ];
        user = mediaUser;
        environment = {
          UMASK = "022";
          TZ = config.time.timeZone;
        };
        volumes = [
          "/data/media/seedsync/ct21154/nzbget:/downloads"
          "/data/etc/seedsync/ct21154/nzbget:/config"
          "/data/etc/seedsync/.ssh:/home/seedsync/.ssh"
        ];
      };
      calibre-web = {
        image = "lscr.io/linuxserver/calibre-web";
        ports = [ "8083:8083" ];
        environment = {
          PUID = builtins.toString config.users.extraUsers.media.uid;
          PGID = builtins.toString config.users.extraGroups.media.gid;
          TZ = config.time.timeZone;
        };
        volumes = [
          "/data/etc/calibre-web:/config"
          "/data/media/books:/books"
        ];
      };
    };
  };
}
