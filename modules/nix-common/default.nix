{ config, pkgs, lib, inputs, ... }:
with lib;
let cfg = config.foxnet.defaults.nix;
in {

  options.foxnet.defaults.nix = { enable = mkEnableOption "Nix defaults"; };

  config = mkIf cfg.enable {

    # Allow unfree licenced packages
    nixpkgs.config.allowUnfree = true;

    # Enable flakes
    nix = {

      # Save space by hardlinking store files
      autoOptimiseStore = true;

      # Enable flakes
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes ca-references
      '';

      # Clean up old generations after 30 days
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };

      # Users allowed to run nix
      allowedUsers = [ "root" ];
    };
  };
}