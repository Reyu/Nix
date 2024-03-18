{ self, pkgs, lib, ... }: {
  config = {
    nix = {
      # Enable flakes
      package = pkgs.nixVersions.stable;
      extraOptions = pkgs.lib.mkForce ''
        experimental-features = nix-command flakes ca-derivations
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
    system.configurationRevision = lib.mkIf (self ? rev) self.rev;
    system.stateVersion = "22.05";
  };
}
