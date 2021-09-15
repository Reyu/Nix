{ pkgs, config, ... }: {
  config = {
    environment.systemPackages = [
      pkgs.docker-client
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