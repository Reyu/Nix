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
    htop
    keepassxc
    libsecret
    (discord-plugged.override { plugins = [ flake-inputs.discord-tweaks ]; })
    syncthing
    obsidian
  ];

  # Include man-pages
  manual.manpages.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.neovim.package = pkgs.neovim-nightly;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "20.09";
}
