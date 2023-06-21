{
  description = "Reyu Zenfold's NixOS Flake";

  inputs = {
    # Core
    nixpkgs.url = "github:nixos/nixpkgs";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    devshell = {
      url = "github:numtide/devshell";
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
    agenix = {
      url = "github:ryantm/agenix/19bf5a20d835145e5f3fc8d61672eefee4c33450";
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

  outputs = { self, nixpkgs, utils, ... }@inputs:
    utils.lib.mkFlake {
      # Required inputs of `mkFlake`
      inherit inputs self;

      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];

      sharedOverlays = with inputs; [
        agenix.overlays.default
        devshell.overlays.default
        neovim-nightly.overlay
        nur.overlay
        kmonad.overlays.default
        (import ./overlays { inherit inputs; })
      ];

      channelsConfig = {
        allowUnfreePredicate = pkg:
          builtins.elem (nixpkgs.lib.getName pkg) [
            "betterttv"
            "discord"
            "nomachine-client"
            "pine64-pinephone-firmware"
            "plexmediaserver"
            "slack"
            "steam"
            "steam-original"
            "steam-run"
            "steam-runtime"
          ];
      };

      hostDefaults.system = "x86_64-linux";
      hostDefaults.channelName = "nixpkgs";
      hostDefaults.modules = with self.nixosModules; [
        "${inputs.home-manager}/nixos"
        {
          home-manager.extraSpecialArgs = { inherit inputs self; };
          home-manager.useGlobalPkgs = true;
          home-manager.backupFileExtension = "bck";
        }
        ./users/root
        age
        cachix
        crypto
        environment
        locale
        nix-common
        security
        ({ _, ... }: {
          _module.args = { inherit self; };

          # Let 'nixos-version --json' know the Git revision of this flake.
          system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          # flake-utils-plus options
          nix.linkInputs = true;
          nix.generateRegistryFromInputs = true;
          nix.generateNixPathFromInputs = true;
          # Default stateVersion
          system.stateVersion = "22.05";
        })
      ];

      hosts = import ./hosts { inherit self inputs; };

      homeConfigurations = import ./home-manager { inherit self inputs; };

      outputsBuilder = channels:
        let
          pkgs = channels.nixpkgs;
          formatter = pkg: { package = pkg; category = "formatters"; };
          buildTool = pkg: { package = pkg; category = "build tools"; };
          defaultShell = with pkgs; {
            name = "FoxNet-Nix";
            packages = [ cachix rnix-lsp ];
            commands = [
              {
                package = fup-repl;
                help = "A package that adds a kick-ass repl";
              }
              {
                package = agenix;
                category = "secrets management";
              }
              (buildTool nixos-generators)
              (formatter treefmt)
              (formatter nixpkgs-fmt)
              (formatter luaformatter)
              (formatter hclfmt)
              (formatter shfmt)
            ];
          };
          mkShell = extra: pkgs.devshell.mkShell (defaultShell // extra);
        in
        {
          # Default Nix Formatter
          formatter = pkgs.nixpkgs-fmt;

          # construct packagesBuilder to export all packages defined in overlays
          packages = utils.lib.exportPackages self.overlays channels;

          devShells.default = mkShell { };
          devShells.terranix = mkShell {
            name = "FoxNet-Terranix";
            commands = defaultShell.commands ++ [
              { package = pkgs.linode-cli; }
            ];
          };
        };

      overlays = utils.lib.exportOverlays { inherit (self) pkgs inputs; } // {
        default = import ./overlays { inherit inputs; };
      };

      nixosModules = {
        inherit (inputs.agenix.nixosModules) age;
        kmonad = inputs.kmonad.nixosModules.default;
      } // builtins.listToAttrs (map
        (x: {
          name = x;
          value = import (./modules + "/${x}");
        })
        (builtins.attrNames (builtins.readDir ./modules)));

      homeModules = builtins.listToAttrs (map
        (x: {
          name = x;
          value = import ./home-manager/modules/${x};
        })
        (builtins.attrNames (builtins.readDir ./home-manager/modules)));

      checks = with builtins;
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
          (filter
            (p: pathExists (./modules/${p}/test.nix))
            (attrNames (readDir ./modules))));
    };
}
