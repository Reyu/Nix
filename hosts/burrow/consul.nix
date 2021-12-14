{ config, pkgs, ... }: {
  config = {
    networking.firewall = {
      allowedTCPPorts = [
        8300 # Consul
        8301 # Consul Serf LAN
        8302 # Consul Serf WAN
        8500 # Consul HTTP
        8501 # Consul HTTPS
        8502 # Consul gRPC
      ];
      allowedUDPPorts = [
        8301 # Consul Serf LAN
        8302 # Consul Serf WAN
      ];
      allowedTCPPortRanges = [
        {
          from = 21000;
          to = 21255;
        }
        {
          from = 21500;
          to = 21755;
        }
      ];
    };
    services = {
      consul = {
        enable = true;
        interface.bind = "eno1";
        extraConfig = {
          datacenter = "home";
          domain = "consul.reyuzenfold.com";
          server = true;
          bootstrap = true;
          acl = {
            enabled = true;
            default_policy = "allow";
            down_policy = "extend-cache";
          };
          addresses = {
            http = "127.0.0.1 {{ GetInterfaceIP \"eno1\" }}";
          };
          ports.grpc = 8502;
          connect.enabled = true;
        };
      };
    };
    foxnet.secrets.consul_encrypt_key = {
      source = ../../secrets/consul/encrypt.hcl;
      dest = "/etc/consul.d/encrypt.hcl";
      owner = "consul";
    };
  };
}
