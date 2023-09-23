{ pkgs, config, lib, ... }:
with lib;
{
  options.virtualisation.podman.zfs = mkEnableOption "podman zfs support";
  config = let
    zfsEnabled = config.virtualisation.podman.zfs;
  in {
    virtualisation = {
      docker.enable = lib.mkForce false;
      podman = {
          defaultNetwork.settings.dns_enabled = true;
          dockerCompat = true;
          dockerSocket.enable = true;
          enable = true;
          extraPackages = mkIf zfsEnabled [ pkgs.zfs ];
      };
      containers.storage.settings.storage.driver = mkIf zfsEnabled "zfs";
      containers.storage.settings.storage.runroot = mkIf zfsEnabled (mkDefault "/run/containers/storage");
      containers.storage.settings.storage.graphroot = mkIf zfsEnabled (mkDefault "/var/lib/containers/storage");
      containers.storage.settings.storage.options.zfs.fsname = mkIf zfsEnabled (mkDefault "rpool/local/containers");
    };
  };
}
