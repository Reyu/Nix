{ config, pkgs, lib, ... }: {
  users.users.root = {
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIAzblSY1FnK7aeaVK8z+cyEfDI9sIER8s4PIQhLI5QRHAAAABHNzaDo= ok-greater"
    ];
  };
  home-manager.users.root = import ../../home-manager/profiles/common.nix;
}
