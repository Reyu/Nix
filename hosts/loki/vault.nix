{ config, pkgs, ... }: {
  config = {
    networking.firewall = {
      allowedTCPPorts = [
        8200 # Vault
        8201 # Vault Cluster
      ];
    };
    users.users.vault = {
      name = "vault";
      group = "vault";
      uid = config.ids.uids.vault;
      description = "Vault daemon user";
    };
    users.groups.vault.gid = config.ids.gids.vault;

    environment.etc.vault_config {
      target = "vault.d/vault.hcl";
      text = ''
        vault {
          address = "http://burrow.home.reyuzenfold.com:8200"
        }
      '';
    };
    systemd.services.vault = {
      description = "Vault client daemon";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      startLimitIntervalSec = 60;
      startLimitBurst = 3;
      serviceConfig = {
        User = "vault";
        Group = "vault";
        ExecStart = "${pkgs.vault}/bin/vault server -config=/etc/vault.d";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGHUP $MAINPID";
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectSystem = "full";
        ProtectHome = "read-only";
        AmbientCapabilities = "cap_ipc_lock";
        NoNewPrivileges = true;
        KillSignal = "SIGINT";
        TimeoutStopSec = "30s";
        Restart = "on-failure";
      };
    };
  };
}
