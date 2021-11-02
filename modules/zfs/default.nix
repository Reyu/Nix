{ config, options, lib, ... }: {
  options.foxnet.zfs = {
    defaultMounts = lib.mkEnableOption "defaultMounts";
  };
  config = let
    cfg = config.foxnet.zfs;
  in {
    fileSystems = lib.mkIf cfg.defaultMounts {
      "/" = {
        device = "rpool/ROOT/nixos";
        fsType = "zfs";
      };

      "/usr" = {
        device = "rpool/ROOT/nixos/USR";
        fsType = "zfs";
      };

      "/var" = {
        device = "rpool/ROOT/nixos/VAR";
        fsType = "zfs";
      };

      "/nix" = {
        device = "rpool/NIX";
        fsType = "zfs";
      };

      "/nix/store" = {
        device = "rpool/NIX/store";
        fsType = "zfs";
      };

      "/nix/var" = {
        device = "rpool/NIX/var";
        fsType = "zfs";
      };

      "/opt" = {
        device = "rpool/ROOT/nixos/OPT";
        fsType = "zfs";
      };

      "/home" = {
        device = "rpool/HOME";
        fsType = "zfs";
      };

      "/home/reyu" = {
        device = "rpool/HOME/reyu";
        fsType = "zfs";
      };

      "/root" = {
        device = "rpool/HOME/root";
        fsType = "zfs";
      };

    };
    services = {
      zfs = { trim.enable = true; };
      sanoid = {
        interval = "*-*-* *:0..59/15 UTC";
        datasets = {
          "rpool/ROOT" = {
            useTemplate = [ "system" ];
            recursive = true;
          };
          "rpool/HOME" = { useTemplate = [ "system" ]; };
          "rpool/HOME/reyu" = { useTemplate = [ "user" ]; };
        };
        templates = {
          "system" = {
            hourly = 12;
            daily = 7;
            monthly = 1;
            yearly = 1;
            autoprune = true;
            autosnap = true;
          };
          "service" = {
            hourly = 24;
            daily = 14;
            monthly = 3;
            yearly = 2;
            autoprune = true;
            autosnap = true;
          };
          "user" = {
            hourly = 36;
            daily = 30;
            monthly = 3;
            yearly = 0;
            autoprune = true;
            autosnap = true;
          };
          "ignore" = {
            autoprune = false;
            autosnap = false;
          };
        };
      };
    };
  };
}