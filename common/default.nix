{ lib, config, pkgs, ... }:

with lib; {
  options.reyu = {
    gui.enable = mkEnableOption "Enables GUI programs";

    flakes.enable = mkEnableOption "Enable Flakes";

    git = {
      name = mkOption rec {
        type = types.str;
        default = "Reyu Zenfold";
        example = default;
        description = "Name to use with git commits";
      };
      email = mkOption rec {
        type = types.str;
        default = "reyu@reyuzenfold.com";
        example = default;
        description = "Email to use with git commits";
      };
    };

    zfs.common = mkEnableOption "Enable default ZFS layout";
  };

  config = {
    nix = {
      trustedUsers = [ "root" "reyu" ];
      package = mkIf config.reyu.flakes.enable pkgs.nixFlakes;
      extraOptions = mkIf config.reyu.flakes.enable
        (lib.optionalString (config.nix.package == pkgs.nixFlakes)
          "experimental-features = nix-command flakes");
    };

    i18n.defaultLocale = "en_US.UTF-8";
    console.font = "Lat2-Terminus16";
    environment = {
      homeBinInPath = true;
      systemPackages = with pkgs; [ cachix git neovim niv tmux zsh ];
      variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    };

    fonts.fonts = with pkgs; [ nerdfonts powerline-fonts terminus-nerdfont ];

    programs = {
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
      tmux = {
        enable = true;
        aggressiveResize = true;
        clock24 = true;
        keyMode = "vi";
      };
      zsh = {
        enable = true;
        enableBashCompletion = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
      };
    };

    fileSystems = mkIf config.reyu.zfs.common {
      "/" = {
        device = "rpool/ROOT/nixos";
        fsType = "zfs";
      };

      "/usr" = {
        device = "rpool/ROOT/nixos/USR";
        fsType = "zfs";
      };

      "/var" = {
        device = "rpool/ROOT/nixos/VAR";
        fsType = "zfs";
      };

      "/nix" = {
        device = "rpool/NIX";
        fsType = "zfs";
      };

      "/nix/store" = {
        device = "rpool/NIX/store";
        fsType = "zfs";
      };

      "/nix/var" = {
        device = "rpool/NIX/var";
        fsType = "zfs";
      };

      "/opt" = {
        device = "rpool/ROOT/nixos/OPT";
        fsType = "zfs";
      };

      "/home" = {
        device = "rpool/HOME";
        fsType = "zfs";
      };

      "/home/reyu" = {
        device = "rpool/HOME/reyu";
        fsType = "zfs";
      };

      "/root" = {
        device = "rpool/HOME/root";
        fsType = "zfs";
      };

    };

    services = {
      fcron.enable = true;
      sshd.enable = true;
      sanoid = mkIf config.reyu.zfs.common {
        enable = true;
        interval = "*-*-* *:0..59/15 UTC";
        datasets = {
          "rpool/ROOT" = {
            useTemplate = [ "system" ];
            recursive = true;
          };
          "rpool/HOME" = { useTemplate = [ "system" ]; };
          "rpool/HOME/reyu" = { useTemplate = [ "user" ]; };
        };
        templates = {
          "system" = {
            hourly = 12;
            daily = 7;
            monthly = 1;
            yearly = 1;
            autoprune = true;
            autosnap = true;
          };
          "service" = {
            hourly = 24;
            daily = 14;
            monthly = 3;
            yearly = 2;
            autoprune = true;
            autosnap = true;
          };
          "user" = {
            hourly = 36;
            daily = 30;
            monthly = 3;
            yearly = 0;
            autoprune = true;
            autosnap = true;
          };
          "ignore" = {
            autoprune = false;
            autosnap = false;
          };
        };
      };
    };
  };
}
