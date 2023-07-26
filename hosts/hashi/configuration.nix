{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.forceInstall = true;
  boot.loader.grub.device = "nodev";
  boot.kernelParams = [ "console=ttyS0,19200n8" ];
  boot.loader.grub.extraConfig = ''
    serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
    terminal_input serial;
    terminal_output serial
  '';

  networking.useDHCP = false;
  networking.usePredictableInterfaceNames = false;
  networking.interfaces.eth0.useDHCP = true;

  services.longview = {
    enable = true;
    apiKeyFile = "/var/lib/longview/apiKeyFile";
  };

  # foxnet.server.enable = true;
  # foxnet.server.hostname = "hashi";
  networking.hostName = "hashi";
  networking.domain = "reyuzenfold.com";

  system.stateVersion = "21.05";
}
