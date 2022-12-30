{ self, inputs, ... }: {
  loki = {
    modules = with self.nixosModules; [
      ./loki/configuration.nix
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
      consul
      docker
      nomad
      telegraf
      vault
    ];
  };
  kit = {
    system = "aarch64-linux";
    modules = with self.nixosModules; [
      ./kit/configuration.nix
      (import "${inputs.mobile-nixos}/lib/configuration.nix" {
        device = "pine64-pinephone";
      })
      onlykey
    ];
  };
}
