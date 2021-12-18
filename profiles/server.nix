{ lib, pkgs, config, inputs, self-overlay, ... }:
with lib;
let cfg = config.foxnet.server;
in {
  imports = [ ../users/root.nix ../users/reyu.nix ];

  options.foxnet.server = {
    enable = mkEnableOption "the default server configuration";

    hostname = mkOption {
      type = types.str;
      default = null;
      example = "deepblue";
      description = "hostname to identify the instance";
    };

    domain = mkOption {
      type = types.str;
      default = "reyuzenfold.com";
    };
  };

  config = mkIf cfg.enable {

    foxnet = {
      defaults = {
        environment.enable = true;
        locale.enable = true;
        nix.enable = true;
      };
    };

    networking.hostName = cfg.hostname;
    networking.domain = cfg.domain;

    environment.systemPackages = with pkgs; [
      git
      htop
      neovim
      nixfmt
      ripgrep
    ];

    services.tailscale.enable = true;
    networking.firewall.enable = true;
    networking.firewall.trustedInterfaces = [ "tailscale0" ];

    foxnet.services = { openssh.enable = true; };
  };
}
