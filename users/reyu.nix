{ config, pkgs, lib, ... }: {

  users.users.reyu = {
    isNormalUser = true;
    home = "/home/reyu";
    description = "Reyu Zenfold";
    extraGroups = [ "wheel" "audio" ];
    shell = pkgs.zsh;
  };

  nix.allowedUsers = [ "reyu" ];
}
