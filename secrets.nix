let
  # Users
  reyu = "age1a0mk869v4lmcsy36rm432e9mfprsnsakhhyscl0p7uttrk583q3qlqm8j3";

  # knownHosts
  hosts = builtins.mapAttrs (_: x: x.publicKey) (
    import ./modules/openssh/knownHosts.nix { self = ./.; }
  );

  # Hosts generating Lets Encrypt certs
  acme = [
    reyu
    hosts.auth
    hosts.ash-db
  ];
in
with hosts;
{

  # Burrow
  "hosts/burrow/secrets/romm.env".publicKeys = [
    reyu
    burrow
  ];

  # Loki
  "hosts/loki/secrets/davfs2".publicKeys = [
    reyu
    loki
  ];
  "secrets/syncoid/ssh_key".publicKeys = [
    reyu
    loki
  ];

  # Auth (Ash)
  "hosts/hetzner/secrets/auth/ldap.keytab".publicKeys = [
    reyu
    auth
  ];
  "hosts/hetzner/secrets/auth/ash/host.keytab".publicKeys = [
    reyu
    ash-db
  ];
  "hosts/hetzner/secrets/auth/ash/psql.keytab".publicKeys = [
    reyu
    ash-db
  ];
  "hosts/hetzner/secrets/auth/cachix-agent.token".publicKeys = [
    reyu
    auth
  ];
  "hosts/hetzner/secrets/openldap/rootpw".publicKeys = [
    reyu
    auth
  ];
  "hosts/hetzner/secrets/krb5/kdb5.stash".publicKeys = [
    reyu
    auth
  ];

  # Database (Ash)
  "hosts/hetzner/secrets/database/pg_hba_ldap".publicKeys = [
    reyu
    ash-db
  ];
  "hosts/hetzner/secrets/database/ash/host.keytab".publicKeys = [
    reyu
    ash-db
  ];
  "hosts/hetzner/secrets/database/ash/psql.keytab".publicKeys = [
    reyu
    ash-db
  ];
  "hosts/hetzner/secrets/database/ash/cachix-agent.token".publicKeys = [
    reyu
    ash-db
  ];

  # Shared
  "secrets/acme/hetzner_apikey".publicKeys = acme;
  "secrets/networks/wpa_supplicant.env".publicKeys = [
    reyu
    traveler
  ];

  # Storage
  "hosts/hetzner/secrets/krb5/master_password".publicKeys = [ reyu ];
}
