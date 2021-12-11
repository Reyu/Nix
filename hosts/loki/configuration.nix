{ self, ... }: {
  imports = [ ./hardware-configuration.nix ];

  boot.loader.grub = {
    mirroredBoots = [
      {
        devices = [ "/dev/disk/by-id/nvme-eui.00253854014011fa-part1" ];
        path = "/boot";
      }
      {
        devices = [ "/dev/disk/by-id/nvme-eui.0025385301401cbf-part1" ];
        path = "/boot2";
      }
    ];
    users.reyu.hashedPassword =
      "grub.pbkdf2.sha512.10000.D76CC946199703FDC2DEEF08EFBF21FFA1B0CA5E5D238A62FD957CBB9229534332E5ABEF39AFABC8C3E1998DDFCA7D962EE3BD0E27D8B94FC1A278A5FCD60272.5B0DDB5938A09AC0D36312307A8E05D83945696308CE350A4768C53388455DD63B267289F0E83072FA4530AB4DA71CEB2729732D2461F45078B8A37AEE92B248";
  };

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
