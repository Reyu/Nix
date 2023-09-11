{ config, pkgs, ... }:
let browser = "librewolf";
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
    users.reyu.hashedPasswordFile =
      builtins.toString ../../secrets/grub-reyu.passwd;
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

  age.secrets."davfs2_secrets" = {
    file = ../../secrets/loki/davfs2_secrets;
    path = "/etc/davfs2/secrets";
  };

  console.useXkbConfig = true;
  programs.dconf.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  # programs.streamdeck-ui.enable = true;

  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.firewall.checkReversePath = "loose";
  networking.hostName = "loki";
  networking.hostId = "d540cb4f";

  users.users.reyu.extraGroups = [ config.services.davfs2.davGroup "podman" ];
  home-manager.users.reyu = {
    home.packages = with pkgs; [ deluge blender freecad mullvad-vpn calibre ];
    wayland.windowManager.sway.config = {
      startup = [
        { command = browser; }
        { command = "${browser} -P video"; }
        { command = "telegram-desktop"; }
        { command = "discord"; }
      ];
      output = {
        DP-1 = {
          background = "~/Pictures/Backgrounds/The Downbelow.jpg fill";
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
    blueman.enable = true;
    consul.extraConfig = {
      datacenter = "home";
      client_addr = ''
        {{ GetAllInterfaces | include "name" "eno[1-4]|lo" | exclude "flags" "link-local unicast" | join "address" " " }}'';
      advertise_addr = ''
        {{ GetPublicInterfaces | include "type" "IPv6" | sort "-address" | attr "address" }}'';
      retry_join = [ "172.16.0.5" ];
    };
    kmonad = {
      enable = true;
      keyboards.kinesis = {
        name = "kinesis";
        device =
          "/dev/input/by-id/usb-Kinesis_Advantage2_Keyboard_314159265359-if01-event-kbd";
        defcfg = {
          enable = true;
          compose.key = "lalt";
          fallthrough = true;
        };
        config = builtins.readFile ./kmonad-kinesis.cfg;
      };
    };
    vault-proxy = {
      enable = true;
      vault.address = "http://172.16.0.5:8200";
      listenerExtraConfig = ''
        tls_disable = true
      '';
    };
    davfs2.enable = true;
    udev.packages = [ pkgs.android-udev-rules ];
    kubo = {
      enable = true;
      settings.Addresses.API = [ "/ip4/127.0.0.1/tcp/5001" ];
    };
    mullvad-vpn = {
      enable = true;
      enableExcludeWrapper = false;
    };
    flatpak.enable = true;
    openssh.allowSFTP = true;
    input-remapper.enable = true;
    input-remapper.enableUdevRules = true;
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

  hardware = {
    bluetooth.enable = true;
    uinput.enable = true;
    opengl.extraPackages = with pkgs; [ rocm-opencl-icd rocm-opencl-runtime ];
    openrazer = {
      enable = true;
      users = [ "reyu" ];
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  virtualisation = {
    containers.storage.settings.storage = {
      driver = "zfs";
      options.zfs.fsname = "rpool/local/podman";
    };
    podman = { extraPackages = [ pkgs.zfs ]; };
  };

  systemd.tmpfiles.rules =
    [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}" ];
}
