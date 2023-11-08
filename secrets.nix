let
  # Users
  reyu = "age1a0mk869v4lmcsy36rm432e9mfprsnsakhhyscl0p7uttrk583q3qlqm8j3";

  # Hosts
  home = [ loki burrow ];
  loki = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP5RyYh6rTQJrsriGzONG4Dt0cb3Y3047KSFlylzm2zZ";
  burrow = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMTxnWiWCer2tijhkTDA9RfxELHy0/HxY7zA8VgbnnFl";
  traveler = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFhbhOKgiYOV65i4DVIHjjeiDI6OSHc/6ci1nIb7j99v";

  consul-ash = [ consul-ash-01 ];
  consul-ash-01 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEMqfVGp3BXqPu2927qlyuQcufcoxjbyu+R9M/NnsM1r";
in
{
  "hosts/burrow/secrets/romm.env".publicKeys = [ reyu burrow ];
  "hosts/burrow/secrets/consul.hcl".publicKeys = [ reyu burrow ];
  "hosts/burrow/secrets/nomad-consul.hcl".publicKeys = [ reyu burrow ];
  "hosts/burrow/secrets/nomad-vault.hcl".publicKeys = [ reyu burrow ];
  "hosts/burrow/secrets/vault-storage.hcl".publicKeys = [ reyu burrow ];

  "hosts/loki/secrets/davfs2".publicKeys = [ reyu loki ];

  "secrets/consul/encrypt.hcl".publicKeys = [ reyu ] ++ home ++ consul-ash;
  "secrets/networks/wpa_supplicant.env".publicKeys = [ reyu traveler ];
  "secrets/nomad/encrypt.hcl".publicKeys = [ reyu ] ++ home;
}
