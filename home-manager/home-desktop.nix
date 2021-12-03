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
    (discord-plugged.override { plugins = [ flake-inputs.discord-tweaks ]; })
    keepassxc
    obsidian
    spotify
    syncthing
    volctl
    xfce.thunar
    xsel
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "20.09";
}
