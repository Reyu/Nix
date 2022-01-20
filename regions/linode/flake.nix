{
  description = "Linode Datacenter";

  inputs = {
    foxnet.url = "../../";
    nixpkgs.url = "github:nixos/nixpkgs";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "utils";
    };
  };
  outputs = { self, ... }@inputs:
    with inputs;
    let extraSpecialArgs = { inherit inputs self; };
    in
    utils.lib.mkFlake {
      inherit self inputs;

      sharedOverlays = [ foxnet.overlay ];

      hostDefaults.modules = with foxnet.nixosModules; [
        ../../hosts/linode/configuration.nix
        age
        cachix
        crypto
        environment
        locale
        nix-common
        security
        ({ ... }: {
          # Let 'nixos-version --json' know the Git revision of this flake.
          system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          nix.registry.nixpkgs.flake = nixpkgs;
          nix.registry.foxnet.flake = self;
        })

        consul
        ({ ... }: {
          config.services.consul = {
            interface.bind = "eth0";
            extraConfig.datacenter = "us-east01";
          };
        })
      ];

      hosts = with foxnet.nixosModules;
        let
          # Terraform Data
          terraform = nixpkgs.lib.importJSON ./terraform.json;
          # Roles
          consulServer = ({ config, lib, ... }: {
            config.foxnet.consul.firewall.open = {
              server = true;
              serf_wan = true;
              http = true;
            };
            config.services.consul.extraConfig = {
              server = true;
              bootstrap_expect = 3;
              retry_join = map (x: x.private) (builtins.attrValues terraform.consul);
            };
          });
          # Hosts
          hosts = builtins.mapAttrs
            (name: value: {
              modules = [
                consulServer
                {
                  config = {
                    networking.hostName = name;
                    networking.domain = "linode.reyuzenfold.com";
                    networking.interfaces.eth0 = {
                      # Add private IP
                      ipv4.addresses = [{
                        address = value.private;
                        prefixLength = 17;
                      }];
                      # in addition to the provided DHCP address (public)
                      useDHCP = true;
                    };
                    services.consul.extraConfig = {
                      serf_lan = value.private;
                      serf_wan = value.public.ipv4;
                      advertise_addr_ipv4 = value.private;
                      advertise_addr_ipv6 = value.public.ipv6;
                      advertise_addr_wan_ipv4 = value.public.ipv4;
                      advertise_addr_wan_ipv6 = value.public.ipv6;
                    };
                  };
                }
              ];
            })
            terraform.consul;
        in
        hosts;

      deploy.nodes =
        let
          inherit (deploy-rs.lib.x86_64-linux.activate) nixos home-manager custom;
          nodes = builtins.mapAttrs
            (name: value: {
              hostname = "${name}.linode.reyuzenfold.com";
              profiles = {
                system = {
                  sshUser = "root";
                  path = nixos self.nixosConfigurations.${name};
                };
              };
            })
            self.nixosConfigurations;
        in
        nodes;

      # Sanity check for deploy-rs
      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy)
        deploy-rs.lib;
    };
}
