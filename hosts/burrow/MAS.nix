{ config, ... }:
{
  age.secrets."romm.env" = {
    file = ./secrets/romm.env;
  };
  users = {
    extraUsers = {
      media = {
        shell = null;
        uid = 996;
        group = "media";
        isSystemUser = true;
      };
    };
    extraGroups = {
      media = {
        gid = 994;
      };
    };
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
    jellyfin = {
      enable = true;
      group = "media";
      openFirewall = true;
    };
    jellyseerr = {
      enable = true;
      openFirewall = true;
    };
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
    nginx = {
      enable = true;
      virtualHosts."jellyseerr" = {
        default = true;
        locations."^~ /jellyseerr" = {
          extraConfig = ''
            set $app 'jellyseerr';

            # Remove /jellyseer path to pass to the app
            rewrite ^/jellyseerr/?(.*)$ /$1 break;
            proxy_pass http://127.0.0.1:5055; # NO TRAILING SLASH

            # Redirect location headers
            proxy_redirect ^ /$app;
            proxy_redirect /setup /$app/setup;
            proxy_redirect /login /$app/login;

            # Sub filters to replace hardcoded paths
            proxy_set_header Accept-Encoding "";
            sub_filter_once off;
            sub_filter_types *;

            #https://stackoverflow.com/questions/19700871/how-to-inject-custom-content-via-nginx
            sub_filter '</head>' '<script language="javascript">(()=>{var t="$app";let e=history.pushState;history.pushState=function a(){arguments[2]&&!arguments[2].startsWith("/"+t)&&(arguments[2]="/"+t+arguments[2]);let s=e.apply(this,arguments);return window.dispatchEvent(new Event("pushstate")),s};let a=history.replaceState;history.replaceState=function e(){arguments[2]&&!arguments[2].startsWith("/"+t)&&(arguments[2]="/"+t+arguments[2]);let s=a.apply(this,arguments);return window.dispatchEvent(new Event("replacestate")),s},window.addEventListener("popstate",()=>{console.log("popstate")})})();</script></head>';

            sub_filter 'href="/"' 'href="/$app"';
            sub_filter 'href="/login"' 'href="/$app/login"';
            sub_filter 'href:"/"' 'href:"/$app"';
            sub_filter '/_next' '/$app\/_next';
            sub_filter '/_next' '/$app/_next';
            sub_filter '/api/v1' '/$app/api/v1';
            sub_filter '/login/plex/loading' '/$app/login/plex/loading';
            sub_filter '/images/' '/$app/images/';
            sub_filter '/android-' '/$app/android-';
            sub_filter '/apple-' '/$app/apple-';
            sub_filter '/favicon' '/$app/favicon';
            sub_filter '/logo_' '/$app/logo_';
            sub_filter '/site.webmanifest' '/$app/site.webmanifest';
          '';
        };
      };
    };
  };
  virtualisation.oci-containers = {
    backend = "podman";
    containers =
      let
        mediaUser =
          with builtins;
          concatStringsSep ":" (
            map toString [
              config.users.extraUsers.media.uid
              config.users.extraGroups.media.gid
            ]
          );
      in
      {
        romm = {
          image = "zurdi15/romm";
          ports = [ "8888:80" ];
          environment = {
            PUID = builtins.toString config.users.extraUsers.media.uid;
            PGID = builtins.toString config.users.extraGroups.media.gid;
            TZ = "America/New_York";
          };
          environmentFiles = [ config.age.secrets."romm.env".path ];
          volumes = [
            "/data/media/roms:/romm/library/roms"
            "/data/service/romm/config.yml:/romm/config.yml"
            "/data/service/romm/resources:/romm/resources"
            "/data/service/romm/database:/romm/database"
          ];
        };
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
          ports = [ "8801:8800" ];
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
