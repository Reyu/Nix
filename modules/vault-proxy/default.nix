{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.vault-proxy;
  opt = options.services.vault-proxy;

  configFile = pkgs.writeText "vault-proxy.hcl" ''
    vault {
      address = "${cfg.vault.address}"
      ${if (cfg.vault.tlsCaCert == null) then "" else ''
          ca_cert = "${cfg.vault.tlsCaCert}"
        ''}
      ${if (cfg.vault.tlsCaPath == null) then "" else ''
          ca_path = "${cfg.vault.tlsCaPath}"
        ''}
      ${if (cfg.vault.tlsClientCert == null) then "" else ''
          client_cert = "${cfg.vault.tlsClientCert}"
        ''}
      ${if (cfg.vault.tlsClientKey == null) then "" else ''
          client_key = "${cfg.vault.tlsClientKey}"
        ''}
      ${if (cfg.vault.tlsSkipVerify == null) then "" else ''
          tls_skip_verify = "${cfg.vault.tlsSkipVerify}"
        ''}
      ${if (cfg.vault.tlsServerName == null) then "" else ''
          tls_server_name = "${cfg.vault.tlsServerName}"
        ''}
      ${if (cfg.vault.numRetries == null) then "" else ''
          retry {
            num_retries = ${cfg.vault.numRetries}
          }
        ''}
    }

    listener "tcp" {
      address = "${cfg.address}"
      ${cfg.listenerExtraConfig}
    }

    ${cfg.extraConfig}
  '';
in

{
  options = {
    services.vault-proxy = {
      enable = mkEnableOption (lib.mdDoc "Vault Proxy");

      package = mkOption {
        type = types.package;
        default = pkgs.vault;
        defaultText = literalExpression "pkgs.vault";
        description = lib.mdDoc "This option specifies the vault package to use";
      };

      address = mkOption {
        type = types.str;
        default = "127.0.0.1:8200";
        description = lib.mdDoc "The name of the ip interface to listen to";
      };

      role = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "metrics_only";
        description = "Determines which APIs the listener serves";
      };

      vault = {
        address = mkOption {
          type = types.str;
          default = null;
          example = "https://172.16.9.8:8200";
          description = lib.mdDoc "The address of the Vault server to connect to. This should be a Fully Qualified Domain Name (FQDN) or IP";
        };

        tlsCaCert = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "/path/to/your/ca.pem";
          description = lib.mdDoc "Path to a single PEM-encoded CA certificate to verify the Vault server's SSL certificate";
        };

        tlsCaPath = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "/path/to/your/ca.d";
          description = lib.mdDoc "Path to a directory of PEM-encoded CA certificates to verify the Vault server's SSL certificate";
        };

        tlsClientCert = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "/path/to/your/cert.pm";
          description = lib.mdDoc "Path to a single PEM-encoded CA certificate to use for TLS authentication to the Vault server";
        };

        tlsClientKey = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "/path/to/your/key.pm";
          description = lib.mdDoc "Path to a single PEM-encoded private key matching the client certificate from `client_cert`";
        };

        tlsSkipVerify = mkOption {
          type = types.nullOr types.bool;
          default = null;
          example = false;
          description = "Disable verification of TLS certificates. Using this option is highly discouraged as it decreases the security of data transmissions to and from the Vault server";
        };

        tlsServerName = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "host.example.com";
          description = "Name to use as the SNI host when connecting via TLS";
        };

        numRetries = mkOption {
          type = types.nullOr types.int;
          default = null;
          example = 12;
          description = "Specify how many times a failing request will be retried. A value of `0` translates to the default. A value of `-1` disables retries";
        };
      };

      listenerExtraConfig = mkOption {
        type = types.lines;
        default = ''
          tls_min_version = "tls12"
        '';
        description = lib.mdDoc "Extra text appended to the listener section";
      };

      extraSettingsPaths = mkOption {
        type = types.listOf types.path;
        default = [];
        description = lib.mdDoc ''
          Configuration files to load besides the immutable one defined by the NixOS module.
          This can be used to avoid putting credentials in the Nix store, which can be read by any user.

          Each path can point to a JSON- or HCL-formatted file, or a directory
          to be scanned for files with `.hcl` or
          `.json` extensions.

          To upload the confidential file with NixOps, use for example:

          ```
          # https://releases.nixos.org/nixops/latest/manual/manual.html#opt-deployment.keys
          deployment.keys."vault.hcl" = let db = import ./db-credentials.nix; in {
            text = ${"''"}
              storage "postgresql" {
                connection_url = "postgres://''${db.username}:''${db.password}@host.example.com/exampledb?sslmode=verify-ca"
              }
            ${"''"};
            user = "vault";
          };
          services.vault.extraSettingsPaths = ["/run/keys/vault.hcl"];
          services.vault.storageBackend = "postgresql";
          users.users.vault.extraGroups = ["keys"];
          ```
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc "Extra text appended to {file}`vault-proxy.hcl`.";
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.vault-proxy = {
      name = "vault-proxy";
      group = "vault-proxy";
      description = "Vault Proxy daemon user";
      isSystemUser = true;
    };
    users.groups.vault-proxy = {};

    systemd.services.vault-proxy = {
      description = "Vault proxy daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [ pkgs.getent ];
      startLimitIntervalSec = 60;
      startLimitBurst = 3;
      serviceConfig = {
        User = "vault-proxy";
        Group = "vault-proxy";
        RuntimeDirectory = "vault-proxy";
        ExecStart = "${cfg.package}/bin/vault proxy --config ${configFile}";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGHUP $MAINPID";
        KillSignal = "SIGINT";
        TimeoutStopSec = "30s";
        Restart = "on-failure";
      };
    };
  };
}
