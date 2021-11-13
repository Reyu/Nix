{ config, pkgs, lib, ... }: {

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.reyu = {
    isNormalUser = true;
    home = "/home/reyu";
    description = "Reyu Zenfold";
    extraGroups = [ "wheel" "audio" ];
    shell = pkgs.zsh;
  };

  # Allow to run nix
  nix.allowedUsers = [ "reyu" ];
}
