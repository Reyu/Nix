{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modesetting.nix
    ../../common
    ../../common/users.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;
    initrd.availableKernelModules = [ "usbhid" "usb_storage" "vc4" ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    # loader = {
    #   grub.enable = false;
    #   raspberryPi.enable = true;
    #   raspberryPi.version = 4;
    # };
    # kernelParams = [
    #   "cma=64M"
    #   "console=tty0"
    #   "8250.nr_uarts=1"
    # ];
  };

  environment.systemPackages = with pkgs; [ consul-template ];

  networking = {
    hostName = "ismene";
    tcpcrypt.enable = true;
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
  services = {
    consul.enable = true;
    vault.enable = true;
    salt.master.enable = true;
    salt.minion.enable = true;
  };
  system.stateVersion = "20.09";
}
