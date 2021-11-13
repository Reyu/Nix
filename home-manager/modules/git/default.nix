{ config, pkgs, lib, ... }: {
  programs = {
    git = {
      enable = true;

      ignores = [ "_darcs" "Session.vim" "*~" ".env" ".env.local" ];

      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = false;
      };

      signing = {
        key = "0x8DA67C907DD6F454";
        signByDefault = true;
      };

      userName = "reyu";
      userEmail = "reyu@reyuzenfold.com";
    };
  };
}
