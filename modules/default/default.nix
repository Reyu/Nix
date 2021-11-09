{ config, lib, pkgs, ... }: {
  nix.extraOptions = "experimental-features = nix-command flakes";
  nix.trustedUsers = [ "@wheel" ];

  environment = {
    homeBinInPath = true;
    systemPackages = with pkgs; [ neovim ];
    shells = [ pkgs.zsh ];
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      GOPATH = "~/.go";
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/New_York";

  services.tailscale = { enable = true; };
  environment.systemPackages = [
    pkgs.syncthing
    pkgs.tailscale
  ];

  services.fcron.enable = true;
  services.sshd.enable = true;

  security.pki.certificateFiles = [
    ../../certs/ReyuZenfold.crt
    ../../certs/CAcert.crt
  ];
}
