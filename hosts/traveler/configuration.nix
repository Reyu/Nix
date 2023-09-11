{ self, config, lib, ... }: {
  imports =
    [ ./hardware-configuration.nix ];

  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.heads.enable = false;
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/local/root@blank
  '';
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/70311bee-9913-4dcf-bf9c-f7703fb5e2ec";
      keyFile = "/secret.key"; # Created by HEADS
      fallbackToPassword = true;
    };
  };

  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.hostName = "traveler";
  networking.hostId = "2b52ad83";
  networking.wireless = {
    enable = true;
    userControlled.enable = true;
  };

  security.polkit.enable = true;

  services = {
    tailscale.enable = true;
    zfs.autoScrub.enable = true;
  };

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";

  services.kmonad = {
    enable = true;
    keyboards.kinesis = {
      name = "kinesis";
      device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
      defcfg = {
        enable = true;
        compose.key = "lalt";
        fallthrough = true;
      };
      config = builtins.readFile ./kmonad-builtin.cfg;
    };
  };

  environment.persistence = {
    "/persist/system" = {
      directories = [
        "/etc/nixos"
      ];
      files = [
        "/etc/machine-id"
        "/etc/wpa_supplicant.conf"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];
    };
  };

  virtualisation.podman.zfs = true;

  specialisation.graphical.configuration = {
    imports = with self.nixosModules; [ xserver ];
    system.nixos.tags = [ "graphical" ];
    home-manager.users.reyu = {
      imports = [ ../../home-manager/profiles/desktop.nix ];
    };
    virtualisation.libvirtd = {
      enable = true;
      onShutdown = "suspend";
      onBoot = "ignore";

      qemu = {
        ovmf.enable = true;
        swtpm.enable = true;
        runAsRoot = false;
      };
    };
  };
}
