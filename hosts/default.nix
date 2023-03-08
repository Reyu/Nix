{ self, inputs, ... }@args: {
  loki = {
    channelName = "unstable";
    modules = with self.nixosModules; [
      ./loki/configuration.nix
      { home-manager.users.reyu = import ../home-manager/profiles/desktop.nix; }
      consul
      flatpak
      onlykey
      sound
      xserver
      kmonad
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
      kmonad
    ];
  };
} // (
  let
    prefixNames = prefix: attrs: builtins.listToAttrs (map (x: { name = "${prefix}/${x}"; value = attrs.${x}; }) (builtins.attrNames attrs));
    addProvider = name: module: prefixNames name (import module args);
    providers = builtins.mapAttrs (name: value: { name = "A/${name}"; value = value; });
  in
  providers {
    /* "linode" = ./linode; */
  }
)
