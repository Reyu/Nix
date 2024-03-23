{ self, inputs, ... }:
with inputs.nixpkgs.lib;
let
  mkPkgs = { system, config ? { }, overlays ? [ ] }: import inputs.nixpkgs {
    inherit system config overlays;
  };

  commonModules = with self.nixosModules; [
    inputs.impermanence.nixosModules.impermanence
    ./configuration.nix
    hetzner

    { _module.args = { inherit self inputs; }; }
    {
      # Let 'nixos-version --json' know the Git revision of this flake.
      system.configurationRevision = mkIf (self ? rev) self.rev;
    }
    users.root
    (users.reyu { profile = "server"; })
    age
    cachix
    environment
    locale
    nix-common
    security
    home-manager
    {
      home-manager.extraSpecialArgs = { inherit inputs self; };
      home-manager.useGlobalPkgs = true;
      home-manager.backupFileExtension = "bck";
    }
  ];
in
with inputs.nixpkgs.lib;
{
  base = nixosSystem {
    system = "x86_64-linux";
    pkgs = mkPkgs {
      system = "x86_64-linux";
      overlays = with inputs; [
        neovim-nightly.overlay
        ragenix.overlays.default
        self.overlays.default
      ];
    };
    modules = commonModules;
  };
  auth01 = nixosSystem {
    system = "x86_64-linux";
    pkgs = mkPkgs {
      system = "x86_64-linux";
      overlays = with inputs; [
        neovim-nightly.overlay
        ragenix.overlays.default
        self.overlays.default
      ];
    };
    modules = commonModules ++ (with self.nixosModules; [
      ./auth.nix
      acme
      kerberos
    ]);
  };
}
