{ pkgs, ... }: {
  imports = [ ./consul.nix ];
  config = {
    services = {
      salt.master.enable = true;
      salt.minion.enable = true;
      xserver.videoDrivers = [ "amdgpu" ];
    };
  };
}
