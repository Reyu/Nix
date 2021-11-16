{ self, ... }: {
  imports =
    [ ./hardware-configuration.nix ./consul.nix ./vault.nix ./nomad.nix ];
  config = {
    boot = {
      initrd.kernelModules = [ "igb" ];
      supportedFilesystems = [ "zfs" ];
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      initrd.network = {
        enable = true;
        ssh = {
          port = 2222;
          hostKeys = [ /root/.ssh/boot_host_ed25519_key ];
        };
      };
    };

    networking = {
      domain = "home.reyuzenfold.com";
      hostId = "34376a36";
      useDHCP = false;
      interfaces = {
        eno1.useDHCP = true;
        eno2.useDHCP = false;
        eno3.useDHCP = false;
        eno4.useDHCP = false;
      };
    };

    services.nfs.server.enable = true;
    services.nfs.server.exports = ''
      /data/media/ISO               *(rw,sec=krb5,all_squash,mp,subtree_check)
      /data/media/audio/books       *(rw,sec=krb5,all_squash,mp,subtree_check)
      /data/media/audio/music       *(rw,sec=krb5,all_squash,mp,subtree_check)
      /data/media/books             *(rw,sec=krb5,all_squash,mp,subtree_check)
      /data/media/pictures          *(rw,sec=krb5,all_squash,mp,subtree_check)
      /data/media/video/movies      *(rw,sec=krb5,all_squash,mp,subtree_check)
      /data/media/video/television  *(rw,sec=krb5,all_squash,mp,subtree_check)
      /data/media/video/youtube     *(rw,sec=krb5,all_squash,mp,subtree_check)
    '';

    networking.firewall = {
      allowedTCPPorts = [
        2049 # NFS

        # Nomad - Media
        32400 # pms
        8181 # tautulli
      ];
    };

    foxnet = {
      server.enable = true;
      server.hostname = "burrow";
    };
  };
}
