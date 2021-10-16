{ config, pkgs, ... }: {
  config = {
    networking.firewall = {
      allowedTCPPorts = [
        8300 # Consul
        8301 # Consul Serf LAN
        8302 # Consul Serf WAN
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
        interface.bind = "enp73s0";
        extraConfig = {
          datacenter = "home";
          domain = "consul.reyuzenfold.com";
          retry_join = [
            "burrow.home.reyuzenfold.com"
          ];
          acl = {
            enabled = true;
            default_policy = "allow";
            down_policy = "extend-cache";
          };
        };
      };
    };
    within.secrets.consul = {
      source = ../../secrets/consul/encrypt.hcl;
      dest = "/etc/consul.d/encrypt.hcl";
      owner = "consul";
    };
  };
}
