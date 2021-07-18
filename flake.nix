{
  description = "Reyu Zenfold's Nix Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    flake-utils.url = "github:numtide/flake-utils";
    neovim-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (builtins) attrValues;
      inherit (nixpkgs) lib;

      pkgs = { system ? "x86_64-linux" }:
        (import nixpkgs) {
          system = "${system}";
          overlays = attrValues self.overlays;
          config.allowUnfreePredicate = pkg:
            builtins.elem (lib.getName pkg) [
              "steam"
              "steam-original"
              "steam-runtime"
            ];
        };
      sysConfigRevision = { ... }: {
        # Let 'nixos-version --json' know the Git revision of this flake.
        system.configurationRevision = lib.mkIf (self ? rev) self.rev;
      };
      nixosSystem = lib.makeOverridable lib.nixosSystem;
      defHost = { host, system ? "x86_64-linux" }:
        nixosSystem {
          system = "${system}";
          modules = [
            sysConfigRevision
            ({ ... }: {
              imports = [
                home-manager.nixosModules.home-manager
                { home-manager.useUserPackages = true; }
                (./hosts + "/${host}" + /configuration.nix)
              ];
            })
          ];
          inherit (pkgs { system = "${system}"; })
          ;
        };
      defSystem = { system ? "x86_64-linux", extraModules ? [] }:
        nixosSystem {
          system = "${system}";
          modules = [
            sysConfigRevision
            ({ ... }: {
              imports = [ ./common ./cachix.nix ];
            })
          ] ++ extraModules;
        };
      defConfiguration = imports:
        home-manager.lib.homeManagerConfiguration {
          configuration = { pkgs, ... }: {
            xdg.configFile."nix/nix.conf".source = ./configs/nix/nix.conf;
            nixpkgs.config = import ./configs/nix/config.nix;
            imports = [
              ./modules/home-manager.nix
              ./modules/shell.nix
              ./modules/tmux.nix
              ./modules/nvim.nix
              ./modules/zsh.nix
            ] ++ imports;
          };
          system = "x86_64-linux";
          homeDirectory = "/home/reyu";
          username = "reyu";
          inherit pkgs;
        };
    in {
      overlays = {
        nur = final: prev: {
          nur = import inputs.nur {
            nurpkgs = final.unstable;
            pkgs = final.unstable;
          };
        };
        neovim-nightly = final: prev: {
          neovim-nightly =
            import inputs.neovim-overlay { pkgs = final.unstable; };
        };
        unstable = final: prev: {
          unstable = import inputs.unstable { system = final.system; };
        };
        master = final: prev: {
          master = import inputs.master { system = final.system; };
        };
      };
      nixosConfigurations = {
        loki = defHost { host = "loki"; };
        burrow = defHost { host = "burrow"; };
        traveler = defHost { host = "traveler"; };
        ismene = defHost {
          host = "ismene";
          system = "aarch64-linux";
        };
        hashi-server = nixosSystem {
          system = "x86_64-linux";
          modules = [
            sysConfigRevision
            ({ pkgs, ... }: {
              config = {
                services = {
                  consul.enable = true;
                  vault.enable = true;
                  nomad.enable = true;
                };
              };
            })
          ];
        };
      };
      homeConfigurations = {
        nixos-desktop = defConfiguration [
          ./modules/chat.nix
          ./modules/firefox.nix
          ./modules/xsession.nix
        ];
        macbook = defConfiguration [ ] // {
          system = "x86_64-darwin";
          homeDirectory = "/Users/t0m00fc";
          username = "t0m00fc";
        };
      };
    } // inputs.flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
    (system:
      let pkgs = import nixpkgs { inherit system pkgs; };
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            nixfmt
            # For XMonad and related Haskell files
            haskellPackages.brittany
            haskellPackages.haskell-language-server
          ];
        };
      });
}
