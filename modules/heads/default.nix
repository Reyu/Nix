{ config, lib, pkgs, ... }:

with lib;

let
  blCfg = config.boot.loader;
  cfg = blCfg.heads;

  # The builder used to write during system activation
  builder = import ./heads-menu-builder.nix { inherit pkgs; };
in {
  options = {
    boot.loader.heads = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to generate HEADS compatable configuration file
          under `/boot/kexec_menu.txt`.

          See [HEADS's documentation](https://osresearch.net/BootOptions/)
          for more information.
        '';
      };

      configurationLimit = mkOption {
        default = 20;
        example = 10;
        type = types.int;
        description = lib.mdDoc ''
          Maximum number of configurations in the boot menu.
        '';
      };

    };
  };

  config = let
    builderArgs = "-g ${toString cfg.configurationLimit}";
  in
    mkIf cfg.enable {
      system.build.installBootLoader = "${builder} ${builderArgs} -c";
      system.boot.loader.id = "heads";
    };
}
