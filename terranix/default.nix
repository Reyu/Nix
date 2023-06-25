{ config, lib, ... }:
with lib;
let cfg = config.foxnet.hashi_servers;
in {
  options.foxnet.hashi_servers = {

    count = mkOption rec {
      default = 3;
      description = "Number of Servers";
      example = default;
      type = types.int;
    };

    region = mkOption rec {
      default = "us-southeast";
      description = "Deployment Region";
      example = default;
      type = types.str;
    };

    image = mkOption rec {
      description = "Deployment Image";
      example = "private/00000000";
      type = types.str;
    };

    size = mkOption rec {
      default = "g6-nanode-1";
      description = "Instance Size";
      example = default;
      type = types.str;
    };

    tags = mkOption rec {
      default = [ "foxnet" "hashicorp" ];
      description = "Instance tags";
      example = default;
      type = types.listOf types.str;
    };

    domain = mkOption rec {
      default = "reyuzenfold.com";
      description = "Domain Name";
      example = default;
      type = types.str;
    };
  };
  config = {
    terraform = {
      required_providers = {

        linode = {
          source = "linode/linode";
          version = "1.29.4";
        };

        random = {
          source = "hashicorp/random";
          version = "~> 2.2.0";
        };
      };
    };

    data.linode_domain.default = { inherit (cfg) domain; };

    resource = {
      random_string.root_pass = {
        length = 32;
        special = true;
      };

      linode_instance.hashi_server = {
        inherit (cfg) count region image tags;
        label = "\${ format(\"hashi%02d\", count.index + 1) }";
        type = cfg.size;
        private_ip = true;
      };

      linode_instance_disk.nixos_boot = {
        inherit (cfg) count;
        linode_id = "\${linode_instance.hashi_server[count.index].id}";
        label = "\${ format(\"hashi%02d_boot\", count.index + 1) }";
        image = cfg.image;
        filesystem = "ext4";
        size = "\${linode_instance.hashi_server[count.index].specs.0.disk - 512}";
      };

      linode_instance_disk.nixos_swap = {
        inherit (cfg) count;
        linode_id = "\${linode_instance.hashi_server[count.index].id}";
        label = "\${ format(\"hashi%02d_swap\", count.index + 1) }";
        filesystem = "swap";
        size = 512;
      };

      linode_instance_config.nixos = {
        inherit (cfg) count;
        linode_id = "\${linode_instance.hashi_server[count.index].id}";
        label = "NixOS";
        booted = true;
        kernel = "linode/grub2";
        helpers = {
          devtmpfs_automount = false;
          distro = false;
          modules_dep = false;
          network = false;
        };
        devices = {
            sda = {
              disk_id = "\${linode_instance_disk.nixos_boot[count.index].id}";
            };
            sdb = {
              disk_id = "\${linode_instance_disk.nixos_swap[count.index].id}";
            };
        };
      };

      linode_domain_record = rec {
        hashi_ipv4 = {
          inherit (cfg) count;
          domain_id = "\${ data.linode_domain.default.id }";
          name =
            "\${linode_instance.hashi_server[count.index].label}.${cfg.region}";
          record_type = "A";
          target = "\${linode_instance.hashi_server[count.index].ip_address}";
        };
        hashi_ipv6 = {
          inherit (hashi_ipv4) count domain_id name;
          record_type = "AAAA";
          target = ''
            ''${ split("/", linode_instance.hashi_server[count.index].ipv6)[0] }'';
        };
      };

      linode_rdns.hashi_rdns = {
        inherit (cfg) count;
        address = "\${ linode_domain_record.hashi_ipv4[count.index].target }";
        rdns = "\${ linode_domain_record.hashi_ipv4[count.index].name }";
        wait_for_available = true;
      };
    };
  };
}
