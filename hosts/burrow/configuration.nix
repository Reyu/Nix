{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../common
    ../../common/users.nix
  ];
  reyu.flakes.enable = true;
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "zfs" ];
  };
  time.timeZone = "America/New_York";
  networking = {
    hostName = "burrow";
    hostId = "34376a36";
    useDHCP = false;
    interfaces = {
      eno1.useDHCP = true;
      eno2.useDHCP = false;
      eno3.useDHCP = false;
      eno4.useDHCP = false;
    };
  };
  i18n.defaultLocale = "en_US.UTF-8";
  users.users = {
    syncoid = {
      description = "Sanoid/Syncoid Transfer";
      isSystemUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFBXVIGn3L1+6QdDGOxnB7anLHtEf2xV/jk5adJ/Q9WJ"
      ];
    };
  };
  services = {
    nfs.server = {
      enable = true;
      exports = ''
        /data/media/ISO              loki(rw)
        /data/media/audio/music      loki(rw)
        /data/media/video/movies     loki(rw)
        /data/media/video/television loki(rw)
      '';
    };
    syncoid.user = "syncoid";
    zfs.trim.enable = true;
  };
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };
  networking.firewall.allowedTCPPorts = [ 2049 ];
  system.stateVersion = "21.05";
}
