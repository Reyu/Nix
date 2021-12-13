{ config, pkgs, lib, ... }: {

  users.users.root = {
    isNormalUser = true;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPPxK6wj41rJ00x3SSA8qw/c7WjmUW4Z1xshAQxAciS8 reyu@kp"
    ];
  };

  # Allow to run nix
  nix.allowedUsers = [ "root" ];
}
