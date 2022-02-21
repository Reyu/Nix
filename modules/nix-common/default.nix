{ config, pkgs, ... }: {
  config = {
    # Allow unfree licenced packages
    # nixpkgs.config.allowUnfree = true;

    # Enable flakes
    nix = {
      # Enable flakes
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';

      # Clean up old generations after 30 days
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };

      # Save space by hardlinking store files
      settings.auto-optimise-store = true;

      # Users allowed to run nix
      settings.allowed-users = [ "root" ];
    };
  };
}
