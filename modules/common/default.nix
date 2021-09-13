{ config, lib, pkgs, ... }: {
  nix.trustedUsers = [ "@wheel" ];

  environment = {
    homeBinInPath = true;
    systemPackages = with pkgs; [ cachix neovim ];
    shells = [ pkgs.zsh ];
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/New_York";

  services.fcron.enable = true;
  services.sshd.enable = true;

  security.pki.certificateFiles = [
    ../../certs/ReyuZenfold.crt
    ../../certs/CAcert.crt
  ];
}
