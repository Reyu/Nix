{ config, pkgs, lib, nur, flake-inputs, ... }: {
  # Imports
  imports = [
    ./modules/alacritty
    ./modules/autorandr
    ./modules/chat
    ./modules/dunst
    ./modules/firefox
    ./modules/fonts
    ./modules/git
    ./modules/gpg
    ./modules/polybar
    ./modules/rofi
    ./modules/shell
    ./modules/tmux
    ./modules/tmux
    ./modules/vim
    ./modules/xdg
    ./modules/xmonad
    ./modules/xscreensaver
  ];

  reyu.programs = {
    firefox.enable = true;
    tmux.enable = true;
  };

  # Allow "unfree" licenced packages
  nixpkgs.config = { allowUnfree = true; };

  # Install these packages for my user
  home.packages = with pkgs; [
    (discord-plugged.override {
      plugins = [
        flake-inputs.discord-better-status
        flake-inputs.discord-read-all
        flake-inputs.discord-theme-toggler
        flake-inputs.discord-tweaks
        flake-inputs.discord-vc-timer
      ];
      themes = [ flake-inputs.discord-theme-slate ];
    })
    keepassxc
    obsidian
    slack
    spotify
    syncthing
    xfce.thunar
    xsel
    zoom-us
  ];

  # Include man-pages
  manual.manpages.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.neovim.package = pkgs.neovim-nightly;

  services = {
    udiskie.enable = true;
    unclutter.enable = true;
    dunst.enable = true;
    flameshot.enable = true;
  };

  systemd.user.services = {
    keepassxc = {
      Unit = { Description = "KeePassXC - Password Manager"; };
      Service = { ExecStart = "${pkgs.keepassxc}/bin/keepassxc"; };
      Install = { WantedBy = [ "default.target" ]; };
    };
    syncthingtray = {
      Unit = { Description = "SyncThing Tray"; };
      Service = { ExecStart = "${pkgs.syncthingtray}/bin/syncthingtray"; };
      Install = { WantedBy = [ "default.target" ]; };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "20.09";
}
