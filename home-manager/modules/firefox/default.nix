{ config, pkgs, lib, nur, utils, ... }:
with lib;
let cfg = config.reyu.programs.firefox;
in
{
  options.reyu.programs.firefox.enable = mkEnableOption "firefox browser";

  config = mkIf cfg.enable {

    programs.firefox = {
      enable = true;
      package =
        pkgs.firefox.override { cfg = { enableTridactylNative = true; }; };
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        betterttv
        darkreader
        decentraleyes
        https-everywhere
        keepass-helper
        keepassxc-browser
        multi-account-containers
        temporary-containers
        terms-of-service-didnt-read
        tridactyl
        ublock-origin
      ];

      profiles = {
        personal = {
          id = 0;
          isDefault = true;
          settings = {
            "browser.startup.homepage" = "https://nixos.org";
            "browser.bookmarks.autoExportHTML" = "true";
            "devtools.theme" = "dark";
          };
          extraConfig = readFile ./user.js;
        };
        video = { id = 1; };
        work = { id = 2; };
      };
    };
  };
}
