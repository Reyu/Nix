{ lib, pkgs, config, inputs, self-overlay, ... }:
with lib;
let cfg = config.foxnet.desktop;
in {

  imports = [ ../../users/reyu.nix ];

  options.foxnet.desktop = {

    enable = mkEnableOption "the default desktop configuration";

    stateVersion = mkOption {
      type = types.str;
      default = "20.03";
      example = "21.09";
      description = "NixOS state-Version";
    };

    hostname = mkOption {
      type = types.str;
      default = null;
      example = "deepblue";
      description = "hostname to identify the instance";
    };

    hostId = mkOption {
      type = types.str;
      default = null;
      example = "deadbeef";
      description = "hex 8 character host ID for ZFS";
    };

  };

  config = mkIf cfg.enable {

    home-manager.users.reyu = {

      # Pass inputs to home-manager modules
      _module.args.flake-inputs = inputs;

      imports = [
        ../../home-manager/home-desktop.nix
        {
          nixpkgs.overlays =
            [ self-overlay inputs.nur.overlay inputs.neovim-nightly.overlay inputs.powercord.overlay ];
        }
      ];
    };

    foxnet = {
      defaults = {
        nix.enable = true;
        sound.enable = true;
        locale.enable = true;
        ldap.enable = true;
      };
      services = {
        xserver.enable = true;
        openssh.enable = true;
      };

    };

    krb5.enable = true;

    environment.systemPackages = with pkgs; [
      binutils
      git
      killall
      lm_sensors
      neovim
      nixfmt
      ripgrep
    ];

    boot = {
      supportedFilesystems = [ "zfs" ];
      kernelParams = [ "elevator=none" ];
      loader = {
        efi.canTouchEfiVariables = true;
        grub = {
          efiSupport = true;
          device = "nodev";
          zfsSupport = true;
        };
      };
      tmpOnTmpfs = true;
    };
    console.useXkbConfig = true;

    # Define the hostname
    networking.hostName = cfg.hostname;
    networking.hostId = cfg.hostId;

    programs.dconf.enable = true;

    services.tailscale.enable = true;

    system.stateVersion = cfg.stateVersion;
  };
}
