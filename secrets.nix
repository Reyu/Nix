let
  # Users
  reyu = "age1a0mk869v4lmcsy36rm432e9mfprsnsakhhyscl0p7uttrk583q3qlqm8j3";

  # knownHosts
  hosts = builtins.mapAttrs (_: x: x.publicKey) (import ./modules/openssh/knownHosts.nix);

  # Hosts generating Lets Encrypt certs
  acme = [ reyu hosts.auth ];
in with hosts;
{
  "hosts/burrow/secrets/romm.env".publicKeys = [ reyu burrow ];
  "hosts/loki/secrets/davfs2".publicKeys = [ reyu loki ];
  "hosts/hetzner/secrets/openldap/rootpw".publicKeys = [ reyu auth ];
  "hosts/hetzner/secrets/krb5/ldap_service_password".publicKeys = [ reyu auth ];
  "secrets/syncoid/ssh_key".publicKeys = [ reyu loki ];
  "secrets/networks/wpa_supplicant.env".publicKeys = [ reyu traveler ];
  "secrets/acme/hetzner_apikey".publicKeys = acme;
}
