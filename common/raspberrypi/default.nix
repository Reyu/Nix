{ lib, pkgs, config, ... }:
{
  imports = [
    ./modesetting.nix
  ];

  config = {
    boot = {
      kernelPackages = pkgs.linuxPackages_rpi4;
      initrd.availableKernelModules = [ "usbhid" "usb_storage" "vc4" ];
      loader = {
        grub.enable = false;
        generic-extlinux-compatible.enable = true;
      };
    };

    networking = lib.mkDefault {
      useDHCP = false;
      interfaces.eth0.useDHCP = true;
      interfaces.wlan0.useDHCP = true;
    };

    nix = {
      autoOptimiseStore = true;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
      # Free up to 1GiB whenever there is less than 100MiB left.
      extraOptions = ''
        min-free = ${toString (100 * 1024 * 1024)}
        max-free = ${toString (1024 * 1024 * 1024)}
      '';
    };

    fileSystems = lib.mkForce {
        # There is no U-Boot on the Pi 4, thus the firmware partition needs to be mounted as /boot.
        "/boot" = {
            device = "/dev/disk/by-label/FIRMWARE";
            fsType = "vfat";
        };
        "/" = {
            device = "/dev/disk/by-label/NIXOS_SD";
            fsType = "ext4";
        };
    };

    nixpkgs.config = { allowUnfree = true; };
    powerManagement.cpuFreqGovernor = "ondemand";
  };
}
