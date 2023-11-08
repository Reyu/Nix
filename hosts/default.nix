{ self, inputs, ... }: {
  loki = {
    channelName = "unstable";
    modules = with self.nixosModules; [
      ./loki/configuration.nix
      (users.reyu { profile = "desktop"; })
      consul
      kmonad
      onlykey
      podman
      qflipper
      sound
      u2f
      vault-proxy
      xserver
    ];
  };
  burrow = {
    modules = with self.nixosModules; [
      ./burrow/configuration.nix
      (users.reyu { profile = "server"; })
      consul
      nomad
      podman
      vault
    ];
  };
  kit = {
    system = "aarch64-linux";
    modules = with self.nixosModules; [
      ./kit/configuration.nix
      (users.reyu { profile = "common"; })
      (import "${inputs.mobile-nixos}/lib/configuration.nix" {
        device = "pine64-pinephone";
      })
    ];
  };
  traveler = {
    modules = with self.nixosModules; [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x230
      inputs.impermanence.nixosModules.impermanence
      ./traveler/configuration.nix
      (users.reyu { profile = "server"; })
      {
        home-manager.users.reyu = {
          imports = [
            inputs.impermanence.nixosModules.home-manager.impermanence
            ../home-manager/modules/impermanence
          ];
        };
      }
      heads
      kmonad
      onlykey
      podman
      qflipper
    ];
  };
  consul-ash-00 = {
    modules = with self.nixosModules; [
      inputs.impermanence.nixosModules.impermanence
      ./hetzner/configuration.nix
      hetzner
      consul

      {
        foxnet.consul.firewall.open = {
          server = true;
          serf_wan = true;
        };
        services.consul = {
          extraConfig = {
            server = true;
            bootstrap = true;
            datacenter = "ash";
          };
        };
      }
    ];
  };
  vault-ash-00 = {
    modules = with self.nixosModules; [
      inputs.impermanence.nixosModules.impermanence
      ./hetzner/configuration.nix
      hetzner
      consul
      vault

      {
        foxnet.vault.firewall.open = {
          http = true;
          server = true;
        };
        services.consul = {
          extraConfig = {

          };
        };
        services.vault = {

        };
      }
    ];
  };
} // (
  /* Cloud Providers
   *
   * Import a submodule containing various profiles distinct to a cloud
   * provider so that the resulting name is "$PROVIDER/$PROFILE"
   * (e.g. "linode/consul" for a consul server running on Linode)
   */
  let
    prefixNames = prefix: attrs: map
      (x: {
        name = "${prefix}-${x}";
        value = attrs.${x};
      })
      (builtins.attrNames attrs);
    providers = x: builtins.listToAttrs (builtins.concatMap
      (n: prefixNames n (import x.${n} { inherit self inputs; }))
      (builtins.attrNames x));
  in
  providers {
    hetzner = ./hetzner;
  }
)
