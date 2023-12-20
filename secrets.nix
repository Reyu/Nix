let
  # Users
  reyu = "age1a0mk869v4lmcsy36rm432e9mfprsnsakhhyscl0p7uttrk583q3qlqm8j3";

  # Hosts
  home = [ loki burrow ];
  loki = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP5RyYh6rTQJrsriGzONG4Dt0cb3Y3047KSFlylzm2zZ";
  burrow = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMTxnWiWCer2tijhkTDA9RfxELHy0/HxY7zA8VgbnnFl";
  traveler = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFhbhOKgiYOV65i4DVIHjjeiDI6OSHc/6ci1nIb7j99v";
in
{
  "hosts/burrow/secrets/romm.env".publicKeys = [ reyu burrow ];
  "hosts/loki/secrets/davfs2".publicKeys = [ reyu loki ];
  "secrets/networks/wpa_supplicant.env".publicKeys = [ reyu traveler ];
}
