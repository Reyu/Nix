{ self, inputs, ... }:

let
  commonModules = with self.nixosModules; [
    ./configuration.nix
  ];
in
{
  base = {
    modules = commonModules;
  };
}
