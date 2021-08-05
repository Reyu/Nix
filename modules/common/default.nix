{ lib, config, pkgs, ... }:
let
  cfg = config.reyu;
in with lib; {
  imports = [
    ./crypto
    ./ldap
  ];
  options.reyu = {
    gui.enable = mkEnableOption "Enables GUI programs";
    ldap.enable = mkEnableOption "LDAP Authentication";
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
  };

  config = {
    nix = {
      trustedUsers = [ "root" "reyu" ];
      package = mkIf cfg.flakes.enable pkgs.nixFlakes;
      extraOptions = mkIf cfg.flakes.enable
        (lib.optionalString (config.nix.package == pkgs.nixFlakes)
          "experimental-features = nix-command flakes");
    };

    i18n.defaultLocale = "en_US.UTF-8";
    time.timeZone = "America/New_York";

    console.font = "Lat2-Terminus16";
    environment = {
      homeBinInPath = true;
      systemPackages = with pkgs; [ rage cachix git neovim niv tmux zsh ];
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

    security.pki.certificateFiles = [
      ../../certs/ReyuZenfold.crt
    ];
    services = {
      fcron.enable = true;
      sshd.enable = true;
    };
  };
}
