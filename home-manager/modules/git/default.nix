{ config, pkgs, lib, ... }: {
  programs = {
    git = {
      enable = true;

      userName = "reyu";
      userEmail = "reyu@reyuzenfold.com";

      signing = {
        key = "0x8DA67C907DD6F454";
        signByDefault = true;
      };

      aliases = {
        last = "cat-file commit HEAD";
      };

      ignores = [ "_darcs" "Session.vim" "*~" ".env" ".env.local" ".direnv" ];
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = false;
        url."git@github.com:".insteadOf = "github:";
      };
    };
  };
}
