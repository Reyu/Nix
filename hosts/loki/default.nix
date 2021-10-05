{ config, lib, pkgs, modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./filesystems.nix
    ./services.nix
  ];

  boot = {
    initrd.availableKernelModules =
      [ "xhci_pci" "nvme" "ahci" "usbhid" "sd_mod" ];
    initrd.kernelModules = [ "amdgpu" ];
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "zfs" ];
    loader = {
      efi.canTouchEfiVariables = true;
      grub.zfsSupport = true;
      # grub.splashImage = null;
      grub.gfxmodeEfi = "2560x1440";
      systemd-boot.enable = true;
    };
    zfs.extraPools = [ "projects" ];
  };
  networking.hostId = "d540cb4f";

  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.video.hidpi.enable = lib.mkDefault true;
  hardware.pulseaudio.enable = true;
  hardware.opengl = {
    driSupport = true;
    extraPackages = with pkgs; [
      rocm-opencl-icd
      rocm-opencl-runtime
      amdvlk
    ];
  };

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "reyu" ];
}
