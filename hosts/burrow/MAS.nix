{ config, pkgs, ... }: {
  services = {
    plex.enable = true;
    plex.openFirewall = true;
    tautulli.enable = true;
    sonarr.enable = true;
    sonarr.openFirewall = true;
    radarr.enable = true;
    radarr.openFirewall = true;
    bazarr.enable = true;
    bazarr.openFirewall = true;
    lidarr.enable = true;
    lidarr.openFirewall = true;
  };
}
