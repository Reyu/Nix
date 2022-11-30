{ config, pkgs, inputs, ... }: {
  # Imports
  imports = [
    ./common.nix
    ../modules/alacritty
    ../modules/autorandr
    ../modules/chat
    ../modules/dunst
    ../modules/firefox
    ../modules/fonts
    ../modules/git
    ../modules/gpg
    ../modules/picom
    ../modules/polybar
    ../modules/rofi
    ../modules/xdg
    ../modules/xmonad
    ../modules/xscreensaver
  ];

  reyu.programs = {
    firefox.enable = true;
    tmux.enable = true;
  };

  # Install these packages for my user
  home.packages = with pkgs; [
    keepassxc
    ripgrep
    xsel
  ];

  programs.keychain = {
    agents = [ "ssh" "gpg" ];
    enable = true;
    enableXsessionIntegration = true;
    enableZshIntegration = true;
    keys = []; # No keys by default
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

  systemd.user.services = {
    keepassxc = {
      Unit = { Description = "KeePassXC - Password Manager"; };
      Service = { ExecStart = "${pkgs.keepassxc}/bin/keepassxc"; };
      Install = { WantedBy = [ "tray.target" ]; };
    };
  };

  xsession.initExtra = ''
    if [ -f "$HOME/Pictures/.background" ] ; then
      ${pkgs.feh}/bin/feh --no-fehbg --bg-center "$HOME/Pictures/.background"
    fi
    '';
}
