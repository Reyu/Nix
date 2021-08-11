{ config, pkgs, lib, ... }:

{
  config = {
    services = {
      mpd = {
        enable = true;
        musicDirectory = "/media/Music";
      };
    };
    programs = {
      beets = {
        enable = true;
        package = (pkgs.beets.overrideAttrs (oldAttrs: {
          propagatedBuildInputs = lib.attrVals [ "mpd2" ] pkgs.python39Packages
          ++ oldAttrs.propagatedBuildInputs;
        })).override { pythonPackages = pkgs.python39Packages; };
        settings = {
          directory = config.services.mpd.musicDirectory;
          plugins = [ "mpdstats" "spotify" ];
        };
      };
      ncmpcpp = {
        enable = true;
      };
    };
  };
}
