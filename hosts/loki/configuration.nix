{ self, ... }: {
  imports = [ ./hardware-configuration.nix ];

  services = {
    zfs.autoScrub.enable = true;
    sanoid = {
      interval = "*-*-* *:0..59/15 UTC";
      datasets = {
        "rpool/ROOT" = {
          recursive = true;
          yearly = 1;
        };
        "rpool/HOME" = {
          processChildrenOnly = true;
          recursive = true;
          yearly = 1;
        };
        "projects" = {
          processChildrenOnly = true;
          recursive = true;
        };
      };
    };
  };

  foxnet.desktop = {
    enable = true;
    hostname = "loki";
    hostId = "d540cb4f";
  };
  foxnet.services = { docker.enable = true; };
  foxnet.steam.enable = true;
}
