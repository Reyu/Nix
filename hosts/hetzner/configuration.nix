{ modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.loader.timeout = 0;
  boot.loader.grub.device = "/dev/sda";

  fileSystems."/" = { device = "/dev/sda"; };
}

