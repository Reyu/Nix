{ self, ... }:
let
  tailscale_domain = "wolf-diatonic.ts.net";
  metadata = builtins.fromTOML (builtins.readFile (self + /hosts/metadata.toml));
in
{
  # NixOS Hosts
  burrow = {
    inherit (metadata.hetzner-auth) publicKey;
    extraHostNames = metadata.burrow.extraHostNames ++ [
      "burrow.${tailscale_domain}"
    ];
  };
  loki = {
    inherit (metadata.loki) publicKey;
    extraHostNames = metadata.loki.extraHostNames ++ [
      "loki.${tailscale_domain}"
    ];
  };
  traveler = {
    inherit (metadata.traveler) publicKey;
    extraHostNames = [
      "traveler.${tailscale_domain}"
    ];
  };
  auth = {
    inherit (metadata.hetzner-auth) publicKey extraHostNames;
  };
  database = {
    inherit (metadata.hetzner-ash-db) publicKey extraHostNames;
  };

  # Other Hosts
  cloud = {
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILBMdlD2uBxtZLHfOUQ61JbjyLmoU4yOXSYyWG2KFrTz";
    extraHostNames = [
      "cloud.reyuzenfold.com"
      "cloud.${tailscale_domain}"
    ];
  };
  ct13719 = {
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINTmgMl+17ZpcKkGgSIlZDv/X2iQNHAQ6RWJQ5vCIZTJ";
    extraHostNames = [
      "ct13719.${tailscale_domain}"
    ];
  };
  files = {
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHtONif8fHUnxLakF6D5Solv/Xm2bN1z3d3GUrmOg0vF";
    extraHostNames = [
      "files.reyuzenfold.com"
      "files.${tailscale_domain}"
    ];
  };
  gitlab = {
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICtdO5n/P+ao2kyfDMrVmWUNe40dZpDJYiIRGaLPSzky";
    extraHostNames = [
      "gitlab.reyuzenfold.com"
    ];
  };
  mastodon = {
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHtONif8fHUnxLakF6D5Solv/Xm2bN1z3d3GUrmOg0vF";
    extraHostNames = [
      "reyuzenfold.com"
    ];
  };
  openhab = {
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFR+Ajqmtgj16Nc7Kc4DBldBQXHKGAvR6WDqulQFzpJB";
    extraHostNames = [
      "openhab.home.reyuzenfold.com"
      "openhab.${tailscale_domain}"
    ];
  };
  steamdeck = {
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINnyBQsKM1xbT9+kqPSezrHyxHM7/rzqx89vwaHMliRo";
    extraHostNames = [
      "steamdeck.${tailscale_domain}"
    ];
  };
}
