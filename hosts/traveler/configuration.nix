{ config, lib, pkgs, modulesPath, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.secrets ={
    "/etc/.keys/0723cd57a2a5a7512030df9768a1d195da4f9c8f714074af26a4798279f29283" = null;
    "/etc/.keys/58586192c4e29e0c8dfbdf6d6582ab93eb88bbdc10c3ce69863d6b9c0edee4ae" = null;
  };

  hardware = {
    system76.enableAll = true;
    pulseaudio.enable = true;
  };

  networking = {
    hostName = "traveler";
    useDHCP = false;
    interfaces.enp58s0u1.useDHCP = false;
    interfaces.wlp60s0.useDHCP = true;
    hostId = "0edf93c1";
    firewall.allowPing = false;
    supplicant.wlp60s0 = {
        userControlled.enable = true;
    };
    tcpcrypt.enable = true;
    wireless.enable = true;
  };

  services = {
    dbus = {
      enable = true;
      packages = [ pkgs.gnome3.dconf ];
    };
    unclutter = {
      enable = true;
      timeout = 3;
    };
    xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "dvorak";
      libinput.enable = true;
      windowManager.xmonad.enable = true;
    };
    fcron.enable = true;
    openssh.enable = true;
    zfs.trim.enable = true;
  };

  sound = {
    enable = true;
    mediaKeys.enable = true;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };
}
