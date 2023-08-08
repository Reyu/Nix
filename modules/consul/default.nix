{ config, lib, ... }:
with lib;
let cfg = config.foxnet.consul;
in {
  options.foxnet.consul =
    let
      mkBool = default: description:
        mkOption {
          inherit default description;
          type = types.bool;
        };
    in
    {
      firewall.open = {
        # See list: https://www.consul.io/docs/install/ports
        dns = mkBool false ''
          DNS Interface: Used to resolve DNS queries.
        '';
        http = mkBool false ''
          HTTP API: This is used by clients to talk to the HTTP API.
        '';
        https = mkBool false ''
          HTTPS API: Is off by default, but port 8501 is a convention used by various tools as the default.
        '';
        grpc = mkBool false ''
          gRPC API: Currently gRPC is only used to expose the xDS API to Envoy proxies.
        '';
        serf_lan = mkBool true ''
          Serf LAN: This is used to handle gossip in the LAN. Required by all agents.
        '';
        serf_wan = mkBool false ''
          Serf WAN: This is used by servers to gossip over the WAN, to other servers.
        '';
        server = mkBool false ''
          Server RPC: This is used by servers to handle incoming requests from other agents.
        '';
        sidecar = mkBool false ''
          Sidecar Proxy: Automatically assigned sidecar service registrations.
        '';
      };
    };
  config = {
    age.secrets."consul_encrypt_key.hcl" = {
      file = ../../secrets/consul/encrypt.hcl;
      owner = "consul";
    };

    services.consul = {
      enable = true;
      extraConfig = {
        acl = {
          enabled = true;
          default_policy = "deny";
          down_policy = "extend-cache";
        };
      };
      extraConfigFiles = [
        config.age.secrets."consul_encrypt_key.hcl".path
      ];
    };

    networking.firewall =
      let
        defaultPorts = {
          dns = 8600;
          http = 8500;
          serf_lan = 8301;
          serf_wan = 8302;
          server = 8300;
          sidecar_min_port = 21000;
          sidecar_max_port = 21255;
          expose_min_port = 21500;
          expose_max_port = 21755;
        };
        ports = defaultPorts // (config.servers.consul.extraConfig.ports or { });
        checkPort = name:
          if (cfg.firewall.open.${name} or false) then [ ports.${name} ] else [ ];
      in
      {
        allowedTCPPorts = concatLists [
          (checkPort "dns")
          (checkPort "http")
          (checkPort "https")
          (checkPort "grpc")
          (checkPort "serf_lan")
          (checkPort "serf_wan")
          (checkPort "server")
        ];

        allowedUDPPorts = concatLists [
          (checkPort "dns")
          (checkPort "http")
          (checkPort "https")
          (checkPort "grpc")
          (checkPort "serf_lan")
          (checkPort "serf_wan")
          (checkPort "server")
        ];

        allowedTCPPortRanges = mkIf cfg.firewall.open.sidecar [
          {
            from = ports.sidecar_min_port;
            to = ports.sidecar_max_port;
          }
          {
            from = ports.expose_min_port;
            to = ports.expose_max_port;
          }
        ];
      };
  };
}
