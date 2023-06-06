{ self, inputs, ... }@args: {
  loki = {
    channelName = "unstable";
    modules = with self.nixosModules; [
      ./loki/configuration.nix
      { home-manager.users.reyu = import ../home-manager/profiles/desktop.nix; }
      consul
      flatpak
      kmonad
      onlykey
      qflipper
      sound
      u2f
      xserver
    ];
  };
  burrow = {
    modules = with self.nixosModules; [
      ./burrow/configuration.nix
      { home-manager.users.reyu = import ../home-manager/profiles/server.nix; }
      consul
      docker
      nomad
      vault
    ];
  };
  kit = {
    system = "aarch64-linux";
    modules = with self.nixosModules; [
      ./kit/configuration.nix
      { home-manager.users.reyu = import ../home-manager/profiles/common.nix; }
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
      {
        home-manager.users.reyu = {
          imports = [
            inputs.impermanence.nixosModules.home-manager.impermanence
            ../home-manager/profiles/server.nix
            ../home-manager/modules/impermanence
          ];
        };
      }
      heads
      onlykey
      qflipper
      kmonad
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
      (n: prefixNames n (import x.${n}))
      (builtins.attrNames x));
  in
  providers {
    linode = ./linode;
  }
)
