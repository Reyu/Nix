{ config, pkgs, modulesPath, ... }: {
  users.users.root = {
    shell = pkgs.zsh;
  };
  users.users.reyu = {
    isNormalUser = true;
    description = "Reyu Zenfold";
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
    uid = 1000;
    subGidRanges = [
      {
        count = 1;
        startGid = 100;
      }
      {
        count = 999;
        startGid = 1001;
      }
    ];
    subUidRanges = [
      {
        count = 1;
        startUid = 1000;
      }
      {
        count = 65534;
        startUid = 100001;
      }
    ];
  };
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.root = { pkgs, ... }: {
    imports = [
      ../neovim
      ../shell
      ../tmux
      ../zsh
    ];
  };
  home-manager.users.reyu = { pkgs, ... }: {
    imports = [
      ../chat
      ../firefox
      ../home
      ../music
      ../neovim
      ../shell
      ../tmux
      ../vscode
      ../xsession
      ../zsh
    ];
  };
}