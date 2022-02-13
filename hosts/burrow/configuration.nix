{ self, ... }: {
  imports = [
    ./hardware-configuration.nix
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
      hostId = "34376a36";
      useDHCP = false;
      interfaces = {
        eno1.useDHCP = true;
        eno2.useDHCP = false;
        eno3.useDHCP = false;
        eno4.useDHCP = false;
      };
    };

    foxnet.consul.firewall.open = {
      http = true;
      server = true;
    };
    services.consul = {
      interface.bind = "eno1";
      extraConfig = {
        server = true;
        bootstrap = true;
        datacenter = "home";
        addresses.http = ''
          127.0.0.1 {{ GetInterfaceIP "eno1" }}
        '';
      };
    };

    foxnet.vault.firewall.open = {
      http = true;
      server = true;
    };
    services.vault = {
      address = ''{{ GetInterfaceIP \"eno1\" }}:8200'';
      storageBackend = "consul";
      extraSettingsPaths = [ "/run/agenix/vault_storage_token.hcl" ];
      extraConfig = ''
        listener "tcp" {
          address = "127.0.0.1:8200"
          tls_disable = "true"
        }
      '';
    };

    foxnet.nomad.firewall.open.http = true;
    services.nomad = {
      settings = {
        server = {
          enabled = true;
          bootstrap_expect = 1;
        };
        client.enabled = true;
        datacenter = "burrow";
        region = "home";
      };
      extraSettingsPaths = [
        "/run/agenix/nomad_encrypt.hcl"
        "/run/agenix/nomad_consul.hcl"
        "/run/agenix/nomad_vault.hcl"
      ];
    };

    age.secrets = {
      "vault_storage_token.hcl" = {
        file = ../../secrets/vault/burrow-storage.hcl;
        owner = "vault";
      };
      "nomad_encrypt.hcl" = {
        file = ../../secrets/nomad/encrypt.hcl;
        owner = "nomad";
      };
      "nomad_consul.hcl" = {
        file = ../../secrets/nomad/burrow-consul.hcl;
        owner = "nomad";
      };
      "nomad_vault.hcl" = {
        file = ../../secrets/nomad/burrow-vault.hcl;
        owner = "nomad";
      };
    };

    users.groups = {
      media = { };
      nomad = { };
    };

    users.users = {
      nomad = {
        shell = null;
        group = "nomad";
        isSystemUser = true;
      };
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
      /data/media/ISO               *(rw,all_squash,mp,subtree_check)
      /data/media/audio/books       *(rw,all_squash,mp,subtree_check)
      /data/media/audio/music       *(rw,all_squash,mp,subtree_check)
      /data/media/books             *(rw,all_squash,mp,subtree_check)
      /data/media/pictures          *(rw,all_squash,mp,subtree_check)
      /data/media/video/movies      *(rw,all_squash,mp,subtree_check)
      /data/media/video/television  *(rw,all_squash,mp,subtree_check)
      /data/media/video/youtube     *(rw,all_squash,mp,subtree_check)
    '';

    services = {
      syncthing = {
        enable = true;
        user = "syncthing";
        dataDir = "/data/service/sync";
        configDir = "/data/etc/syncthing";
        guiAddress = "100.82.76.79:8384";
      };
      tailscale.enable = true;
    };

    networking.firewall = {
      trustedInterfaces = [ "tailscale0" ];
      allowedTCPPorts = [
        2049 # NFS

        # Nomad - Traefik
        80
        8081
        # Nomad - Media
        32400 # pms
        8181 # tautulli
      ];
    };

    virtualisation.docker.enable = true;

    networking.hostName = "burrow";
    networking.domain = "home.reyuzenfold.com";

    fileSystems."/".options = [ "zfsutil" ];
    fileSystems."/nix".options = [ "zfsutil" ];
    fileSystems."/var".options = [ "zfsutil" ];
    fileSystems."/usr".options = [ "zfsutil" ];
    fileSystems."/home".options = [ "zfsutil" ];
    fileSystems."/opt".options = [ "zfsutil" ];
  };
}
