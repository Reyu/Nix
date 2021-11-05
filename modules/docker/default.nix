{ pkgs, config, ... }: {
  config = {
    environment.systemPackages = [
      pkgs.docker-client
      pkgs.docker-credential-helpers
    ];
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };
}
