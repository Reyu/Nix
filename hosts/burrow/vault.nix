{ config, pkgs, ... }: {
  config = {
    networking.firewall = {
      allowedTCPPorts = [
        8200 # Vault
        8201 # Vault Cluster
      ];
    };
    services = {
      vault = {
        enable = true;
        address = "172.16.10.10:8200";
        storageBackend = "consul";
        extraSettingsPaths = [ /etc/vault.d ];
      };
    };
    within.secrets.vault-storage = {
      source = ../../secrets/vault/burrow-storage.hcl;
      dest = "/etc/vault.d/storage.hcl";
      owner = "vault";
    };
  };
}
