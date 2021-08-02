{ pkgs, ... }: {
  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub.zfsSupport = true;
    };
    supportedFilesystems = [ "zfs" ];
    kernelModules = [ "kvm-amd" "kvm-intel" ];
  };

  environment.systemPackages = with pkgs; [ minicom ];

  reyu.flakes.enable = true;

  fileSystems = {
    "/home/reyu/Mail" = {
      device = "data/Mail";
      fsType = "zfs";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/FA23-833F";
      fsType = "vfat";
    };

    "/media/ISO" = {
      device = "burrow:/data/media/ISO";
      fsType = "nfs";
      options = [ "x-systemd.automount" "x-systemd.idle-timeout=600" "noauto" ];
    };

    "/media/Music" = {
      device = "burrow:/data/media/audio/music";
      fsType = "nfs";
      options = [ "x-systemd.automount" "x-systemd.idle-timeout=600" "noauto" ];
    };

    "/media/Movies" = {
      device = "burrow:/data/media/video/movies";
      fsType = "nfs";
      options = [ "x-systemd.automount" "x-systemd.idle-timeout=600" "noauto" ];
    };

    "/media/Television" = {
      device = "burrow:/data/media/video/television";
      fsType = "nfs";
      options = [ "x-systemd.automount" "x-systemd.idle-timeout=600" "noauto" ];
    };
  };

  hardware.pulseaudio.enable = true;

  networking = {
    hostName = "loki";
    hostId = "d540cb4f";
    firewall.allowPing = false;
    tcpcrypt.enable = true;
    wireless.enable = false;
  };

  services = {
    openssh.enable = true;
    sanoid.enable = true;
  };

  virtualisation.libvirtd.enable = true;
}
