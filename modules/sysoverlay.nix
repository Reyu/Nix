{ config, pkgs, options, ... }: {
  nix.nixPath = options.nix.nixPath.default
    ++ [ "nixpkgs-overlays=/etc/nixos/overlays-compat/" ];
  environment.etc = {
    "nixos/overlays-compat/overlays.nix".source = ./files/overlays.nix;
  };
}
