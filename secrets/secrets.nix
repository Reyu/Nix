let
  # Users
  reyu = "age1a0mk869v4lmcsy36rm432e9mfprsnsakhhyscl0p7uttrk583q3qlqm8j3";

  # Hosts
  home = [ loki burrow ];
  loki = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP5RyYh6rTQJrsriGzONG4Dt0cb3Y3047KSFlylzm2zZ";
  burrow = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMTxnWiWCer2tijhkTDA9RfxELHy0/HxY7zA8VgbnnFl";
  traveler = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFhbhOKgiYOV65i4DVIHjjeiDI6OSHc/6ci1nIb7j99v";

  fg-mastodon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL45BLcH/buNSmOqAHgkhz+CFW7Xass93CZsxkdxLCGo";
in
{
  "burrow/romm.env".publicKeys = [ reyu burrow ];
  "consul/burrow.hcl".publicKeys = [ reyu burrow ];
  "consul/encrypt.hcl".publicKeys = [ reyu ] ++ home;
  "linode/fg-mastodon.db.pass".publicKeys = [ reyu fg-mastodon ];
  "linode/fg-mastodon.smtp.pass".publicKeys = [ reyu fg-mastodon ];
  "loki/davfs2_secrets".publicKeys = [ reyu loki ];
  "networks/wpa_supplicant.env".publicKeys = [ reyu traveler ];
  "nomad/burrow-consul.hcl".publicKeys = [ reyu burrow ];
  "nomad/burrow-vault.hcl".publicKeys = [ reyu burrow ];
  "nomad/encrypt.hcl".publicKeys = [ reyu ] ++ home;
  "vault/burrow-storage.hcl".publicKeys = [ reyu burrow ];
}

