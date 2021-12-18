# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "rpool/ROOT/nixos";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    {
      device = "rpool/NIX";
      fsType = "zfs";
    };

  fileSystems."/var" =
    {
      device = "rpool/ROOT/nixos/VAR";
      fsType = "zfs";
    };

  fileSystems."/usr" =
    {
      device = "rpool/ROOT/nixos/USR";
      fsType = "zfs";
    };

  fileSystems."/home" =
    {
      device = "rpool/HOME";
      fsType = "zfs";
    };

  fileSystems."/opt" =
    {
      device = "rpool/ROOT/nixos/OPT";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/67A6-8840";
      fsType = "vfat";
    };

  fileSystems."/data" =
    {
      device = "data";
      fsType = "zfs";
    };

  fileSystems."/data/HOME" =
    {
      device = "data/HOME";
      fsType = "zfs";
    };

  fileSystems."/data/monitoring" =
    {
      device = "data/monitoring";
      fsType = "zfs";
    };

  fileSystems."/data/repos" =
    {
      device = "data/repos";
      fsType = "zfs";
    };

  fileSystems."/data/mirror" =
    {
      device = "data/mirror";
      fsType = "zfs";
    };

  fileSystems."/data/modeling" =
    {
      device = "data/modeling";
      fsType = "zfs";
    };

  fileSystems."/data/service" =
    {
      device = "data/service";
      fsType = "zfs";
    };

  fileSystems."/data/etc" =
    {
      device = "data/etc";
      fsType = "zfs";
    };

  fileSystems."/data/media" =
    {
      device = "data/media";
      fsType = "zfs";
    };

  fileSystems."/data/HOME/root" =
    {
      device = "data/HOME/root";
      fsType = "zfs";
    };

  fileSystems."/data/monitoring/influxdb" =
    {
      device = "data/monitoring/influxdb";
      fsType = "zfs";
    };

  fileSystems."/data/HOME/reyu" =
    {
      device = "data/HOME/reyu";
      fsType = "zfs";
    };

  fileSystems."/data/service/openldap" =
    {
      device = "data/service/openldap";
      fsType = "zfs";
    };

  fileSystems."/data/mirror/clfs" =
    {
      device = "data/mirror/clfs";
      fsType = "zfs";
    };

  fileSystems."/data/mirror/debian-security" =
    {
      device = "data/mirror/debian-security";
      fsType = "zfs";
    };

  fileSystems."/data/service/krb5" =
    {
      device = "data/service/krb5";
      fsType = "zfs";
    };

  fileSystems."/data/mirror/epel" =
    {
      device = "data/mirror/epel";
      fsType = "zfs";
    };

  fileSystems."/data/mirror/centos" =
    {
      device = "data/mirror/centos";
      fsType = "zfs";
    };

  fileSystems."/data/service/consul" =
    {
      device = "data/service/consul";
      fsType = "zfs";
    };

  fileSystems."/data/mirror/hackage" =
    {
      device = "data/mirror/hackage";
      fsType = "zfs";
    };

  fileSystems."/data/media/audio" =
    {
      device = "data/media/audio";
      fsType = "zfs";
    };

  fileSystems."/data/media/books" =
    {
      device = "data/media/books";
      fsType = "zfs";
    };

  fileSystems."/data/mirror/gentoo" =
    {
      device = "data/mirror/gentoo";
      fsType = "zfs";
    };

  fileSystems."/data/media/pictures" =
    {
      device = "data/media/pictures";
      fsType = "zfs";
    };

  fileSystems."/data/mirror/debian-multimedia" =
    {
      device = "data/mirror/debian-multimedia";
      fsType = "zfs";
    };

  fileSystems."/data/mirror/lfs-livecd" =
    {
      device = "data/mirror/lfs-livecd";
      fsType = "zfs";
    };

  fileSystems."/data/media/video" =
    {
      device = "data/media/video";
      fsType = "zfs";
    };

  fileSystems."/data/modeling/gcode" =
    {
      device = "data/modeling/gcode";
      fsType = "zfs";
    };

  fileSystems."/data/mirror/pfsense" =
    {
      device = "data/mirror/pfsense";
      fsType = "zfs";
    };

  fileSystems."/data/media/ISO" =
    {
      device = "data/media/ISO";
      fsType = "zfs";
    };

  fileSystems."/data/service/vault" =
    {
      device = "data/service/vault";
      fsType = "zfs";
    };

  fileSystems."/data/mirror/debian-cd" =
    {
      device = "data/mirror/debian-cd";
      fsType = "zfs";
    };

  fileSystems."/data/mirror/gentoo-portage" =
    {
      device = "data/mirror/gentoo-portage";
      fsType = "zfs";
    };

  fileSystems."/data/HOME/reyu/projects" =
    {
      device = "data/HOME/reyu/projects";
      fsType = "zfs";
    };

  fileSystems."/data/mirror/lfs" =
    {
      device = "data/mirror/lfs";
      fsType = "zfs";
    };

  fileSystems."/data/mirror/packman" =
    {
      device = "data/mirror/packman";
      fsType = "zfs";
    };

  fileSystems."/data/HOME/reyu/games" =
    {
      device = "data/HOME/reyu/games";
      fsType = "zfs";
    };

  fileSystems."/data/service/dns" =
    {
      device = "data/service/dns";
      fsType = "zfs";
    };

  fileSystems."/data/media/audio/books" =
    {
      device = "data/media/audio/books";
      fsType = "zfs";
    };

  fileSystems."/data/service/nomad" =
    {
      device = "data/service/nomad";
      fsType = "zfs";
    };

  fileSystems."/data/media/video/television" =
    {
      device = "data/media/video/television";
      fsType = "zfs";
    };

  fileSystems."/data/media/video/movies" =
    {
      device = "data/media/video/movies";
      fsType = "zfs";
    };

  fileSystems."/data/media/video/youtube" =
    {
      device = "data/media/video/youtube";
      fsType = "zfs";
    };

  fileSystems."/data/mirror/kernel" =
    {
      device = "data/mirror/kernel";
      fsType = "zfs";
    };

  fileSystems."/data/media/audio/music" =
    {
      device = "data/media/audio/music";
      fsType = "zfs";
    };

  fileSystems."/data/gluster" =
    {
      device = "data/gluster";
      fsType = "zfs";
    };

  fileSystems."/data/downloads" =
    {
      device = "data/downloads";
      fsType = "zfs";
    };

  fileSystems."/data/downloads/ct13179" =
    {
      device = "data/downloads/ct13179";
      fsType = "zfs";
    };

  fileSystems."/data/downloads/ct13179/deluge" =
    {
      device = "data/downloads/ct13179/deluge";
      fsType = "zfs";
    };

  swapDevices = [ ];

}
