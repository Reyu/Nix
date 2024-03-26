{
  # Imports
  imports = [
    ../modules/shell
    ../modules/tmux
    ../modules/vim
  ];
  reyu.programs = { tmux.enable = true; };

  programs.git = {
    enable = true;
    extraConfig.init.defaultBranch = "main";
  };

  services = {
    ssh-agent.enable = true;
  };

  # Include man-pages
  manual.manpages.enable = true;

  # Some SSH Config
  programs.ssh = {
    addKeysToAgent = "confirm";
    controlMaster = "auto";
    controlPersist = "3s";
    enable = true;
    hashKnownHosts = true;
    extraOptionOverrides = {
      "checkHostIP" = "yes";
      "StrictHostKeyChecking" = "yes";
      "UpdateHostKeys" = "yes";
      "VisualHostKey" = "yes";
    };
    includes = [
      "local_config"
    ];
    matchBlocks = {
      "deck" = {
        user = "deck";
      };
      "lish" = {
        hostname = "lish-us-southeast.linode.com";
        extraOptions = {
          "RequestTTY" = "yes";
        };
      };
      "lish-*" = {
        hostname = "%h.linode.com";
        extraOptions = {
          "RequestTTY" = "yes";
        };
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.enableNixpkgsReleaseCheck = true;

  home.stateVersion = "22.11";
}
