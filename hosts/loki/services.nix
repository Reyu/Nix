{ pkgs, ... }: {
  services = {
    salt.master.enable = true;
    salt.minion.enable = true;
    xserver.videoDrivers = [ "amdgpu" ];
  };
}
