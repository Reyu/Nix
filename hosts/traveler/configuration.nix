{ self, config, lib, ... }: {
  imports =
    [ ./hardware-configuration.nix ];

  age.secrets."wpa_supplicant.env".file = 
    builtins.toString "${self}/secrets/networks/wpa_supplicant.env";

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
    environmentFile = config.age.secrets."wpa_supplicant.env".path;
    networks = {
      "The Foxes Den".psk = "@PSK_DEN@";
      "Tokala".psk = "@PSK_TOKALA@";
    };
    userControlled.enable = true;
  };

  security.polkit.enable = true;

  services = {
    kmonad = {
      enable = true;
      keyboards.builtin = {
        name = "builtin";
        device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
        defcfg = {
          enable = true;
          compose.key = "lalt";
          fallthrough = true;
        };
        config = builtins.readFile ./kmonad-builtin.cfg;
      };
      keyboards.kinesis = {
      # Useful when docked at KVM
        name = "kinesis";
        device =
          "/dev/input/by-id/usb-Kinesis_Advantage2_Keyboard_314159265359-if01-event-kbd";
        defcfg = {
          enable = true;
          compose.key = "lalt";
          fallthrough = true;
        };
        config = builtins.readFile ../loki/kmonad-kinesis.cfg;
      };
    };
    kubo = {
      enable = true;
      settings.Addresses.API = [ "/ip4/127.0.0.1/tcp/5001" ];
    };
    tailscale.enable = true;
    zfs.autoScrub.enable = true;
  };

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
