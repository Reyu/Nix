{ config, pkgs, libs, ... }:

{
  home.packages = with pkgs; [
    bitwarden-cli
    curl
    neofetch
    tree
    bc
    nix-prefetch-git
    nix-prefetch-github
    nixfmt
    feh
    ripgrep
  ];
  programs = {
    bat = {
      enable = true;
      config = {
        theme = "ansi";
        pager = "nvimpager";
      };
    };
    dircolors.enable = true;
    direnv.enable = true;
    feh.enable = true;
    fzf.enable = true;
    gh.enable = true;
    git = {
      enable = true;
      userName = "reyu";
      userEmail = "reyu@reyuzenfold.com";
      ignores = [ "_darcs" "Session.vim" "*~" ".env" ".env.local" ];
    };
    gpg.enable = true;
    htop = {
      enable = true;
      settings = {
        colorScheme = 6;
        showCpuUsage = true;
        #   meters = {
        #     left_meters  = [ "LeftCPUs2" "Memory" "Swap" ];
        #     right_meters = [ "RightCPUs2" "Tasks" "LoadAverage" "Uptime" ];
        #   };
        vimMode = true;
      };
    };
    jq.enable = true;
    lsd = {
      enable = true;
      enableAliases = true;
    };
    man.enable = true;
    starship = {
      enable = true;
      settings = {
        character = {
          success_symbol = "[𝝺](#c792ea)";
          vicmd_symbol = "[ ](bold green)";
          error_symbol = "[☓ ](bold red)";
        };
        nix_shell = {
          disabled = false;
          symbol = " ";
        };
      };
    };
  };
  xdg.configFile = {
    "direnv/lib/use_flake.sh".source = ../configs/direnv/use_flake.sh;
    "neofetch/config.conf".source = ../configs/neofetch/config.conf;
  };
}
