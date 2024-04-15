{ self, pkgs, ... }: {
  config = {
    programs.ssh = {
      package = pkgs.openssh_gssapi;
      knownHosts = import ./knownHosts.nix { inherit self; };
    };
    services.openssh = {
      enable = true;
      startWhenNeeded = true;
    };
  };
}
