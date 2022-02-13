let
  # Users
  reyu = "age1a0mk869v4lmcsy36rm432e9mfprsnsakhhyscl0p7uttrk583q3qlqm8j3";

  # Hosts
  home = [ loki burrow ];
  loki = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKnHNzgn/8WNjzUpjBJe3fWe7lFkvT8/v0nwEqvEtiOb";
  burrow = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMTxnWiWCer2tijhkTDA9RfxELHy0/HxY7zA8VgbnnFl";

  # Linode
  linode = [ consul-1gu3 consul-Xk8i consul-jw88 ];
  consul-1gu3 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB3ePSIUT3YMIqolIh9T52JSkU6PcW63ld1ZeKr9NdJo";
  consul-Xk8i = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA5W4gOzh6qiATMG2JyklNUhTQCZXEXrHX1Ewb/tPmnh";
  consul-jw88 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOfpNWcXCY6azaE3Lrcdj9HzCmpqeriM4iRLz3EBMz6B";
in {
  "consul/encrypt.hcl".publicKeys = [ reyu ] ++ home ++ linode;
  "nomad/burrow-consul.hcl".publicKeys = [ reyu burrow ];
  "nomad/burrow-vault.hcl".publicKeys = [ reyu burrow ];
  "nomad/encrypt.hcl".publicKeys = [ reyu ] ++ home;
  "vault/burrow-storage.hcl".publicKeys = [ reyu burrow ];
}

