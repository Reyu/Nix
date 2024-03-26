{ pkgs, ... }: {
  # Imports
  imports = [
    ../modules/accounts
    ../modules/chat
    ../modules/dunst
    ../modules/firefox
    ../modules/fonts
    ../modules/git
    ../modules/gpg
    ../modules/kitty
    ../modules/neomutt
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
  programs.khard.enable = true;
  programs.khard.settings = { };
  # programs.vdirsyncer.enable = true;

  services = {
    udiskie.enable = true;
    unclutter.enable = true;
    unclutter.timeout = 5;
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
  };



}
