{ self, inputs, ... }:
with inputs.nixpkgs.lib;
let
  flakes = filterAttrs (_name: value: value ? outputs) inputs;

  mkPkgs = { system, config ? { }, overlays ? [ ] }: import inputs.nixpkgs {
    inherit system config overlays;
  };

  commonModules = with self.nixosModules; [
    { _module.args = { inherit self inputs; }; }
    {
      # Let 'nixos-version --json' know the Git revision of this flake.
      system.configurationRevision = mkIf (self ? rev) self.rev;
    }
    {
      # Add flake inputs to the system registry
      nix.registry = builtins.mapAttrs (_name: v: { flake = v; }) flakes;
      # Allow lookup of flakes via search path (e.g. "<unstable>")
      nix.nixPath = builtins.map (n: n + "=flake:" + n) (builtins.attrNames flakes);
      # Symlink flakes into /etc/nix/inputs
      environment.etc = mapAttrs'
        (name: value: { name = "nix/inputs/${name}"; value = { source = value.outPath; }; })
        inputs;
    }
    users.root
    age
    cachix
    environment
    locale
    nix-common
    security
    home-manager
    openssh
    {
      home-manager.extraSpecialArgs = { inherit inputs self; };
      home-manager.useGlobalPkgs = true;
      home-manager.backupFileExtension = "bck";
    }
  ];

in
{
  loki = nixosSystem {
    system = "x86_64-linux";
    pkgs = mkPkgs {
      system = "x86_64-linux";
      config.rocmSupport = true;
      config.allowUnfreePredicate = pkg:
        builtins.elem (getName pkg) [
          "discord"
          "steam"
          "steam-original"
          "steam-run"
        ];
      overlays = with inputs; [
        devshell.overlays.default
        kmonad.overlays.default
        neovim-nightly.overlay
        nur.overlay
        ragenix.overlays.default
        self.overlays.default
      ];
    };
    modules = with self.nixosModules; [
      ./loki/configuration.nix
      (users.reyu { profile = "desktop"; })
      kmonad
      onlykey
      podman
      qflipper
      sound
      u2f
      xserver
    ] ++ commonModules;
  };

  burrow = nixosSystem {
    system = "x86_64-linux";
    pkgs = mkPkgs {
      system = "x86_64-linux";
      config.allowUnfreePredicate = pkg:
        builtins.elem (getName pkg) [
          "plexmediaserver"
        ];
      overlays = with inputs; [
        neovim-nightly.overlay
        ragenix.overlays.default
        self.overlays.default
      ];
    };
    modules = with self.nixosModules; [
      ./burrow/configuration.nix
      (users.reyu { profile = "server"; })
      podman
    ] ++ commonModules;
  };

  # Currently has problems, but isn't used anyway.
  # kit = nixosSystem {
  #   system = "aarch64-linux";
  #   pkgs = mkPkgs {
  #     system = "aarch64-linux";
  #     config.rocmSupport = true;
  #     overlays = with inputs; [
  #       neovim-nightly.overlay
  #       ragenix.overlays.default
  #       self.overlays.default
  #     ];
  #   };
  #   modules = with self.nixosModules; [
  #     ./kit/configuration.nix
  #     (users.reyu { profile = "common"; })
  #     (import "${inputs.mobile-nixos}/lib/configuration.nix" {
  #       device = "pine64-pinephone";
  #     })
  #   ] ++ commonModules;
  # };

  traveler = nixosSystem {
    system = "x86_64-linux";
    pkgs = mkPkgs {
      system = "x86_64-linux";
      config.allowUnfreePredicate = pkg:
        builtins.elem (getName pkg) [
          "discord"
        ];
      overlays = with inputs; [
        neovim-nightly.overlay
        nur.overlay
        ragenix.overlays.default
        self.overlays.default
      ];
    };
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
    ] ++ commonModules;
  };

} // (
  /* Cloud Providers
   *
   * Import a submodule containing various profiles distinct to a cloud
   * provider so that the resulting name is "$PROVIDER-$PROFILE"
   * (e.g. "hetzner-consul" for a consul server running on Hetzner)
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
