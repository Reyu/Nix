{ config, pkgs, lib, nur, utils, ... }:
with lib;
let cfg = config.reyu.programs.firefox;
in {
  options.reyu.programs.firefox.enable = mkEnableOption "firefox browser";

  config = mkIf cfg.enable {

    programs.firefox = {
      enable = true;
      package =
        pkgs.firefox.override { cfg = { enableTridactylNative = true; }; };
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        betterttv
        consent-o-matic
        darkreader
        don-t-fuck-with-paste
        keepass-helper
        keepassxc-browser
        reddit-enhancement-suite
        refined-github
        sidebery
        terms-of-service-didnt-read
        tridactyl
        ublock-origin
      ];

      profiles = {
        personal = {
          id = 0;
          extraConfig = readFile ./user.js;
        };
        video = {
          id = 1;
          extraConfig = readFile ./user.js;
        };
      };
    };
  };
}
