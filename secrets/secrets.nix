let
  # Users
  reyu = "age1a0mk869v4lmcsy36rm432e9mfprsnsakhhyscl0p7uttrk583q3qlqm8j3";

  # Hosts
  home = [ loki burrow ];
  loki = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP5RyYh6rTQJrsriGzONG4Dt0cb3Y3047KSFlylzm2zZ";
  burrow = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMTxnWiWCer2tijhkTDA9RfxELHy0/HxY7zA8VgbnnFl";
in
{
  "consul/encrypt.hcl".publicKeys = [ reyu ] ++ home;
  "consul/burrow.hcl".publicKeys = [ reyu burrow ];
  "nomad/burrow-consul.hcl".publicKeys = [ reyu burrow ];
  "nomad/burrow-vault.hcl".publicKeys = [ reyu burrow ];
  "nomad/encrypt.hcl".publicKeys = [ reyu ] ++ home;
  "vault/burrow-storage.hcl".publicKeys = [ reyu burrow ];
}

