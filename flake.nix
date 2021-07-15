{
  description = "Reyu Zenfold's Nix Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    flake-utils.url = "github:numtide/flake-utils";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      nixosSystem = nixpkgs.lib.makeOverridable nixpkgs.lib.nixosSystem;
      defSystem = hostname:
        nixosSystem {
          system = "x86_64-linux";
          modules = [
            ({ ... }: {
              imports = [
                { nix.nixPath = [ "nixpkgs=${nixpkgs}" ]; }
                home-manager.nixosModules.home-manager
                { home-manager.useUserPackages = true; }
                (./hosts + "/${hostname}" + /configuration.nix)
              ];
              # Let 'nixos-version --json' know the Git revision of this flake.
              system.configurationRevision =
                nixpkgs.lib.mkIf (self ? rev) self.rev;
            })
          ];
        };
      overlays = [ inputs.neovim-nightly-overlay.overlay inputs.nur.overlay ];
      defConfiguration = imports:
        home-manager.lib.homeManagerConfiguration {
          configuration = { pkgs, ... }: {
            xdg.configFile."nix/nix.conf".source = ./configs/nix/nix.conf;
            nixpkgs.config = import ./configs/nix/config.nix;
            nixpkgs.overlays = overlays;
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
        };
    in {
      nixosConfigurations = {
        loki = defSystem "loki";
        burrow = defSystem "burrow";
        traveler = defSystem "traveler";
        ismene = defSystem "ismene" // { system = "aarch64-linux"; };
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
      let pkgs = import nixpkgs { inherit system overlays; };
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
