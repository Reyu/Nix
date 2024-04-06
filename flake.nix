{
  description = "Reyu Zenfold's NixOS Flake";

  inputs = {
    # Core
    nixpkgs.url = "github:nixos/nixpkgs";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable-small";
    systems.url = "github:nix-systems/default";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    mobile-nixos = {
      url = "github:NixOS/mobile-nixos";
      flake = false;
    };
    impermanence.url = "github:nix-community/impermanence";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Automatic deployment
    ragenix = {
      url = "github:/yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ZSH Plugins
    zsh-vimode-visual = {
      url = "github:b4b4r07/zsh-vimode-visual";
      flake = false;
    };

    # Vim + Plugins
    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bufresize-nvim = {
      url = "github:kwkarlwang/bufresize.nvim";
      flake = false;
    };
    edgy-nvim = {
      url = "github:folke/edgy.nvim";
      flake = false;
    };
    github-nvim-theme = {
      url = "github:projekt0n/github-nvim-theme";
      flake = false;
    };
    nvim-projector = {
      url = "github:kndndrj/nvim-projector";
      flake = false;
    };

    # Discord + Plugins
    replugged = {
      url = "github:LunNova/replugged-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    discord-better-status = {
      url = "github:GriefMoDz/better-status-indicators";
      flake = false;
    };
    discord-read-all = {
      url = "github:intrnl/powercord-read-all";
      flake = false;
    };
    discord-theme-slate = {
      url = "github:DiscordStyles/Slate";
      flake = false;
    };
    discord-theme-toggler = {
      url = "github:redstonekasi/theme-toggler";
      flake = false;
    };
    discord-tweaks = {
      url = "github:NurMarvin/discord-tweaks";
      flake = false;
    };
    discord-vc-timer = {
      url = "github:RazerMoon/vcTimer";
      flake = false;
    };

    # Other Sources
    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, systems, ... }@inputs:
    let
      eachSystem = f: nixpkgs.lib.genAttrs (import systems)
        (system: f (import nixpkgs {
          inherit system; overlays = [
          inputs.devshell.overlays.default
          inputs.ragenix.overlays.default
        ];
        }));
    in
    {

      nixosConfigurations = import ./hosts { inherit self inputs; };

      nixosModules = {
        inherit (inputs.ragenix.nixosModules) age;
        inherit (inputs.home-manager.nixosModules) home-manager;
        kmonad = inputs.kmonad.nixosModules.default;
      } // builtins.listToAttrs (map
        (x: {
          name = x;
          value = import (./modules + "/${x}");
        })
        (builtins.attrNames (builtins.readDir ./modules)));

      homeConfigurations = import ./home-manager { inherit self inputs; };

      homeModules = builtins.listToAttrs (map
        (x: {
          name = x;
          value = import ./home-manager/modules/${x};
        })
        (builtins.attrNames (builtins.readDir ./home-manager/modules)));

      overlays.default = import ./overlays { inherit inputs; };

      devShells = eachSystem (pkgs:
        let
          formatter = pkg: {
            package = pkg;
            category = "formatters";
          };
          buildTool = pkg: {
            package = pkg;
            category = "build tools";
          };
        in
        {
          default = pkgs.devshell.mkShell (with pkgs; {
            name = "FoxNet-Nix";
            packages = [ cachix ];
            commands = [
              {
                package = ragenix;
                category = "secrets management";
              }
              {
                package = "linode-cli";
                category = "deployment";
              }
              {
                package = "hcloud";
                category = "deployment";
              }
              (buildTool nixos-generators)
              (formatter treefmt)
              (formatter nixpkgs-fmt)
              (formatter luaformatter)
              (formatter hclfmt)
              (formatter shfmt)
            ];
          });
        });

      apps = eachSystem (pkgs: {
        linode-image-upload = {
          type = "app";
          program = toString (pkgs.writeShellScript "linode-image-upload" ''
            LINODE_LABEL="NixOS_$(date -I)"
            LINODE_DESCR="Commit: $(${pkgs.git}/bin/git describe --always --abbrev=40 --dirty)"
            LINODE_IMAGE=${self.packages.${pkgs.system}.linode}/nixos.img.gz
            ${pkgs.linode-cli}/bin/linode-cli image-upload --label "$LINODE_LABEL" --description "$LINODE_DESCR" $LINODE_IMAGE
          '');
        };
      });

      packages = {
        x86_64-linux.linode =
          let
            pkgs = import nixpkgs { system = "x86_64-linux"; };
          in
          inputs.nixos-generators.nixosGenerate {
            inherit (pkgs) system;
            format = "linode";
            modules = with self.nixosModules; [
              {
                _module.args = { inherit self; };
                system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
              }
              {
                home-manager.extraSpecialArgs = { inherit inputs self; };
                home-manager.useGlobalPkgs = true;
              }
              home-manager
              environment
              locale
              nix-common
              security
              users.root
            ];
          };
      };

      formatter = eachSystem (pkgs: inputs.treefmt-nix.lib.mkWrapper pkgs {
        projectRootFile = "flake.nix";
        programs = {
          deadnix.enable = true;
          nixpkgs-fmt.enable = true;
        };
      });

      checks = eachSystem (_:
        with builtins;
        # Checks to run with `nix flake check -L`, will run in a QEMU VM.
        # Looks for all ./modules/<module name>/test.nix files and adds them to
        # the flake's checks output. The test.nix file is optional and may be
        # added to any module.
        listToAttrs (map
          (x: {
            name = x;
            value = (import ./modules/${x}/test.nix) {
              pkgs = nixpkgs;
              inherit self;
            };
          })
          # Filter list of modules, leaving only modules which contain a
          # `test.nix` file
          (filter (p: pathExists (./modules/${p}/test.nix))
            (attrNames (readDir ./modules)))));
    };
}
