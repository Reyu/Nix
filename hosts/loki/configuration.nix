{ config, pkgs, ... }: let
  browser = "librewolf";
in {
  imports = [ ./hardware-configuration.nix ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    efiSupport = true;
    device = "nodev";
    mirroredBoots = [
      {
        devices = [ "/dev/disk/by-id/nvme-eui.00253854014011fa-part1" ];
        path = "/boot";
      }
      {
        devices = [ "/dev/disk/by-id/nvme-eui.0025385301401cbf-part1" ];
        path = "/boot2";
      }
    ];
    users.reyu.hashedPasswordFile = builtins.toString ../../secrets/grub-reyu.passwd;
    zfsSupport = true;
  };
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [ "elevator=noop" ];
  boot.tmp.useTmpfs = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.zfs.extraPools = [ "projects" ];

  nix.settings = {
    cores = 32;
    max-jobs = 16;
  };

  console.useXkbConfig = true;
  programs.dconf.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  programs.streamdeck-ui.enable = true;

  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.firewall.checkReversePath = "loose";

  services.blueman.enable = true;

  users.users.reyu.extraGroups = [ config.services.davfs2.davGroup ];
  home-manager.users.reyu = {
      home.packages = with pkgs; [
        deluge
        blender
        freecad
        mullvad-vpn
        calibre
      ];
      wayland.windowManager.sway.config = {
        startup = [
          { command = browser; }
          { command = "${browser} -P video"; }
          { command = "telegram-desktop"; }
          { command = "discord"; }
        ];
        output = {
          DP-1 = {
            background = "~/Pictures/Backgrounds/The\ Downbelow.jpg fill";
            position = "3840 720 res 3440x1440";
          };
          DP-2 = {
            background = "~/Pictures/Backgrounds/Locker.png fill";
            position = "7280 720 res 2560x1440";
          };
          DP-3 = {
            background = "~/Pictures/Backgrounds/Locker_Fliped.png fill";
            position = "0 0 res 3840x2160";
          };
        };
      };
  };

  services = {
    avahi.enable = true;
    consul.interface.bind = "enp70s0";
    consul.extraConfig = {
      ui = true;
      datacenter = "home";
      client_addr = "{{ GetAllInterfaces | include \"name\" \"eno[1-4]|lo\" | exclude \"flags\" \"link-local unicast\" | join \"address\" \" \" }}";
      advertise_addr = "{{ GetPublicInterfaces | include \"type\" \"IPv6\" | sort \"-address\" | attr \"address\" }}";
      retry_join = [ "172.16.0.5" ];
    };
    davfs2.enable = true;
    vault = {
      storageBackend = "consul";
      extraConfig = ''
        ui = true
      '';
      extraSettingsPaths = [
        config.age.secrets."vault_storage.hcl".path
      ];
    };
    udev.packages = [
      pkgs.android-udev-rules
    ];
    mullvad-vpn = {
        enable = true;
        enableExcludeWrapper = false;
    };
    tailscale.enable = true;
    sanoid = {
      interval = "*-*-* *:0..59/15 UTC";
      datasets = {
        "rpool/home" = {
          processChildrenOnly = true;
          recursive = true;
          yearly = 1;
        };
        "projects" = {
          processChildrenOnly = true;
          recursive = true;
        };
      };
    };
    xserver.wacom.enable = true;
    xserver.videoDrivers = [ "amdgpu" ];
    zfs.autoScrub.enable = true;
  };

  hardware.bluetooth.enable = true;
  hardware.uinput.enable = true;
  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
  ];
  hardware.openrazer = {
    enable = true;
    users = [ "reyu" ];
  };

  services.flatpak.enable = true;
  services.openssh.allowSFTP = true;
  services.input-remapper.enable = true;
  services.input-remapper.enableUdevRules = true;

  services.kmonad = {
    enable = true;
    keyboards.kinesis = {
      name = "kinesis";
      device = "/dev/input/by-id/usb-Kinesis_Advantage2_Keyboard_314159265359-if01-event-kbd";
      defcfg = {
        enable = true;
        compose.key = "lalt";
        fallthrough = true;
      };
      config = builtins.readFile ./kmonad-kinesis.cfg;
    };
  };

  networking.hostName = "loki";
  networking.hostId = "d540cb4f";

  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  virtualisation.podman.enable = true;
  virtualisation.containers.storage.settings.storage.driver = "zfs";

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}"
  ];
}
