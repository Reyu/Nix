{ config, pkgs, lib, nur, ... }:
with lib; {
  imports = [ ./librewolf.nix ];

  config = {
    programs.librewolf = {
      enable = lib.mkForce true;
      package =
        pkgs.librewolf.override { cfg = { enableTridactylNative = true; }; };
      profiles =
        let
          commonExtensions = with pkgs.nur.repos.rycee.firefox-addons; [
            consent-o-matic
            darkreader
            don-t-fuck-with-paste
            firenvim
            keepass-helper
            keepassxc-browser
            tridactyl
            ublock-origin
          ];
        in
        {
          personal = {
            id = 0;
            isDefault = true;
          # extraConfig = readFile ./user.js;
            extensions = with pkgs.nur.repos.rycee.firefox-addons; [
              fediact
              pay-by-privacy-com
              privacy-pass
              refined-github
              sidebery
              simplelogin
            ] ++ commonExtensions;
            search = {
              default = "DDG";
              force = true;
              engines = {
                "DDG" = {
                  urls = [{
                    template = "https://duckduckgo.com";
                    params = [
                      { name = "q"; value = "{searchTerms}"; }
                      { name = "ao"; value = "-1"; } # Don't show privacy tips
                      { name = "k1"; value = "-1"; } # Disable ads
                      { name = "kae"; value = "d"; } # Use dark theme
                      { name = "kak"; value = "-1"; } # Don't ask to install extension
                      { name = "kap"; value = "-1"; } # Don't show newsletter sign-up reminders
                      { name = "kaq"; value = "-1"; } # Don't show newsletter sign-up
                      { name = "kf"; value = "fw"; } # Favicons + WOT
                      { name = "ko"; value = "1"; } # Float (stick) header to top of screen
                      { name = "kp"; value = "-2"; } # Safe Search Off
                      { name = "kz"; value = "1"; } # Enable Instant Answers
                    ];
                  }];
                  icon = "https://duckduckgo.com/favicon.ico";
                  definedAliases = [ "@d" ];
                };
                "Nix Packages" = {
                  urls = [{
                    template = "https://search.nixos.org/packages";
                    params = [
                      { name = "query"; value = "{searchTerms}"; }
                    ];
                  }];
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "@np" ];
                };
                "NixOS Wiki" = {
                  urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
                  iconUpdateURL = "https://nixos.wiki/favicon.png";
                  updateInterval = 24 * 60 * 60 * 1000; # every day
                  definedAliases = [ "@nw" ];
                };
              };
            };
          };
          video = {
            id = 1;
            extraConfig = readFile ./user.js;
            extensions = commonExtensions;
          };
        };
    };
  };
}
