{ config, pkgs, lib, nur, utils, ... }:
with lib;
let cfg = config.reyu.programs.firefox;
in {
  options.reyu.programs.firefox.enable = mkEnableOption "firefox browser";

  config = mkIf cfg.enable {

    # Browserpass
    programs.firefox = {
      enable = true;
      package = pkgs.firefox;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        keepassxc-browser
        keepass-helper
        temporary-containers
        terms-of-service-didnt-read
        tridactyl
        multi-account-containers
        decentraleyes
        darkreader
        https-everywhere
        ublock-origin
      ];

      profiles = {
        personal = {

          # Extra preferences to add to user.js.
          # extraConfig = "";

          isDefault = true;
          settings = {

            # Set the homepage
            "browser.startup.homepage" = "https://nixos.org";

            # Export bookmarks to bookmarks.html when closing firefox
            "browser.bookmarks.autoExportHTML" = "true";

            "browser.display.use_system_colors" = "true";
            "devtools.theme" = "dark";
          };
        };
	video = {
          id = 1;
	};
          work = {
          id = 2;
	};
      };
    };
  };
}
