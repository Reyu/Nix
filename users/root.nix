{ config, pkgs, lib, ... }: {

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {

    users.root = {
      isNormalUser = true;
    };
  };

  # Allow to run nix
  nix.allowedUsers = [ "root" ];
}
