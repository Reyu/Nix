{ self, ... }:

{
  imports =
    [ ./hardware-configuration.nix
    ];

  boot.kernelParams = [ "console=ttyS0,19200n8" ];
  boot.loader.timeout = 10;
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.forceInstall = true;
  boot.loader.grub.extraConfig = ''
    serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
    terminal_input serial;
    terminal_output serial
  '';

  # Set your time zone.
  time.timeZone = "America/New_York";

  networking.useDHCP = false;
  networking.usePredictableInterfaceNames = false;
  networking.interfaces.eth0.useDHCP = true;

  foxnet = {
    server.enable = true;
    server.hostname = "matrix";
  };

  system.stateVersion = "21.05";
}

