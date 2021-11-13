{ config, pkgs, lib, ... }:
with lib;
let cfg = config.foxnet.defaults.locale;
in {

  options.foxnet.defaults.locale = {
    enable = mkEnableOption "Locale defaults";
    timeZone = mkOption {
      type = types.str;
      default = "America/New_York";
      example = "America/New_York";
      description = "timezone of host";
    };
  };

  config = mkIf cfg.enable {

    # Set localization and tty options
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
    };

    # Set the timezone
    time.timeZone = cfg.timeZone;
  };
}
