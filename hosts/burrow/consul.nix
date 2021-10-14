{ config, pkgs, ... }: {
  config = {
    networking.firewall = {
      allowedTCPPorts = [
        8300 # Consul
        8301 # Consul Serf LAN
        8302 # Consul Serf WAN
        8501 # Consul HTTPS
      ];
      allowedUDPPorts = [
        8301 # Consul Serf LAN
        8302 # Consul Serf WAN
      ];
    };
    services = {
      sshd.enable = false;
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
            default_policy = "deny";
            down_policy = "extend-cache";
          };
        };
      };
    };
    within.secrets.consul = lib.mkIf (config.services.consul.enable or false) {
      source = ../../secrets/consul/encrypt.hcl;
      dest = "/etc/consul.d/encrypt.hcl";
      owner = "consul";
    };
  };
}
