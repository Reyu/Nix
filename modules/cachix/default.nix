{ lib, config, ... }:

let
  folder = ./cachix;
  toImport = name: _: folder + ("/" + name);
  filterCaches = key: value: value == "regular" && lib.hasSuffix ".nix" key;
  imports = lib.mapAttrsToList toImport (lib.filterAttrs filterCaches (builtins.readDir folder));
in
{
  inherit imports;
  nix.settings.substituters = [ "https://cache.nixos.org/" ];
  # Enable Cachix deploy agent, if we have a token for it.
  services.cachix-agent.enable = lib.mkIf (lib.elem "cachix-agent.token" (builtins.attrNames config.age.secrets)) true;
}
