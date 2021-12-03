{ self, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./consul.nix
    ./vault.nix
    ./nomad.nix
    ./MAS.nix
  ];
  config = {
    boot = {
      supportedFilesystems = [ "zfs" ];
      loader = {
        systemd-boot = {
          enable = true;
          editor = false;
          consoleMode = "max";
        };
        efi.canTouchEfiVariables = true;
      };
      initrd.kernelModules = [ "igb" "ixgbe" ];
      initrd.network = {
        enable = true;
        ssh = {
          enable = true;
          port = 2233;
          hostKeys = [ "/etc/ssh/initrd_ssh_host_ed25519_key" ];
          authorizedKeys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPPxK6wj41rJ00x3SSA8qw/c7WjmUW4Z1xshAQxAciS8"
          ];
        };
        postCommands = ''
          echo "zfs load-key -a; killall zfs; exit" >> /root/.profile
        '';
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

    users.groups = {
      media = { };
    };

    users.users = {
      media = {
        shell = null;
        group = "media";
        isSystemUser = true;
      };

      syncthing = {
        shell = null;
        group = "syncthing";
        extraGroups = [ "media" ];
        isSystemUser = true;
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

    services = {
      syncthing = {
        enable = true;
        user = "syncthing";
        dataDir = "/data/service/sync";
        configDir = "/data/etc/syncthing";
        guiAddress = "100.82.76.79:8384";
      };
    };

    networking.firewall = {
      allowedTCPPorts = [
        2049 # NFS

        # Nomad - Media
        32400 # pms
        8181 # tautulli
      ];
    };

    virtualisation.docker.enable = true;

    foxnet = {
      server.enable = true;
      server.hostname = "burrow";
    };

    fileSystems."/".options = [ "zfsutil" ];
    fileSystems."/nix".options = [ "zfsutil" ];
    fileSystems."/var".options = [ "zfsutil" ];
    fileSystems."/usr".options = [ "zfsutil" ];
    fileSystems."/home".options = [ "zfsutil" ];
    fileSystems."/opt".options = [ "zfsutil" ];
  };
}
