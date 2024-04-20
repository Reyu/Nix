{ config, ... }: {
  config = {
    # age.secrets = {
    #   "cachix-agent.token" = {
    #     file = ./secrets/kube/cachix-agent.token;
    #     path = "/etc/cachix-agent.token";
    #   };
    # };

    networking.interfaces.enp1s0.ipv6 = {
      addresses = [
        {
          address = "2a01:4ff:f0:cbeb::1";
          prefixLength = 64;
        }
      ];
      routes = [
        {
          address = "2a01:4ff:f0:cbeb::";
          prefixLength = 64;
          type = "local";
        }
      ];
    };

    security.acme.certs = {
      "kube" = {
        domain = config.networking.fqdn;
      };
    };
  };
}
