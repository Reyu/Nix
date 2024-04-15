{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
{
  options.virtualisation.podman.zfs = mkEnableOption "podman zfs support";
  config =
    let
      zfsEnabled = config.virtualisation.podman.zfs;
    in
    {
      virtualisation = {
        docker.enable = lib.mkForce false;
        podman = {
          defaultNetwork.settings.dns_enabled = true;
          dockerCompat = true;
          dockerSocket.enable = true;
          enable = true;
          extraPackages = mkIf zfsEnabled [ pkgs.zfs ];
        };
        containers.storage.settings.storage = mkIf zfsEnabled {
          driver = "zfs";
          runroot = mkDefault "/run/containers/storage";
          graphroot = mkDefault "/var/lib/containers/storage";
          options.zfs.fsname = mkDefault "rpool/local/containers";
        };
      };
    };
}
