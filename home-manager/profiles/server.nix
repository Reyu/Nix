{ config, pkgs, lib, nur, ... }: {
  imports = [ ../modules/git ../modules/shell ../modules/tmux ../modules/vim ];

  reyu.programs = { tmux.enable = true; };

  home.packages = with pkgs; [ htop ];

  manual.manpages.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.neovim.package = pkgs.neovim-nightly;

  programs.home-manager.enable = true;

  home.stateVersion = "20.09";
}
