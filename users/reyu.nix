{ config, pkgs, lib, ... }: {

  users.users.reyu = {
    isNormalUser = true;
    home = "/home/reyu";
    description = "Reyu Zenfold";
    extraGroups = [ "wheel" "audio" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPPxK6wj41rJ00x3SSA8qw/c7WjmUW4Z1xshAQxAciS8 reyu@kp"
    ];
  };

  # Allow to run nix
  nix.settings.allowed-users = [ "reyu" ];
  # Trust user to allow importing closures and configuring binary caches
  nix.settings.trusted-users = [ "reyu" ];
}
