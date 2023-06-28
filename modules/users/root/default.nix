{ self, config, pkgs, lib, ... }: {
  users.users.root = {
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIAzblSY1FnK7aeaVK8z+cyEfDI9sIER8s4PIQhLI5QRHAAAABHNzaDo= ok-greater"
    ];
    initialHashedPassword = "$6$7mWK41HoSi00ij5Y$yvOqS.ytwyjpVEs4DE0FphPMLiy6Q1cV6M7TQVHM71xslcAgsmzy.7rqGCVyiscRmaD5Cp1qx2R0jPYtJ.bFo.";
  };
  home-manager.users.root = import (self + /home-manager/profiles/minimal.nix);
  programs.zsh.enable = true;
}
