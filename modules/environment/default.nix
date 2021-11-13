{ config, pkgs, lib, ... }:
with lib;
let cfg = config.foxnet.defaults.environment;
in {

  options.foxnet.defaults.environment = {
    enable = mkEnableOption "Environment defaults";
  };

  config = mkIf cfg.enable {

    # System-wide environment variables to be set
    environment = {
      variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    };
  };
}
