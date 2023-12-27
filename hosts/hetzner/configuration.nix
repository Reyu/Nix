{ modulesPath, lib, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.loader.timeout = 0;
  boot.loader.grub.device = "/dev/sda";
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/local/root@blank
  '';

  fileSystems."/" =
    {
      device = "rpool/local/root";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_40659075-part15";
      fsType = "vfat";
    };

  fileSystems."/nix" =
    {
      device = "rpool/local/nix";
      fsType = "zfs";
    };

  fileSystems."/persist" =
    {
      device = "rpool/safe/persist";
      fsType = "zfs";
      neededForBoot = true;
    };

  fileSystems."/var/log" =
    {
      device = "rpool/safe/logs";
      fsType = "zfs";
    };

  swapDevices = [ ];

  hetzner-cloud.enable = true;

  environment.persistence = {
    "/persist/system" = {
      directories = [
        "/var/lib/tailscale"
      ];
      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];
    };
  };

  services = {
    tailscale.enable = true;
    zfs.autoScrub.enable = true;
  };

  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.hostId = lib.mkDefault "8425e349";
}
