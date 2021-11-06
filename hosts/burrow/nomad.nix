{ config, pkgs, ... }: {
  config = {
    networking.firewall = {
      allowedTCPPorts = [
        4646 # Nomad
        80 # Traefik HTTP
        443 # Traefik HTTPS
        8081 # Traefik API
      ];
      allowedTCPPortRanges = [{
        from = 20000;
        to = 32000;
      }];
      allowedUDPPortRanges = [{
        from = 20000;
        to = 32000;
      }];
    };
    services = {
      nomad = {
        enable = true;
        extraPackages = [ pkgs.consul ];
        dropPrivileges = false;
        settings = {
          datacenter = "home";
          region = "global";
          plugin = {
            docker = {
              config = {
                allow_privileged = true;
                volumes = { enabled = true; };
              };
            };
          };
          server = {
            enabled = true;
            bootstrap_expect = 1;
            authoritative_region = "home";
          };
          client = {
            enabled = true;
            cni_path = "/data/service/nomad/cni/bin";
            cni_config_dir = "/data/service/nomad/cni/config";
          };
          vault = {
            enabled = true;
            address = "http://172.16.10.10:8200";
            create_from_role = "nomad-cluster";
          };
        };
        extraSettingsPaths = [ "/etc/nomad.d/encrypt.hcl" ];
      };
    };
    within.secrets.nomad-encrypt = {
      source = ../../secrets/nomad/encrypt.hcl;
      dest = "/etc/nomad.d/encrypt.hcl";
      owner = "root";
    };
  };
}
