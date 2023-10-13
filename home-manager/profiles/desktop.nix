{ config, pkgs, ... }: {
  # Imports
  imports = [
    ../modules/chat
    ../modules/dunst
    ../modules/firefox
    ../modules/fonts
    ../modules/git
    ../modules/gpg
    ../modules/kitty
    ../modules/sway
    ../modules/waybar
    ./common.nix
  ];

  reyu.programs = {
    tmux.enable = true;
  };

  # Install these packages for my user
  home.packages = with pkgs; [
    feh
    keepassxc
    p7zip
    parallel
    ripgrep
    xsel
  ];

  programs.neovim.minimal = false;

  programs.keychain = {
    agents = [ "ssh" "gpg" ];
    enable = true;
    enableXsessionIntegration = true;
    enableZshIntegration = true;
    keys = [ ]; # No keys by default
  };

  services = {
    udiskie.enable = true;
    unclutter.enable = true;
    flameshot.enable = true;
    syncthing.enable = true;
    syncthing.tray = {
      enable = true;
      # Adding the wait command here prevents a dialog if
      # the tray is not loaded yet.
      command = "syncthingtray --wait";
    };
  };

  systemd.user = {
    services = {
      keepassxc = {
        Unit = { Description = "KeePassXC - Password Manager"; };
        Service = { ExecStart = "${pkgs.keepassxc}/bin/keepassxc"; };
        Install = { WantedBy = [ "tray.target" ]; };
      };
    };
    tmpfiles.rules = [
      "x ${config.home.homeDirectory}/Downloads/Torrents/Watch - - - 7d -"
      "x ${config.home.homeDirectory}/Downloads/Torrents/Completed - - - 7d -"
      "d ${config.home.homeDirectory}/Downloads - - - 7d -"
    ];
  };
}
