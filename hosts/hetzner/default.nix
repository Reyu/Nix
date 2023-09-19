{ self, inputs, ... }:

let
  commonModules = with self.nixosModules; [
    ./configuration.nix
    inputs.impermanence.nixosModules.impermanence
    hetzner
  ];
in
{
  base = {
    modules = commonModules;
  };
}
