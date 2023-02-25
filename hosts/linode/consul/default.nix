{ self, ... }: {
  imports =
    [ ./hardware-configuration.nix ];

  boot = {
    kernelParams = [ "console=ttyS0,19200n8" ];
    timeout = 10;
    grub.enable = true;
    grub.version = 2;
    grub.device = "nodev";
    grub.forceInstall = true;
    grub.extraConfig = ''
      serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
      terminal_input serial;
      terminal_output serial
    '';
  };

  time.timeZone = "America/New_York";

  networking = {
    useDHCP = false;
    usePredictableInterfaceNames = false;
    interfaces.eth0.useDHCP = true;
  };
}

