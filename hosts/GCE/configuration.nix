{ config, pkgs, modulesPath, ... }:

{
  imports = [
    "${toString modulesPath}/virtualisation/google-compute-image.nix"
    ../../common
    ../../common/users.nix
  ];
  reyu.flakes.enable = true;
  users.users.reyu.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPPxK6wj41rJ00x3SSA8qw/c7WjmUW4Z1xshAQxAciS8 reyu@renard"
      ];
}
