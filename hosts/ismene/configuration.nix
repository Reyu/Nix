{ config, pkgs, lib, ... }:

{
  imports = [
    ../../common
  ];

  # bzip2 compression takes loads of time with emulation, skip it.
  sdImage.compressImage = false;

  boot = {
    # kernelPackages = pkgs.linuxPackages_rpi4;
    tmpOnTmpfs = true;
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
    kernelParams = [
      "8250.nr_uarts=1"
      "console=ttyAMA0,115200"
      "console=tty1"
    ];
  };

  boot.loader.raspberryPi = {
    enable = true;
    version = 4;
  };
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking = {
    hostName = "ismene";
    networkmanager = { enable = true; };
    tcpcrypt.enable = true;
  };

  environment.systemPackages = with pkgs; [ neovim ];

  users = {
    defaultUserShell = pkgs.zsh;
    mutableUsers = false;
    users.reyu = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPPxK6wj41rJ00x3SSA8qw/c7WjmUW4Z1xshAQxAciS8"
      ];
      extraGroups = [ "wheel" ];
    };
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

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  nixpkgs.config = { allowUnfree = true; };
  powerManagement.cpuFreqGovernor = "ondemand";
  system.stateVersion = "20.09";
}
