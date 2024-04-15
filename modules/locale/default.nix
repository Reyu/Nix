{ lib, ... }:
with lib;
{
  config = {
    # Set localization and tty options
    i18n.defaultLocale = mkDefault "en_US.UTF-8";
    console = {
      font = mkForce "Lat2-Terminus16";
    };

    # Set the timezone
    time.timeZone = mkDefault "America/New_York";
  };
}
