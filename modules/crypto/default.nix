{ pkgs, config, lib, ... }:

# Shamelessly stolen from Christine Dodrill with minor changes
# https://christine.website/blog/nixos-encrypted-secrets-2021-01-20

with lib;
let
  cfg = config.foxnet.secrets;

  secret = types.submodule {
    options = {
      source = mkOption {
        type = types.path;
        description = "local secret path";
      };

      dest = mkOption {
        description = "where to write the decrypted secret to";
        example = "/etc/keys/key1";
        type = types.str;
      };

      owner = mkOption rec {
        default = "root";
        description = "who should own the secret";
        example = default;
        type = types.str;
      };

      group = mkOption rec {
        default = "root";
        description = "what group should own the secret";
        example = default;
        type = types.str;
      };

      permissions = mkOption rec {
        default = "0400";
        description = "Permissions expressed as octal.";
        example = default;
        type = types.str;
      };
    };
  };

  metadata = lib.importTOML ../../ops/metadata/hosts.toml;

  mkService = name:
    { source, dest, owner, group, permissions, ... }: {
      description = "decrypt secret for ${name}";
      wantedBy = [ "multi-user.target" ];

      serviceConfig.Type = "oneshot";

      script = with pkgs; ''
        mkdir -p $(dirname ${dest})
        rm -rf ${dest}
        "${rage}"/bin/rage -d -i /etc/ssh/ssh_host_ed25519_key -o '${dest}' '${source}'
        chown '${owner}':'${group}' '${dest}'
        chmod '${permissions}' '${dest}'
      '';
    };
in {
  options.foxnet.secrets = mkOption {
    type = types.attrsOf secret;
    description = "secret configuration";
    default = { };
  };

  config.systemd.services = let
    units = mapAttrs' (name: info: {
      name = "${name}-key";
      value = (mkService name info);
    }) cfg;
  in units;
}
