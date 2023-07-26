{
  # Imports
  imports = [
    ../modules/shell
  ];

  programs.git = {
    enable = true;
    extraConfig.init.defaultBranch = "main";
  };

  # Include man-pages
  manual.manpages.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.enableNixpkgsReleaseCheck = true;

  home.stateVersion = "22.11";
}
