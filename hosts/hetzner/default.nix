{ self, inputs, ... }:
with inputs.nixpkgs.lib;
let
  defaultOverlays = with inputs; [
    neovim-nightly.overlay
    ragenix.overlays.default
    self.overlays.default
  ];
  mkPkgs =
    {
      system,
      pkgs ? inputs.nixpkgs,
      config ? { },
      overlays ? defaultOverlays,
    }:
    import pkgs { inherit system config overlays; };

  commonModules = with self.nixosModules; [
    inputs.impermanence.nixosModules.impermanence
    ./configuration.nix
    hetzner

    {
      _module.args = {
        inherit self inputs;
      };
    }
    {
      # Let 'nixos-version --json' know the Git revision of this flake.
      system.configurationRevision = mkIf (self ? rev) self.rev;
    }
    users.root
    (users.reyu { profile = "server"; })
    age
    cachix
    environment
    kerberos
    ldap
    locale
    nix-common
    security
    home-manager
    {
      home-manager.extraSpecialArgs = {
        inherit inputs self;
      };
      home-manager.useGlobalPkgs = true;
      home-manager.backupFileExtension = "bck";
    }
  ];
in
{
  base = nixosSystem {
    system = "x86_64-linux";
    pkgs = mkPkgs { system = "x86_64-linux"; };
    modules = commonModules;
  };
  auth01 = nixosSystem {
    system = "x86_64-linux";
    pkgs = mkPkgs { system = "x86_64-linux"; };
    modules =
      commonModules
      ++ (with self.nixosModules; [
        { networking.hostName = mkForce "auth"; }
        ./auth.nix
        acme
      ]);
  };
  ash-db = nixosSystem {
    system = "x86_64-linux";
    pkgs = mkPkgs { system = "x86_64-linux"; };
    modules =
      commonModules
      ++ (with self.nixosModules; [
        { networking.hostName = mkForce "database"; }
        ./database.nix
        acme
      ]);
  };
}
