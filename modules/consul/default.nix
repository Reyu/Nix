{ config, lib, pkgs, ... }: 
let
  inherit (lib) mkIf mkDefault mkEnableOption mkOption;
in {
  config = {
    services.consul = {
      extraConfig = {
        acl = {
          enabled = true;
          default_policy = "allow";
          down_policy = "extend-cache";
        };
        ports.grpc = 8502;
        connect.enabled = true;
      };
    };
    foxnet.secrets.consul_encrypt_key = {
      source = ../../secrets/consul/encrypt.hcl;
      dest = "/etc/consul.d/encrypt.hcl";
      owner = "consul";
    };
  };
}
