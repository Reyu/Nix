{ lib, pkgs, config, inputs, self-overlay, ... }: {
  imports = [ ../users/root.nix ../users/reyu.nix ];
  config = {
    # TODO: Remove this in favor of deploy-rs profiles
    # home-manager.users.reyu = {
    #   imports = [
    #     ../home-manager/home-desktop.nix
    #     {
    #       nixpkgs.overlays = [
    #         self-overlay
    #         inputs.nur.overlay
    #         inputs.neovim-nightly.overlay
    #         inputs.powercord.overlay
    #       ];
    #     }
    #   ];
    # };
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
      loader = {
        efi.canTouchEfiVariables = true;
        grub = {
          efiSupport = true;
          device = "nodev";
        };
      };
      tmpOnTmpfs = true;
    };

    console.useXkbConfig = true;

    programs.dconf.enable = true;

    services.tailscale.enable = true;
  };
}
