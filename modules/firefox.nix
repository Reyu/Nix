{ config, pkgs, libs, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      cfg = {
        enableTridactylNative = true;
      };
    };
    profiles = {
      personal = {
        id = 0;
      };
      video = {
        id = 1;
      };
      work = {
        id = 2;
      };
    };
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      bitwarden
      darkreader
      decentraleyes
      disconnect
      duckduckgo-privacy-essentials
      ghostery
      https-everywhere
      multi-account-containers
      privacy-badger
      reddit-enhancement-suite
      temporary-containers
      terms-of-service-didnt-read
      tridactyl
      ublock-origin
    ];
  };
}
