{ config, pkgs, lib, ... }: {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = false;
  boot.loader.heads.enable = true;
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/local/root@blank
  '';
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/70311bee-9913-4dcf-bf9c-f7703fb5e2ec";
      keyFile = "/secret.key"; # Created by HEADS
      fallbackToPassword = true;
    };
  };

  networking.hostName = "traveler";
  networking.hostId = "2b52ad83";
  networking.wireless.enable = true;

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "dvorak";
  };

  environment.persistence = {
    "/persist/system" = {
      directories = [
        "/etc/nixos"
      ];
      files = [
        "/etc/machine-id"
        "/etc/wpa_supplicant.conf"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];
    };
  };
}

