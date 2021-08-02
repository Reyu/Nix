{ config, lib, ... }:
let cfg = config.foxnet.zfs;
in with lib; {
  options.foxnet.zfs = {
    common = mkEnableOption "Enable default ZFS layout";
    syncoid.backupHost = mkOption {
      type = types.string;
      example = "burrow.home.reyuzenfold.com";
      description = "Syncoid destination host";
    };
  };
  config = {
    fileSystems = mkIf cfg.common {
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
      syncoid = {
        interval = "hourly";
        commonArgs = [ "--no-sync-snap" ];
        commands = {
          "rpool/ROOT".target =
            "${cfg.syncoid.backupHost}:data/BACKUP/${config.networking.hostName}/ROOT";
          "rpool/HOME".target =
            "${cfg.syncoid.backupHost}:data/BACKUP/${config.networking.hostName}/HOME";
        };
      };
    };
  };
}
