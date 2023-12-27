{ self, inputs, ... }:

let
  commonModules = with self.nixosModules; [
    inputs.impermanence.nixosModules.impermanence
    ./configuration.nix
    hetzner
  ];
in
{
  base = {
    modules = commonModules;
  };
  auth01 = {
    modules = commonModules ++ [
      ./auth.nix
      self.nixosModules.acme
    ];
  };
}
