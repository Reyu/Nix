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
  consul = {
    modules = commonModules ++ (with self.nixosModules; [
        consul
    ]);
  };
  vault = {
    modules = commonModules ++ (with self.nixosModules; [
        consul
        vault
    ]);
  };
  nomad = {
    modules = commonModules ++ (with self.nixosModules; [
        consul
        vault
        nomad
    ]);
  };
}
