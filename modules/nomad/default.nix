{ config, lib, pkgs, ... }:
with lib;
let cfg = config.foxnet.nomad;
in {
  options.foxnet.nomad =
    let
      mkBool = default: description:
        mkOption {
          inherit default description;
          type = types.bool;
        };
    in
    {
      firewall.open = {
        http = mkBool false "";
        server = mkBool false "";
      };
    };
  config = {
    services.nomad = {
      enable = true;
      enableDocker = true;
      extraPackages = with pkgs; [ cni-plugins ];
      settings = {
        acl.enabled = true;
        client.cni_path = pkgs.cni-plugins + "/bin";
      };
    };

    networking.firewall =
      let
        defaultPorts = rec {
          http = 4646;
        };
        ports = defaultPorts // (config.servers.nomad.extraConfig.ports or { });
        checkPort = name:
          if (cfg.firewall.open.${name} or false) then [ ports.${name} ] else [ ];
      in
      {
        allowedTCPPorts = concatLists [
          (checkPort "http")
        ];
      };
  };
}
