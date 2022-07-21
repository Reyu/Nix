{ config, pkgs, ... }: {
  services = {
    plex.enable = true;
    plex.openFirewall = true;
    plex.group = "media";
    tautulli.enable = true;
    tautulli.group = "media";
    sonarr.enable = true;
    sonarr.openFirewall = true;
    sonarr.group = "media";
    radarr.enable = true;
    radarr.openFirewall = true;
    radarr.group = "media";
    bazarr.enable = true;
    bazarr.openFirewall = true;
    bazarr.group = "media";
    lidarr.enable = true;
    lidarr.openFirewall = true;
    lidarr.group = "media";
  };
}
