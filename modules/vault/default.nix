{ config, lib, pkgs, ... }:
with lib;
let cfg = config.foxnet.vault;
in {
  options.foxnet.vault =
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
    services.vault = {
      enable = true;
    };

    networking.firewall =
      let
        defaultPorts = rec {
          http = 8200;
          server = http + 1;
        };
        ports = defaultPorts // (config.servers.vault.extraConfig.ports or { });
        checkPort = name:
          if (cfg.firewall.open.${name} or false) then [ ports.${name} ] else [ ];
      in
      {
        allowedTCPPorts = concatLists [
          (checkPort "http")
          (checkPort "https")
        ];
      };
  };
}
