{ self, config, pkgs, ... }:
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
      builtins.toString "${self}/secrets/grub/reyu.passwd";
    zfsSupport = true;
  };
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [ "elevator=noop" ];
  boot.tmp.useTmpfs = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.initrd.kernelModules = [ "amdgpu" ];

  nix.settings = {
    cores = 32;
    max-jobs = 16;
  };

  age.secrets = {
    "davfs2_secrets" = {
      file = ./secrets/davfs2;
      path = "/etc/davfs2/secrets";
    };
    "syncoid" = {
      file = self + /secrets/syncoid/ssh_key;
      path = config.users.extraUsers.syncoid.home + "/.ssh/id_ed25519";
      owner = config.services.syncoid.user;
      group = config.services.syncoid.group;
    };
  };

  console.useXkbConfig = true;
  programs.dconf.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  programs.streamdeck-ui.enable = true;
  programs.xonsh.enable = true;

  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.firewall.checkReversePath = "loose";
  networking.hostName = "loki";
  networking.hostId = "d540cb4f";

  users.users.reyu.extraGroups = [ config.services.davfs2.davGroup "podman" ];
  home-manager.users.reyu = {
    home.packages = with pkgs; [
      deluge
      blender-hip
      freecad
      calibre
      simplex-chat
      tidal-hifi
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
    sanoid = {
      enable = true;
      datasets = {
        "data/home" = {
          processChildrenOnly = true;
          recursive = true;
          daily = 7;
          monthly = 6;
          yearly = 1;
        };
        "projects" = {
          processChildrenOnly = true;
          recursive = true;
          hourly = 48;
        };
      };
    };
    syncoid = {
      enable = true;
      commonArgs = [ "--no-sync-snap" "--create-bookmark" "--use-hold" ];
      commands =
        let
          user = config.services.syncoid.user;
        in
        {
          "data/home" = {
            recursive = true;
            target = "${user}@burrow.home.reyuzenfold.com:data/BACKUP/loki";
            sendOptions = "pw";
            recvOptions = "Fdesuo compression=lz4";
          };
          "projects" = {
            recursive = true;
            target = "${user}@burrow:data/backup/loki/projects";
            sendOptions = "pw";
            recvOptions = "Fdesuo compression=lz4";
          };
        };
      sshKey = config.age.secrets."syncoid".path;
    };
    tailscale.enable = true;
    udisks2.enable = true;
    xserver.wacom.enable = true;
    xserver.videoDrivers = [ "amdgpu" ];
    zfs.autoScrub.enable = true;
  };

  hardware = {
    bluetooth.enable = true;
    uinput.enable = true;
    opengl.extraPackages = with pkgs; [ rocmPackages.clr.icd ];
    openrazer = {
      enable = true;
      users = [ "reyu" ];
    };
    keyboard.qmk.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    configPackages = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  virtualisation.podman.zfs = true;

  systemd.tmpfiles.rules =
    [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}/hip" ];
}
