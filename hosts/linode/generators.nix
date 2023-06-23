{ self, inputs, ... }:
let
  lib = inputs.nixpkgs.lib;
  default_modules = with self.nixosModules; [
    "${inputs.home-manager}/nixos"
    { home-manager.extraSpecialArgs = { inherit inputs self; }; }
    environment
    locale
    nix-common
    security
    ({ ... }: {
      _module.args = { inherit self; };
      # Let 'nixos-version --json' know the Git revision of this flake.
      system.configurationRevision = lib.mkIf (self ? rev) self.rev;
      # Default stateVersion
      system.stateVersion = "22.05";
    })
  ];
in {
  linode-consul = inputs.nixos-generators.nixosGenerate {
    system = "x86_64-linux";
    format = "linode";
    modules = with self.nixosModules; [ ./consul ];
  };
}
